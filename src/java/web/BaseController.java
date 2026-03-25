package web;

import jakarta.inject.Inject;
import jakarta.mvc.Controller;
import jakarta.mvc.Models;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;
import java.net.URI;

/**
 * Base controller with common functionality for all MVC controllers
 */
public abstract class BaseController {

    @Inject
    protected Models models;

    @Context
    protected HttpServletRequest request;

    @Context
    protected UriInfo uriInfo;

    /**
     * Check if user is authenticated
     */
    protected boolean isAuthenticated() {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("username") != null;
    }

    /**
     * Check authentication and redirect to login if not authenticated
     * @return Response for redirect, or null if authenticated
     */
    protected Response checkAuthentication() {
        if (!isAuthenticated()) {
            String contextPath = request.getContextPath();
            URI loginUri = URI.create(contextPath + "/login");
            return Response.seeOther(loginUri).build();
        }
        return null;
    }

    /**
     * Set success message in session flash scope
     */
    protected void setSuccessMessage(String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }

    /**
     * Set error message in session flash scope
     */
    protected void setErrorMessage(String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }

    /**
     * Get current username from session
     */
    protected String getCurrentUsername() {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("username");
        }
        return null;
    }

    /**
     * Get current user role from session
     */
    protected String getCurrentRole() {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("role");
        }
        return null;
    }

    /**
     * Create redirect response to a path
     */
    protected Response redirect(String path) {
        String contextPath = request.getContextPath();
        URI redirectUri = URI.create(contextPath + path);
        return Response.seeOther(redirectUri).build();
    }

    /**
     * Create redirect response with context path
     */
    protected Response redirectToContext(String path) {
        String contextPath = request.getContextPath();
        URI redirectUri = URI.create(contextPath + path);
        return Response.seeOther(redirectUri).build();
    }
}
