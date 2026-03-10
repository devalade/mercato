package web;

import entity.Employe;
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
import service.EmployeService;

@Path("/employes")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class EmployeResource {

    @Inject
    private EmployeService employeService;

    @GET
    public List<Employe> listerEmployes() {
        return employeService.listerEmployes();
    }

    @GET
    @Path("/{id}")
    public Response getEmploye(@PathParam("id") Long id) {
        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"Employé non trouvé\"}")
                    .build();
        }
        return Response.ok(employe).build();
    }

    @POST
    public Response creerEmploye(Employe employe) {
        try {
            Employe created = employeService.creerEmploye(employe);
            return Response.status(Response.Status.CREATED).entity(created).build();
        } catch (Exception e) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }

    @GET
    @Path("/search/matricule/{matricule}")
    public Response rechercherParMatricule(@PathParam("matricule") String matricule) {
        Employe employe = employeService.rechercherParMatricule(matricule);
        if (employe == null) {
            return Response.status(Response.Status.NOT_FOUND)
                    .entity("{\"error\": \"Employé non trouvé avec le matricule: " + matricule + "\"}")
                    .build();
        }
        return Response.ok(employe).build();
    }
}
