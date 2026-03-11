package web;

import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.ext.ContextResolver;
import jakarta.ws.rs.ext.Provider;
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
@jakarta.ws.rs.ApplicationPath("api")
public class ApplicationConfig extends jakarta.ws.rs.core.Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new java.util.HashSet<>();
        addRestResourceClasses(resources);
        resources.add(JsonbConfigProvider.class);
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
    }
    
    @Provider
    @Produces(MediaType.APPLICATION_JSON)
    public static class JsonbConfigProvider implements ContextResolver<Jsonb> {
        private final Jsonb jsonb;
        
        public JsonbConfigProvider() {
            JsonbConfig config = new JsonbConfig()
                .withDateFormat("yyyy-MM-dd'T'HH:mm:ss", null)
                .setProperty("yasson.zero.time.parse.defaulting", true);
            this.jsonb = JsonbBuilder.create(config);
        }
        
        @Override
        public Jsonb getContext(Class<?> type) {
            return jsonb;
        }
    }
}
