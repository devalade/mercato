package web;

import entity.Employe;
import entity.Mouvement;
import jakarta.enterprise.context.RequestScoped;
import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import service.EmployeService;
import service.MouvementService;

import java.util.List;

@Controller
@RequestScoped
@Path("/employes")
public class EmployeController extends BaseController {

    @Inject
    private EmployeService employeService;

    @Inject
    private MouvementService mouvementService;

    @Inject
    private Models models;

    // ========== LIST EMPLOYES ==========

    @GET
    public Response listEmployes() {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        List<Employe> employes = employeService.listerEmployes();
        models.put("employes", employes);
        models.put("pageTitle", "Liste des Employés");
        models.put("contentPage", "/WEB-INF/views/employes/list.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== SHOW NEW FORM ==========

    @GET
    @Path("/new")
    public Response showNewForm() {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        models.put("pageTitle", "Nouvel Employé");
        models.put("contentPage", "/WEB-INF/views/employes/form.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== CREATE EMPLOYE ==========

    @POST
    @Path("/create")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response createEmploye(
            @FormParam("matricule") String matricule,
            @FormParam("nom") String nom,
            @FormParam("prenom") String prenom,
            @FormParam("service") String service) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        try {
            Employe employe = new Employe();
            employe.setMatricule(matricule);
            employe.setNom(nom);
            employe.setPrenom(prenom);
            employe.setService(service);

            employeService.creerEmploye(employe);
            setSuccessMessage("Employé créé avec succès");
            return redirect("/employes");
        } catch (Exception e) {
            setErrorMessage("Erreur: " + e.getMessage());
            return redirect("/employes");
        }
    }

    // ========== SHOW DETAIL ==========

    @GET
    @Path("/{id}")
    public Response showDetail(@PathParam("id") Long id) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            setErrorMessage("Employé non trouvé");
            return redirect("/employes");
        }

        List<Mouvement> mouvements = mouvementService.getMouvementsParEmploye(id);

        models.put("employe", employe);
        models.put("mouvements", mouvements);
        models.put("pageTitle", "Détail Employé");
        models.put("contentPage", "/WEB-INF/views/employes/detail.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== SHOW EDIT FORM ==========

    @GET
    @Path("/{id}/edit")
    public Response showEditForm(@PathParam("id") Long id) {
        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            setErrorMessage("Employé non trouvé");
            return redirect("/employes");
        }

        models.put("employe", employe);
        models.put("pageTitle", "Modifier Employé");
        models.put("contentPage", "/WEB-INF/views/employes/form.jsp");

        return Response.ok("/WEB-INF/views/template.jsp").build();
    }

    // ========== UPDATE EMPLOYE ==========

    @POST
    @Path("/update")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response updateEmploye(
            @FormParam("id") Long id,
            @FormParam("nom") String nom,
            @FormParam("prenom") String prenom,
            @FormParam("service") String service) {

        Response authResponse = checkAuthentication();
        if (authResponse != null) {
            return authResponse;
        }

        Employe employe = employeService.getEmploye(id);
        if (employe == null) {
            setErrorMessage("Employé non trouvé");
            return redirect("/employes");
        }

        employe.setNom(nom);
        employe.setPrenom(prenom);
        employe.setService(service);

        // Note: Matricule typically shouldn't be changed

        employeService.updateEmploye(employe);
        setSuccessMessage("Employé modifié avec succès");
        return redirect("/employes");
    }
}
