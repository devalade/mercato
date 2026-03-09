package web;

import entity.Joueur;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.Path;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.mvc.View;
import jakarta.ws.rs.BeanParam;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.core.MediaType;
import service.JoueurService;

/**
 * REST Web Service
 *
 * @author AnsaEssilfieJohnson
 */
@Path("form")
@RequestScoped
@Controller
public class JoueurPage {
    
    @Inject
    JoueurService svc;
    
    @Inject
    Models joueur;

    /**
     * Creates a new instance of JoueurPage
     */
    public JoueurPage() {
    }

    /**
     * Retrieves representation of an instance of web.JoueurPage
     * @param form
     */
    @POST
    @Produces(MediaType.TEXT_HTML)
    @Path("joueur/new")
    @View("joueur.jsp")
    public void enregistrerJoueur(@BeanParam RegisterForm form) {
        Joueur result = svc.enregistrerForm(form);
        joueur.put("joueur", result);
        /*
        joueur.put("nom", result.getNom());
        joueur.put("prenom", result.getPrenom());
        joueur.put("age", result.getAge());
        joueur.put("poste", result.getPoste());
        */
    }    
}
