package web;

import entity.Joueur;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.Path;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import service.JoueurService;

/**
 * REST Web Service
 *
 * @author AnsaEssilfieJohnson
 */
@Path("joueur")
@RequestScoped
public class JoueurResource {
    
    @Inject
    JoueurService svc;
    
    @POST
    @Path("create")
    @Consumes(MediaType.APPLICATION_JSON)
    public void enregistrer(Joueur j) {
        svc.enregistrer(j);        
    }
    
    @GET
    @Path("list")
    @Produces(MediaType.APPLICATION_JSON)
    public Response lister() {
        return Response.ok(svc.lister()).build();
    }   
    
}
