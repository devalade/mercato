package web;

import entity.Employe;
import entity.Materiel;
import entity.Mouvement;
import entity.StatutMateriel;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import service.EmployeService;
import service.MaterielService;
import service.MouvementService;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

@Controller
@RequestScoped
@Path("/materiels")
public class MaterielController extends BaseController {

    @Inject
    private MaterielService materielService;

    @Inject
    private MouvementService mouvementService;

    @Inject
    private EmployeService employeService;

    @Inject
    private Models models;

    // ========== LIST MATERIELS ==========

    @GET
    public Response listMateriels(
            @QueryParam("categorie") String categorie,
            @QueryParam("statut") String statutStr,
            @QueryParam("search") String search) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        List<Materiel> materiels;

        if (categorie != null && !categorie.isEmpty()) {
            materiels = materielService.rechercherParCategorie(categorie);
        } else if (statutStr != null && !statutStr.isEmpty()) {
            materiels = materielService.rechercherParStatut(StatutMateriel.valueOf(statutStr));
        } else if (search != null && !search.isEmpty()) {
            materiels = materielService.listerMateriels();
            // Filter by search term
            materiels.removeIf(m -> !m.getReference().toLowerCase().contains(search.toLowerCase())
                    && !m.getDesignation().toLowerCase().contains(search.toLowerCase()));
        } else {
            materiels = materielService.listerMateriels();
        }

        models.put("materiels", materiels);
        models.put("categories", getCategories());
        models.put("statuts", StatutMateriel.values());
        models.put("pageTitle", "Liste des Matériels");
        models.put("contentPage", "/WEB-INF/views/materiels/list.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== SHOW NEW FORM ==========

    @GET
    @Path("/new")
    public Response showNewForm() {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        models.put("categories", getCategories());
        models.put("pageTitle", "Nouveau Matériel");
        models.put("contentPage", "/WEB-INF/views/materiels/form.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== CREATE MATERIEL ==========

    @POST
    @Path("/create")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response createMateriel(
            @FormParam("reference") String reference,
            @FormParam("designation") String designation,
            @FormParam("categorie") String categorie,
            @FormParam("dateAchat") String dateAchatStr,
            @FormParam("quantiteStock") String quantiteStr,
            @FormParam("dureeVieJours") String dureeVieStr) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        try {
            Materiel materiel = new Materiel();
            materiel.setReference(reference);
            materiel.setDesignation(designation);
            materiel.setCategorie(categorie);

            if (dateAchatStr != null && !dateAchatStr.isEmpty()) {
                try {
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LocalDate date = LocalDate.parse(dateAchatStr, formatter);
                    materiel.setDateAchat(date.atStartOfDay());
                } catch (DateTimeParseException e) {
                    // Invalid date format, skip setting date
                }
            }

            if (quantiteStr != null && !quantiteStr.isEmpty()) {
                materiel.setQuantiteStock(Integer.parseInt(quantiteStr));
            }

            if (dureeVieStr != null && !dureeVieStr.isEmpty()) {
                materiel.setDureeVieJours(Integer.parseInt(dureeVieStr));
            }
            materiel.setStatut(StatutMateriel.EN_STOCK);

            materielService.creerMateriel(materiel);
            setSuccessMessage("Matériel créé avec succès");
            return redirect("/materiels");
        } catch (Exception e) {
            setErrorMessage("Erreur: " + e.getMessage());
            return redirect("/materiels");
        }
    }

    // ========== SHOW EDIT FORM ==========

    @GET
    @Path("/{id}/edit")
    public Response showEditForm(@PathParam("id") Long id) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        models.put("materiel", materiel);
        models.put("categories", getCategories());
        models.put("pageTitle", "Modifier Matériel");
        models.put("contentPage", "/WEB-INF/views/materiels/form.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== UPDATE MATERIEL ==========

    @POST
    @Path("/update")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response updateMateriel(
            @FormParam("id") Long id,
            @FormParam("designation") String designation,
            @FormParam("categorie") String categorie,
            @FormParam("dateAchat") String dateAchatStr,
            @FormParam("dureeVieJours") String dureeVieStr) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        if (id == null) {
            setErrorMessage("ID de matériel manquant");
            return redirect("/materiels");
        }

        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        materiel.setDesignation(designation);
        materiel.setCategorie(categorie);

        if (dateAchatStr != null && !dateAchatStr.isEmpty()) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate date = LocalDate.parse(dateAchatStr, formatter);
                materiel.setDateAchat(date.atStartOfDay());
            } catch (DateTimeParseException e) {
                // Invalid date format, skip setting date
            }
        }

        if (dureeVieStr != null && !dureeVieStr.isEmpty()) {
            materiel.setDureeVieJours(Integer.parseInt(dureeVieStr));
        }

        materielService.modifierMateriel(id, materiel);
        setSuccessMessage("Matériel modifié avec succès");
        return redirect("/materiels");
    }

    // ========== SHOW DETAIL ==========

    @GET
    @Path("/{id}")
    public Response showDetail(@PathParam("id") Long id) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        List<Mouvement> historique = mouvementService.getHistoriqueMateriel(id);

        models.put("materiel", materiel);
        models.put("historique", historique);
        models.put("pageTitle", "Détail Matériel");
        models.put("contentPage", "/WEB-INF/views/materiels/detail.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== DELETE/ARCHIVE MATERIEL ==========

    @POST
    @Path("/delete")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response deleteMateriel(@FormParam("id") Long id) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        if (id != null) {
            try {
                materielService.archiverMateriel(id);
                setSuccessMessage("Matériel archivé avec succès");
            } catch (Exception e) {
                setErrorMessage("ID de matériel invalide");
            }
        } else {
            setErrorMessage("ID de matériel manquant");
        }

        return redirect("/materiels");
    }

    // ========== SHOW ALERTES ==========

    @GET
    @Path("/alertes")
    public Response showAlertes() {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        List<Materiel> alertes = materielService.getMaterielsExpirantDans(60);
        models.put("alertes", alertes);
        models.put("pageTitle", "Alertes");
        models.put("contentPage", "/WEB-INF/views/materiels/alertes.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== SHOW SORTIE FORM ==========

    @GET
    @Path("/{id}/sortie")
    public Response showSortieForm(@PathParam("id") Long materielId) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        models.put("materiel", materiel);
        models.put("pageTitle", "Sortie de Stock");
        models.put("contentPage", "/WEB-INF/views/mouvements/sortie.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== DO SORTIE ==========

    @POST
    @Path("/{id}/sortie")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doSortie(
            @PathParam("id") Long materielId,
            @FormParam("quantite") String quantiteStr,
            @FormParam("commentaire") String commentaire) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        try {
            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage("Quantité requise");
                return redirect("/materiels/" + materielId + "/sortie");
            }

            int quantite = Integer.parseInt(quantiteStr);
            mouvementService.sortieStock(materielId, quantite, commentaire);
            setSuccessMessage("Sortie de stock effectuée avec succès");
            return redirect("/materiels/" + materielId);
        } catch (Exception e) {
            setErrorMessage("Erreur: " + e.getMessage());
            return redirect("/materiels/" + materielId);
        }
    }

    // ========== SHOW AFFECTATION FORM ==========

    @GET
    @Path("/{id}/affectation")
    public Response showAffectationForm(@PathParam("id") Long materielId) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        List<Employe> employes = employeService.listerEmployes();
        models.put("employes", employes);
        models.put("materiel", materiel);
        models.put("pageTitle", "Affectation Matériel");
        models.put("contentPage", "/WEB-INF/views/mouvements/affectation.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== DO AFFECTATION ==========

    @POST
    @Path("/{id}/affectation")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doAffectation(
            @PathParam("id") Long materielId,
            @FormParam("employeId") String employeIdStr,
            @FormParam("quantite") String quantiteStr,
            @FormParam("commentaire") String commentaire) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        try {
            if (employeIdStr == null || employeIdStr.isEmpty()) {
                setErrorMessage("Employé requis");
                return redirect("/materiels/" + materielId + "/affectation");
            }

            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage("Quantité requise");
                return redirect("/materiels/" + materielId + "/affectation");
            }

            Long employeId = Long.parseLong(employeIdStr);
            int quantite = Integer.parseInt(quantiteStr);

            mouvementService.affecterMateriel(materielId, employeId, quantite, commentaire);
            setSuccessMessage("Matériel affecté avec succès");
            return redirect("/materiels/" + materielId);
        } catch (Exception e) {
            setErrorMessage("Erreur: " + e.getMessage());
            return redirect("/materiels/" + materielId);
        }
    }

    // ========== SHOW ENTREE FORM ==========

    @GET
    @Path("/{id}/entree")
    public Response showEntreeForm(@PathParam("id") Long materielId) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage("Matériel non trouvé");
            return redirect("/materiels");
        }

        models.put("materiel", materiel);
        models.put("pageTitle", "Entrée de Stock");
        models.put("contentPage", "/WEB-INF/views/mouvements/entree.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== DO ENTREE ==========

    @POST
    @Path("/{id}/entree")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doEntree(
            @PathParam("id") Long materielId,
            @FormParam("quantite") String quantiteStr,
            @FormParam("commentaire") String commentaire) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        try {
            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage("Quantité requise");
                return redirect("/materiels/" + materielId + "/entree");
            }

            int quantite = Integer.parseInt(quantiteStr);
            mouvementService.entreeStock(materielId, quantite, commentaire);
            setSuccessMessage("Entrée de stock effectuée avec succès");
            return redirect("/materiels/" + materielId);
        } catch (Exception e) {
            setErrorMessage("Erreur: " + e.getMessage());
            return redirect("/materiels/" + materielId);
        }
    }

    private String[] getCategories() {
        return new String[]{"Informatique", "Bureautique", "Mobilier", "Électronique", "Autre"};
    }
}
