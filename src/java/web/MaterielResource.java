package web;

import entity.Materiel;
import entity.StatutMateriel;
import jakarta.inject.Inject;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import service.MaterielService;

@Path("/materiels")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class MaterielResource {

    @Inject
    private MaterielService materielService;

    @GET
    public List<Materiel> listerMateriels() {
        return materielService.listerMateriels();
    }

    @GET
    @Path("/{id}")
    public Response getMateriel(@PathParam("id") Long id) {
        Materiel materiel = materielService.getMateriel(id);
        if (materiel == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"Matériel non trouvé\"}")
                    .build();
        }
        return Response.ok(materiel).build();
    }

    @POST
    public Response creerMateriel(Materiel materiel) {
        try {
            Materiel created = materielService.creerMateriel(materiel);
            return Response.status(Response.Status.CREATED).entity(created).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @PUT
    @Path("/{id}")
    public Response modifierMateriel(@PathParam("id") Long id, Materiel materiel) {
        try {
            Materiel updated = materielService.modifierMateriel(id, materiel);
            return Response.ok(updated).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @DELETE
    @Path("/{id}")
    public Response archiverMateriel(@PathParam("id") Long id) {
        try {
            materielService.archiverMateriel(id);
            return Response.ok("{\"message\": \"Matériel archivé avec succès\"}").build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/alertes")
    public List<Materiel> getAlertes() {
        return materielService.getMaterielsExpirantDans(60);
    }

    @GET
    @Path("/search")
    public List<Materiel> rechercher(
            @QueryParam("categorie") String categorie,
            @QueryParam("statut") String statut) {
        
        if (categorie != null && !categorie.isEmpty()) {
            return materielService.rechercherParCategorie(categorie);
        }
        if (statut != null && !statut.isEmpty()) {
            try {
                StatutMateriel stat = StatutMateriel.valueOf(statut);
                return materielService.rechercherParStatut(stat);
            } catch (IllegalArgumentException e) {
                return List.of();
            }
        }
        return materielService.listerMateriels();
    }
}
