package web;

import entity.Materiel;
import entity.Mouvement;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;
import service.MaterielService;
import service.MouvementService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestScoped
@Path("/dashboard")
public class DashboardController extends BaseController {

    @Inject
    private MaterielService materielService;

    @Inject
    private MouvementService mouvementService;

    @Inject
    private Models models;

    @GET
    public String showDashboard() {
        // Check authentication
        if (!isAuthenticated()) {
            String contextPath = request.getContextPath();
            throw new RedirectException(contextPath + "/login");
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
            HttpSession session = request.getSession();
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
            models.put("totalMateriels", totalMateriels);
            models.put("enStock", enStock);
            models.put("affectes", affectes);
            models.put("alertesCount", alertesCount);
            models.put("alertesMateriels", alertesMateriels);
            models.put("categories", categories);
            models.put("recentMovements", allMovements);

            return "/WEB-INF/views/dashboard.jsp";

        } catch (Exception e) {
            models.put("errorMessage", "Erreur lors du chargement du dashboard: " + e.getMessage());
            return "/WEB-INF/views/dashboard.jsp";
        }
    }
}
