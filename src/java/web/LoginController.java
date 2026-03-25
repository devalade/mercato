package web;

import entity.Utilisateur;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import java.net.URI;
import java.util.Optional;
import service.UtilisateurService;
import security.JwtUtils;

@Controller
@RequestScoped
@Path("/login")
public class LoginController extends BaseController {

    @Inject
    private UtilisateurService utilisateurService;

    @Inject
    private Models models;

    @Context
    private HttpServletRequest request;

    /**
     * Display login form
     */
    @GET
    @View("/WEB-INF/views/login.jsp")
    public void showLogin() {
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            String contextPath = request.getContextPath();
            throw new RedirectException(contextPath + "/dashboard");
        }
    }

    /**
     * Handle login form submission
     */
    @POST
    @Consumes(jakarta.ws.rs.core.MediaType.APPLICATION_FORM_URLENCODED)
    public Response doLogin(
            @FormParam("username") String username,
            @FormParam("password") String password) {

        Optional<Utilisateur> user = utilisateurService.authentifier(username, password);

        if (user.isPresent()) {
            HttpSession session = request.getSession(true);
            session.setAttribute("username", user.get().getUsername());
            session.setAttribute("role", user.get().getRole());

            String token = JwtUtils.genererToken(user.get().getUsername(), user.get().getRole());
            session.setAttribute("token", token);

            // Build redirect URI with context path
            String contextPath = request.getContextPath();
            URI dashboardUri = URI.create(contextPath + "/dashboard");
            return Response.seeOther(dashboardUri).build();
        } else {
            models.put("error", "Nom d'utilisateur ou mot de passe invalide");
            return Response.ok("/WEB-INF/views/login.jsp").build();
        }
    }
}
