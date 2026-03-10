package web;

import entity.Utilisateur;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import service.UtilisateurService;
import security.JwtUtils;

@Path("/auth")
public class AuthentificationResource {

    @Inject
    private UtilisateurService utilisateurService;

    @POST
    @Path("/login")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> login(Map<String, String> credentials) {
        String username = credentials.get("username");
        String password = credentials.get("password");
        
        Optional<Utilisateur> user = utilisateurService.authentifier(username, password);
        
        Map<String, String> response = new HashMap<>();
        
        if (user.isPresent()) {
            String token = JwtUtils.genererToken(user.get().getUsername(), user.get().getRole());
            response.put("token", token);
            response.put("role", user.get().getRole());
            response.put("username", user.get().getUsername());
        } else {
            response.put("error", "Nom d'utilisateur ou mot de passe invalide");
        }
        
        return response;
    }

    @POST
    @Path("/register")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String, String> register(Map<String, String> userData) {
        String username = userData.get("username");
        String password = userData.get("password");
        String role = userData.get("role");
        
        if (role == null || role.isEmpty()) {
            role = "GESTIONNAIRE";
        }
        
        Utilisateur utilisateur = utilisateurService.creerUtilisateur(username, password, role);
        
        Map<String, String> response = new HashMap<>();
        response.put("message", "Utilisateur créé avec succès");
        response.put("username", utilisateur.getUsername());
        response.put("role", utilisateur.getRole());
        
        return response;
    }
}
