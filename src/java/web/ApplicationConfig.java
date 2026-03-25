package web;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.ext.ContextResolver;
import jakarta.ws.rs.ext.ExceptionMapper;
import jakarta.ws.rs.ext.Provider;
import jakarta.ws.rs.core.Response;
import java.net.URI;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Set;

/**
 *
 * @author AnsaEssilfieJohnson
 */
public class ApplicationConfig extends jakarta.ws.rs.core.Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new java.util.HashSet<>();
        addRestResourceClasses(resources);
        addMvcControllers(resources);
        resources.add(JsonbConfigProvider.class);
        resources.add(RedirectExceptionMapper.class);
        return resources;
    }

    /**
     * Do not modify addRestResourceClasses() method.
     * It is automatically populated with
     * all resources defined in the project.
     * If required, comment out calling this method in getClasses().
     */
    private void addRestResourceClasses(Set<Class<?>> resources) {
        resources.add(AuthentificationResource.class);
        resources.add(MaterielResource.class);
        resources.add(MouvementResource.class);
        resources.add(EmployeResource.class);
        resources.add(SseNotificationResource.class);
        resources.add(ExportResource.class);
    }

    /**
     * Add Jakarta MVC controllers
     */
    private void addMvcControllers(Set<Class<?>> resources) {
        resources.add(LoginController.class);
        resources.add(LogoutController.class);
        resources.add(DashboardController.class);
        resources.add(MaterielController.class);
        resources.add(EmployeController.class);
    }

    @Provider
    @Produces(MediaType.APPLICATION_JSON)
    public static class JsonbConfigProvider implements ContextResolver<Jsonb> {
        private final Jsonb jsonb;

        public JsonbConfigProvider() {
            JsonbConfig config = new JsonbConfig();
            this.jsonb = JsonbBuilder.create(config);
        }

        @Override
        public Jsonb getContext(Class<?> type) {
            return jsonb;
        }
    }

    /**
     * Exception mapper for RedirectException to handle redirects in MVC controllers
     */
    @Provider
    public static class RedirectExceptionMapper implements ExceptionMapper<RedirectException> {
        @Override
        public Response toResponse(RedirectException exception) {
            return exception.getResponse();
        }
    }
}
