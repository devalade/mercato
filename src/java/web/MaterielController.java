package web;

import entity.Employe;
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
import service.EmployeService;
import service.MaterielService;
import service.MouvementService;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "MaterielController", urlPatterns = {
    "/materiels", "/materiels/*"
})
public class MaterielController extends HttpServlet {

    @Inject
    private MaterielService materielService;

    @Inject
    private MouvementService mouvementService;

    @Inject
    private EmployeService employeService;
    


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
            } else if ("/materiels/alertes".equals(path)) {
                showAlertes(request, response);
            } else if (extraPath != null) {
                // Check for /alertes path first
                if ("/alertes".equals(extraPath)) {
                    showAlertes(request, response);
                } else {
                    // Handle paths like /{id}, /{id}/edit, /{id}/sortie, /{id}/affectation
                    String pathRemainder = extraPath.startsWith("/") ? extraPath.substring(1) : extraPath;

                    if (pathRemainder.contains("/")) {
                        String[] parts = pathRemainder.split("/", 2);
                        String action = parts[1];

                        if ("edit".equals(action)) {
                            showEditForm(request, response);
                        } else if ("sortie".equals(action)) {
                            showSortieForm(request, response);
                        } else if ("affectation".equals(action)) {
                            showAffectationForm(request, response);
                        } else if ("entree".equals(action)) {
                            showEntreeForm(request, response);
                        } else {
                            showDetail(request, response);
                        }
                    } else {
                        // Path is just /{id} - show detail
                        showDetail(request, response);
                    }
                }
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
        String extraPath = request.getPathInfo();
        
        try {
            if ("/materiels/create".equals(path)) {
                createMateriel(request, response);
            } else if ("/materiels/update".equals(path)) {
                updateMateriel(request, response);
            } else if ("/materiels/delete".equals(path)) {
                deleteMateriel(request, response);
            } else if (extraPath != null) {
                // Handle POST to /{id}/sortie or /{id}/affectation
                String pathRemainder = extraPath.startsWith("/") ? extraPath.substring(1) : extraPath;
                
                if (pathRemainder.contains("/")) {
                    String[] parts = pathRemainder.split("/", 2);
                    String action = parts[1];
                    
                    if ("sortie".equals(action)) {
                        doSortie(request, response);
                    } else if ("affectation".equals(action)) {
                        doAffectation(request, response);
                    } else if ("entree".equals(action)) {
                        doEntree(request, response);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/materiels");
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/materiels");
                }
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
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate date = LocalDate.parse(dateAchatStr, formatter);
                materiel.setDateAchat(date.atStartOfDay());
            } catch (DateTimeParseException e) {
                // Invalid date format, skip setting date
            }
        }

        String quantiteStr = request.getParameter("quantiteStock");
        if (quantiteStr != null && !quantiteStr.isEmpty()) {
            materiel.setQuantiteStock(Integer.parseInt(quantiteStr));
        }
        
        String dureeVieStr = request.getParameter("dureeVieJours");
        if (dureeVieStr != null && !dureeVieStr.isEmpty()) {
            materiel.setDureeVieJours(Integer.parseInt(dureeVieStr));
        }
        materiel.setStatut(StatutMateriel.EN_STOCK);

        materielService.creerMateriel(materiel);
        setSuccessMessage(request, "Matériel créé avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels");
    }
    
    private void updateMateriel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            setErrorMessage(request, "ID de matériel manquant");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        Long id;
        try {
            id = Long.parseLong(idStr);
        } catch (NumberFormatException e) {
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

        materiel.setDesignation(request.getParameter("designation"));
        materiel.setCategorie(request.getParameter("categorie"));

        String dateAchatStr = request.getParameter("dateAchat");
        if (dateAchatStr != null && !dateAchatStr.isEmpty()) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                LocalDate date = LocalDate.parse(dateAchatStr, formatter);
                materiel.setDateAchat(date.atStartOfDay());
            } catch (DateTimeParseException e) {
                // Invalid date format, skip setting date
            }
        }

        String dureeVieStr = request.getParameter("dureeVieJours");
        if (dureeVieStr != null && !dureeVieStr.isEmpty()) {
            materiel.setDureeVieJours(Integer.parseInt(dureeVieStr));
        }

        materielService.modifierMateriel(id, materiel);
        setSuccessMessage(request, "Matériel modifié avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels");
    }
    
    private void deleteMateriel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            try {
                Long id = Long.parseLong(idStr);
                materielService.archiverMateriel(id);
                setSuccessMessage(request, "Matériel archivé avec succès");
            } catch (NumberFormatException e) {
                setErrorMessage(request, "ID de matériel invalide");
            }
        } else {
            setErrorMessage(request, "ID de matériel manquant");
        }
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

    // Movement methods

    private void showSortieForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        request.setAttribute("materiel", materiel);
        request.setAttribute("pageTitle", "Sortie de Stock");
        request.setAttribute("contentPage", "/WEB-INF/views/mouvements/sortie.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }

    private void showAffectationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        List<Employe> employes = employeService.listerEmployes();
        request.setAttribute("employes", employes);
        request.setAttribute("materiel", materiel);
        request.setAttribute("pageTitle", "Affectation Matériel");
        request.setAttribute("contentPage", "/WEB-INF/views/mouvements/affectation.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }

    private void doSortie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        try {
            String quantiteStr = request.getParameter("quantite");
            String commentaire = request.getParameter("commentaire");

            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage(request, "Quantité requise");
                response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/sortie");
                return;
            }

            int quantite = Integer.parseInt(quantiteStr);
            mouvementService.sortieStock(materielId, quantite, commentaire);
            setSuccessMessage(request, "Sortie de stock effectuée avec succès");
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        }
    }

    private void doAffectation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        try {
            String employeIdStr = request.getParameter("employeId");
            String quantiteStr = request.getParameter("quantite");
            String commentaire = request.getParameter("commentaire");

            if (employeIdStr == null || employeIdStr.isEmpty()) {
                setErrorMessage(request, "Employé requis");
                response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/affectation");
                return;
            }

            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage(request, "Quantité requise");
                response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/affectation");
                return;
            }

            Long employeId = Long.parseLong(employeIdStr);
            int quantite = Integer.parseInt(quantiteStr);

            mouvementService.affecterMateriel(materielId, employeId, quantite, commentaire);
            setSuccessMessage(request, "Matériel affecté avec succès");
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        }
    }

    // Entree de stock methods

    private void showEntreeForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        Materiel materiel = materielService.getMateriel(materielId);
        if (materiel == null) {
            setErrorMessage(request, "Matériel non trouvé");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        request.setAttribute("materiel", materiel);
        request.setAttribute("pageTitle", "Entrée de Stock");
        request.setAttribute("contentPage", "/WEB-INF/views/mouvements/entree.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }

    private void doEntree(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Long materielId = extractIdFromPath(request);
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }

        try {
            String quantiteStr = request.getParameter("quantite");
            String commentaire = request.getParameter("commentaire");

            if (quantiteStr == null || quantiteStr.isEmpty()) {
                setErrorMessage(request, "Quantité requise");
                response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/entree");
                return;
            }

            int quantite = Integer.parseInt(quantiteStr);
            mouvementService.entreeStock(materielId, quantite, commentaire);
            setSuccessMessage(request, "Entrée de stock effectuée avec succès");
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId + "/detail");
        }
    }
}