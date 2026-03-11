package web;

import entity.Materiel;
import entity.Mouvement;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    @Inject
    private MaterielService materielService;
    
    @Inject
    private MouvementService mouvementService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get statistics
            List<Materiel> allMateriels = materielService.listerMateriels();
            int totalMateriels = allMateriels.size();
            int enStock = (int) allMateriels.stream()
                    .filter(m -> m.getStatut().toString().equals("EN_STOCK"))
                    .count();
            int affectes = (int) allMateriels.stream()
                    .filter(m -> m.getStatut().toString().equals("AFFECTE"))
                    .count();
            
            // Get expiration alerts (within 60 days)
            List<Materiel> alertesMateriels = materielService.getMaterielsExpirantDans(60);
            int alertesCount = alertesMateriels.size();
            
            // Update session with alert count
            session.setAttribute("alertCount", alertesCount);
            
            // Get category distribution
            Map<String, Integer> categories = new HashMap<>();
            for (Materiel m : allMateriels) {
                String cat = m.getCategorie();
                categories.put(cat, categories.getOrDefault(cat, 0) + 1);
            }
            
            // Get recent movements (last 10)
            List<Mouvement> allMovements = mouvementService.getAllMouvements();
            
            // Set attributes for JSP
            request.setAttribute("totalMateriels", totalMateriels);
            request.setAttribute("enStock", enStock);
            request.setAttribute("affectes", affectes);
            request.setAttribute("alertesCount", alertesCount);
            request.setAttribute("alertesMateriels", alertesMateriels);
            request.setAttribute("categories", categories);
            request.setAttribute("recentMovements", allMovements);
            
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors du chargement du dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
        }
    }
}