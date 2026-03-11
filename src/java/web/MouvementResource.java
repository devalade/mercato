package web;

import entity.Mouvement;
import jakarta.ejb.EJBException;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.Map;
import service.MouvementService;

@Path("/mouvements")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MouvementResource {

    @Inject
    private MouvementService mouvementService;

    @POST
    @Path("/{id}/entree")
    public Response entreeStock(@PathParam("id") Long materielId, Map<String, Object> data) {
        try {
            int quantite = ((Number) data.get("quantite")).intValue();
            String commentaire = (String) data.get("commentaire");
            
            Mouvement mouvement = mouvementService.entreeStock(materielId, quantite, commentaire);
            return Response.status(Response.Status.CREATED).entity(mouvement).build();
        } catch (IllegalArgumentException | ClassCastException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/{id}/sortie")
    public Response sortieStock(@PathParam("id") Long materielId, Map<String, Object> data) {
        try {
            int quantite = ((Number) data.get("quantite")).intValue();
            String commentaire = (String) data.get("commentaire");
            
            Mouvement mouvement = mouvementService.sortieStock(materielId, quantite, commentaire);
            return Response.status(Response.Status.CREATED).entity(mouvement).build();
        } catch (EJBException e) {
            Throwable cause = e.getCause();
            if (cause instanceof IllegalArgumentException || cause instanceof IllegalStateException) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"" + cause.getMessage() + "\"}")
                        .build();
            }
            throw e;
        } catch (IllegalArgumentException | IllegalStateException | ClassCastException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/{id}/affectation")
    public Response affecterMateriel(@PathParam("id") Long materielId, Map<String, Object> data) {
        try {
            Long employeId = ((Number) data.get("employeId")).longValue();
            int quantite = ((Number) data.get("quantite")).intValue();
            String commentaire = (String) data.get("commentaire");
            
            Mouvement mouvement = mouvementService.affecterMateriel(materielId, employeId, quantite, commentaire);
            return Response.status(Response.Status.CREATED).entity(mouvement).build();
        } catch (EJBException e) {
            Throwable cause = e.getCause();
            if (cause instanceof IllegalArgumentException || cause instanceof IllegalStateException) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity("{\"error\": \"" + cause.getMessage() + "\"}")
                        .build();
            }
            throw e;
        } catch (IllegalArgumentException | IllegalStateException | ClassCastException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @POST
    @Path("/retour/{mouvementId}")
    public Response retourMateriel(@PathParam("mouvementId") Long mouvementId, Map<String, Object> data) {
        try {
            int quantite = ((Number) data.get("quantite")).intValue();
            
            Mouvement mouvement = mouvementService.retourMateriel(mouvementId, quantite);
            return Response.status(Response.Status.CREATED).entity(mouvement).build();
        } catch (IllegalArgumentException | ClassCastException e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/{id}/historique")
    public Response getHistoriqueMateriel(@PathParam("id") Long materielId) {
        List<Mouvement> historiques = mouvementService.getHistoriqueMateriel(materielId);
        return Response.ok(historiques).build();
    }

    @GET
    @Path("/employe/{employeId}")
    public Response getMouvementsParEmploye(@PathParam("employeId") Long employeId) {
        List<Mouvement> mouvements = mouvementService.getMouvementsParEmploye(employeId);
        return Response.ok(mouvements).build();
    }
}
