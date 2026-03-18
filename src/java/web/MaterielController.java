package web;

import entity.Materiel;
import entity.Mouvement;
import entity.StatutMateriel;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.MaterielService;
import service.MouvementService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "MaterielController", urlPatterns = {
    "/materiels", "/materiels/new", "/materiels/create",
    "/materiels/edit", "/materiels/update", "/materiels/delete",
    "/materiels/detail", "/materiels/alertes"
})
public class MaterielController extends HttpServlet {

    @Inject
    private MaterielService materielService;
    
    @Inject
    private MouvementService mouvementService;
    


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        String extraPath = request.getPathInfo();
        
        try {
            if ("/materiels".equals(path) && extraPath == null) {
                listMateriels(request, response);
            } else if ("/materiels/new".equals(path)) {
                showNewForm(request, response);
            } else if ("/materiels/edit".equals(path) || (extraPath != null && extraPath.startsWith("/") && extraPath.length() > 1 && extraPath.contains("/edit"))) {
                showEditForm(request, response);
            } else if ("/materiels/detail".equals(path) || (extraPath != null && extraPath.startsWith("/") && extraPath.length() > 1 && !extraPath.contains("/edit"))) {
                showDetail(request, response);
            } else if ("/materiels/alertes".equals(path)) {
                showAlertes(request, response);
            } else {
                listMateriels(request, response);
            }
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if ("/materiels/create".equals(path)) {
                createMateriel(request, response);
            } else if ("/materiels/update".equals(path)) {
                updateMateriel(request, response);
            } else if ("/materiels/delete".equals(path)) {
                deleteMateriel(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/materiels");
            }
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels");
        }
    }
    
    private boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }
    
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }
    
    private void listMateriels(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String categorie = request.getParameter("categorie");
        String statutStr = request.getParameter("statut");
        String search = request.getParameter("search");
        
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
        
        request.setAttribute("materiels", materiels);
        request.setAttribute("categories", getCategories());
        request.setAttribute("statuts", StatutMateriel.values());
        request.setAttribute("pageTitle", "Liste des Matériels");
        request.setAttribute("contentPage", "/WEB-INF/views/materiels/list.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", getCategories());
        request.setAttribute("pageTitle", "Nouveau Matériel");
        request.setAttribute("contentPage", "/WEB-INF/views/materiels/form.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = extractIdFromPath(request);
        if (id == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        request.setAttribute("materiel", materiel);
        request.setAttribute("categories", getCategories());
        request.setAttribute("pageTitle", "Modifier Matériel");
        request.setAttribute("contentPage", "/WEB-INF/views/materiels/form.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = extractIdFromPath(request);
        if (id == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        List<Mouvement> historique = mouvementService.getHistoriqueMateriel(id);
        
        request.setAttribute("materiel", materiel);
        request.setAttribute("historique", historique);
        request.setAttribute("pageTitle", "Détail Matériel");
        request.setAttribute("contentPage", "/WEB-INF/views/materiels/detail.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showAlertes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Materiel> alertes = materielService.getMaterielsExpirantDans(60);
        request.setAttribute("alertes", alertes);
        request.setAttribute("pageTitle", "Alertes");
        request.setAttribute("contentPage", "/WEB-INF/views/materiels/alertes.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void createMateriel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Materiel materiel = new Materiel();
        materiel.setReference(request.getParameter("reference"));
        materiel.setDesignation(request.getParameter("designation"));
        materiel.setCategorie(request.getParameter("categorie"));

        String dateAchatStr = request.getParameter("dateAchat");
        if (dateAchatStr != null && !dateAchatStr.isEmpty()) {
            materiel.setDateAchat(LocalDate.parse(dateAchatStr));
        }

        materiel.setQuantiteStock(Integer.parseInt(request.getParameter("quantiteStock")));
        materiel.setDureeVieJours(Integer.parseInt(request.getParameter("dureeVieJours")));
        materiel.setStatut(StatutMateriel.EN_STOCK);

        materielService.creerMateriel(materiel);
        setSuccessMessage(request, "Matériel créé avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels");
    }
    
    private void updateMateriel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long id = Long.parseLong(request.getParameter("id"));
        Materiel materiel = materielService.getMateriel(id);

        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        materiel.setDesignation(request.getParameter("designation"));
        materiel.setCategorie(request.getParameter("categorie"));

        String dateAchatStr = request.getParameter("dateAchat");
        if (dateAchatStr != null && !dateAchatStr.isEmpty()) {
            materiel.setDateAchat(LocalDate.parse(dateAchatStr));
        }

        materiel.setDureeVieJours(Integer.parseInt(request.getParameter("dureeVieJours")));

        materielService.modifierMateriel(id, materiel);
        setSuccessMessage(request, "Matériel modifié avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels");
    }
    
    private void deleteMateriel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        materielService.archiverMateriel(id);
        setSuccessMessage(request, "Matériel archivé avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels");
    }
    
    private Long extractIdFromPath(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.length() > 1) {
            String[] parts = pathInfo.substring(1).split("/");
            try {
                return Long.parseLong(parts[0]);
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
    
    private String[] getCategories() {
        return new String[]{"Informatique", "Bureautique", "Mobilier", "Électronique", "Autre"};
    }
}