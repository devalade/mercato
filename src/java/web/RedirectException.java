package web;

import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;
import java.net.URI;

/**
 * Exception to trigger redirects in MVC controllers
 * Used when we need to redirect from a @View annotated method
 */
public class RedirectException extends WebApplicationException {

    public RedirectException(String path) {
        super(Response.seeOther(URI.create(path)).build());
    }

    public RedirectException(URI uri) {
        super(Response.seeOther(uri).build());
    }
}
