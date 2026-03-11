package web;

import entity.Employe;
import entity.Materiel;
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
import java.util.List;

@WebServlet(name = "MouvementController", urlPatterns = {
    "/materiels/*/sortie", "/materiels/*/affectation"
})
public class MouvementController extends HttpServlet {

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
        
        String pathInfo = request.getPathInfo();
        Long materielId = extractMaterielId(request);
        
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
        
        if (pathInfo != null && pathInfo.endsWith("/sortie")) {
            showSortieForm(request, response);
        } else if (pathInfo != null && pathInfo.endsWith("/affectation")) {
            showAffectationForm(request, response);
        } else {
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
        
        String pathInfo = request.getPathInfo();
        Long materielId = extractMaterielId(request);
        
        if (materielId == null) {
            setErrorMessage(request, "ID de matériel invalide");
            response.sendRedirect(request.getContextPath() + "/materiels");
            return;
        }
        
        try {
            if (pathInfo != null && pathInfo.endsWith("/sortie")) {
                doSortie(request, response, materielId);
            } else if (pathInfo != null && pathInfo.endsWith("/affectation")) {
                doAffectation(request, response, materielId);
            } else {
                response.sendRedirect(request.getContextPath() + "/materiels");
            }
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/materiels/" + materielId);
        }
    }
    
    private boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }
    
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
    
    private void showSortieForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Sortie de Stock");
        request.setAttribute("contentPage", "/WEB-INF/views/mouvements/sortie.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showAffectationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Employe> employes = employeService.listerEmployes();
        request.setAttribute("employes", employes);
        request.setAttribute("pageTitle", "Affectation Matériel");
        request.setAttribute("contentPage", "/WEB-INF/views/mouvements/affectation.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void doSortie(HttpServletRequest request, HttpServletResponse response, Long materielId)
            throws ServletException, IOException {
        
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        String commentaire = request.getParameter("commentaire");
        
        mouvementService.sortieStock(materielId, quantite, commentaire);
        setSuccessMessage(request, "Sortie de stock effectuée avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels/" + materielId);
    }
    
    private void doAffectation(HttpServletRequest request, HttpServletResponse response, Long materielId)
            throws ServletException, IOException {
        
        Long employeId = Long.parseLong(request.getParameter("employeId"));
        int quantite = Integer.parseInt(request.getParameter("quantite"));
        String commentaire = request.getParameter("commentaire");
        
        mouvementService.affecterMateriel(materielId, employeId, quantite, commentaire);
        setSuccessMessage(request, "Matériel affecté avec succès");
        response.sendRedirect(request.getContextPath() + "/materiels/" + materielId);
    }
    
    private Long extractMaterielId(HttpServletRequest request) {
        String pathInfo = request.getPathInfo();
        if (pathInfo != null) {
            String[] parts = pathInfo.split("/");
            if (parts.length >= 2) {
                try {
                    return Long.parseLong(parts[1]);
                } catch (NumberFormatException e) {
                    return null;
                }
            }
        }
        return null;
    }
}