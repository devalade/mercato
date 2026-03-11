package web;

import entity.Employe;
import entity.Mouvement;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.EmployeService;
import service.MouvementService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EmployeController", urlPatterns = {
    "/employes", "/employes/new", "/employes/create",
    "/employes/edit", "/employes/update"
})
public class EmployeController extends HttpServlet {

    @Inject
    private EmployeService employeService;
    
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
            if ("/employes".equals(path) && extraPath == null) {
                listEmployes(request, response);
            } else if ("/employes/new".equals(path)) {
                showNewForm(request, response);
            } else if ("/employes/edit".equals(path) || (extraPath != null && extraPath.contains("/edit"))) {
                showEditForm(request, response);
            } else if (extraPath != null && extraPath.startsWith("/") && extraPath.length() > 1) {
                showDetail(request, response);
            } else {
                listEmployes(request, response);
            }
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employes");
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
            if ("/employes/create".equals(path)) {
                createEmploye(request, response);
            } else if ("/employes/update".equals(path)) {
                updateEmploye(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/employes");
            }
        } catch (Exception e) {
            setErrorMessage(request, "Erreur: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/employes");
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
    
    private void listEmployes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Employe> employes = employeService.listerEmployes();
        request.setAttribute("employes", employes);
        request.setAttribute("pageTitle", "Liste des Employés");
        request.setAttribute("contentPage", "/WEB-INF/views/employes/list.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Nouvel Employé");
        request.setAttribute("contentPage", "/WEB-INF/views/employes/form.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = extractIdFromPath(request);
        if (id == null) {
            setErrorMessage(request, "ID d'employé invalide");
            response.sendRedirect(request.getContextPath() + "/employes");
            return;
        }
        
        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            setErrorMessage(request, "Employé non trouvé");
            response.sendRedirect(request.getContextPath() + "/employes");
            return;
        }
        
        request.setAttribute("employe", employe);
        request.setAttribute("pageTitle", "Modifier Employé");
        request.setAttribute("contentPage", "/WEB-INF/views/employes/form.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = extractIdFromPath(request);
        if (id == null) {
            setErrorMessage(request, "ID d'employé invalide");
            response.sendRedirect(request.getContextPath() + "/employes");
            return;
        }
        
        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            setErrorMessage(request, "Employé non trouvé");
            response.sendRedirect(request.getContextPath() + "/employes");
            return;
        }
        
        List<Mouvement> mouvements = mouvementService.getMouvementsParEmploye(id);
        
        request.setAttribute("employe", employe);
        request.setAttribute("mouvements", mouvements);
        request.setAttribute("pageTitle", "Détail Employé");
        request.setAttribute("contentPage", "/WEB-INF/views/employes/detail.jsp");
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    private void createEmploye(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Employe employe = new Employe();
        employe.setMatricule(request.getParameter("matricule"));
        employe.setNom(request.getParameter("nom"));
        employe.setPrenom(request.getParameter("prenom"));
        employe.setService(request.getParameter("service"));
        
        employeService.creerEmploye(employe);
        setSuccessMessage(request, "Employé créé avec succès");
        response.sendRedirect(request.getContextPath() + "/employes");
    }
    
    private void updateEmploye(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long id = Long.parseLong(request.getParameter("id"));
        Employe employe = employeService.getEmploye(id);
        
        if (employe == null) {
            setErrorMessage(request, "Employé non trouvé");
            response.sendRedirect(request.getContextPath() + "/employes");
            return;
        }
        
        employe.setNom(request.getParameter("nom"));
        employe.setPrenom(request.getParameter("prenom"));
        employe.setService(request.getParameter("service"));
        
        // Note: Matricule typically shouldn't be changed
        
        employeService.updateEmploye(employe);
        setSuccessMessage(request, "Employé modifié avec succès");
        response.sendRedirect(request.getContextPath() + "/employes");
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
}