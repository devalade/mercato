package web;

import jakarta.enterprise.context.RequestScoped;
import jakarta.mvc.Controller;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import java.net.URI;

@Controller
@RequestScoped
@Path("/logout")
public class LogoutController extends BaseController {

    @Context
    private HttpServletRequest request;

    /**
     * Handle logout - GET request
     */
    @GET
    public Response doLogout() {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        String contextPath = request.getContextPath();
        URI loginUri = URI.create(contextPath + "/login");
        return Response.seeOther(loginUri).build();
    }

    /**
     * Handle logout - POST request (form submission)
     */
    @POST
    public Response doLogoutPost() {
        return doLogout();
    }
}
