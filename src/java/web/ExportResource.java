package web;

import entity.Materiel;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.StreamingOutput;
import service.MaterielService;

import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.nio.charset.StandardCharsets;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Path("/export")
public class ExportResource {

    @Inject
    private MaterielService materielService;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @GET
    @Path("/csv")
    @Produces("text/csv")
    public Response exportCsv() {
        List<Materiel> materiels = materielService.listerMateriels();
        
        StreamingOutput output = (OutputStream out) -> {
            OutputStreamWriter writer = new OutputStreamWriter(out, StandardCharsets.UTF_8);
            writer.write('\ufeff');
            writer.write("ID;Reference;Designation;Categorie;Date Introduction;Date Achat;Quantite Stock;Duree Vie (jours);Date Expiration;Statut\n");
            
            for (Materiel m : materiels) {
                writer.write(String.format("%d;%s;%s;%s;%s;%s;%d;%d;%s;%s\n",
                    m.getId(),
                    escapeCsv(m.getReference()),
                    escapeCsv(m.getDesignation()),
                    escapeCsv(m.getCategorie()),
                    m.getDateIntroduction() != null ? m.getDateIntroduction().format(DATE_FORMATTER) : "",
                    m.getDateAchat() != null ? m.getDateAchat().format(DATE_FORMATTER) : "",
                    m.getQuantiteStock(),
                    m.getDureeVieJours(),
                    m.getDateExpiration() != null ? m.getDateExpiration().format(DATE_FORMATTER) : "",
                    m.getStatut() != null ? m.getStatut().name() : ""
                ));
            }
            writer.flush();
        };
        
        return Response.ok(output)
                .header("Content-Disposition", "attachment; filename=\"inventaire_materiels.csv\"")
                .build();
    }

    @GET
    @Path("/pdf")
    @Produces("application/pdf")
    public Response exportPdf() {
        List<Materiel> materiels = materielService.listerMateriels();
        
        StreamingOutput output = (OutputStream out) -> {
            generatePdf(materiels, out);
        };
        
        return Response.ok(output)
                .header("Content-Disposition", "attachment; filename=\"inventaire_materiels.pdf\"")
                .build();
    }

    private void generatePdf(List<Materiel> materiels, OutputStream out) {
        try {
            org.apache.pdfbox.pdmodel.PDDocument document = new org.apache.pdfbox.pdmodel.PDDocument();
            org.apache.pdfbox.pdmodel.PDPage page = new org.apache.pdfbox.pdmodel.PDPage(org.apache.pdfbox.pdmodel.common.PDRectangle.A4);
            document.addPage(page);
            
            org.apache.pdfbox.pdmodel.PDPageContentStream contentStream = 
                new org.apache.pdfbox.pdmodel.PDPageContentStream(document, page);
            
            org.apache.pdfbox.pdmodel.font.PDFont font = new org.apache.pdfbox.pdmodel.font.PDType1Font(org.apache.pdfbox.pdmodel.font.Standard14Fonts.FontName.HELVETICA);
            
            int y = 750;
            int margin = 50;
            
            contentStream.beginText();
            contentStream.setFont(font, 18);
            contentStream.newLineAtOffset(margin, y);
            contentStream.showText("INVENTAIRE DES MATERIELS");
            contentStream.endText();
            y -= 30;
            
            contentStream.beginText();
            contentStream.setFont(font, 10);
            contentStream.newLineAtOffset(margin, y);
            contentStream.showText("Date: " + java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));
            contentStream.endText();
            y -= 30;
            
            float[] colWidths = {30, 80, 150, 70, 50, 50, 60};
            String[] headers = {"ID", "Reference", "Designation", "Categorie", "Qte", "Statut", "Expiration"};
            
            contentStream.setFont(font, 9);
            int x = margin;
            for (int i = 0; i < headers.length; i++) {
                contentStream.beginText();
                contentStream.newLineAtOffset(x, y);
                contentStream.showText(headers[i]);
                contentStream.endText();
                x += colWidths[i];
            }
            y -= 5;
            
            contentStream.moveTo(margin, y);
            contentStream.lineTo(550, y);
            contentStream.stroke();
            y -= 15;
            
            contentStream.setFont(font, 8);
            for (Materiel m : materiels) {
                if (y < 50) {
                    contentStream.close();
                    page = new org.apache.pdfbox.pdmodel.PDPage(org.apache.pdfbox.pdmodel.common.PDRectangle.A4);
                    document.addPage(page);
                    contentStream = new org.apache.pdfbox.pdmodel.PDPageContentStream(document, page);
                    y = 750;
                }
                
                x = margin;
                String[] row = {
                    String.valueOf(m.getId()),
                    truncate(m.getReference(), 10),
                    truncate(m.getDesignation(), 25),
                    truncate(m.getCategorie(), 12),
                    String.valueOf(m.getQuantiteStock()),
                    m.getStatut() != null ? truncate(m.getStatut().name(), 10) : "",
                    m.getDateExpiration() != null ? m.getDateExpiration().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yy")) : ""
                };
                
                for (int i = 0; i < row.length; i++) {
                    contentStream.beginText();
                    contentStream.newLineAtOffset(x, y);
                    contentStream.showText(row[i]);
                    contentStream.endText();
                    x += colWidths[i];
                }
                y -= 12;
            }
            
            contentStream.close();
            document.save(out);
            document.close();
        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la generation du PDF", e);
        }
    }

    private String escapeCsv(String value) {
        if (value == null) return "";
        return value.replace("\"", "\"\"");
    }

    private String truncate(String value, int maxLength) {
        if (value == null) return "";
        return value.length() > maxLength ? value.substring(0, maxLength) : value;
    }
}