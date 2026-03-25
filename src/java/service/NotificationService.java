package service;

import entity.Materiel;
import jakarta.annotation.PostConstruct;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.inject.Inject;
import jakarta.json.Json;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObjectBuilder;
import jakarta.ws.rs.sse.Sse;
import jakarta.ws.rs.sse.SseEventSink;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

@Singleton
@Startup
public class NotificationService implements Serializable {

    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());
    private static final long serialVersionUID = 1L;

    @Inject
    private MaterielService materielService;

    private transient List<SseEventSink> clients = new CopyOnWriteArrayList<>();
    private transient Sse sseInstance;

    private List<AlertNotification> notifications = new ArrayList<>();

    @PostConstruct
    public void init() {
        LOGGER.info("NotificationService initialisé");
        try {
            verifierExpirations();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Impossible devérifier les expirations au démarrage: {0}", e.getMessage());
        }
    }

    public void addClient(SseEventSink eventSink, Sse sse) {
        clients.add(eventSink);
        this.sseInstance = sse;
        LOGGER.info("Client SSE ajouté. Total clients: " + clients.size());
        
        try {
            JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
            for (AlertNotification alert : notifications) {
                arrayBuilder.add(toJson(alert));
            }
            
            if (eventSink.isClosed()) {
                clients.remove(eventSink);
                return;
            }
            
            eventSink.send(sse.newEventBuilder()
                    .name("init")
                    .data(arrayBuilder.build().toString())
                    .build());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Erreur lors de l'envoi init au client: {0}", e.getMessage());
            clients.remove(eventSink);
        }
    }

    public void removeClient(SseEventSink eventSink) {
        clients.remove(eventSink);
        LOGGER.info("Client SSE retiré. Total clients: " + clients.size());
    }

    @Schedule(minute = "*/1", hour = "*", persistent = false)
    public void verifierExpirations() {
        LOGGER.info("Vérification des expirations à " + new Date());
        
        List<Materiel> materielsExpirants = materielService.getMaterielsExpirantDans(60);
        notifications.clear();
        
        for (Materiel materiel : materielsExpirants) {
            long joursRestants = materiel.getJoursRestants();
            String niveau = joursRestants < 30 ? "URGENT" : "WARNING";
            String message = String.format("%s expire dans %d jours", 
                materiel.getDesignation(), joursRestants);
            
            AlertNotification alert = new AlertNotification(
                materiel.getId(),
                materiel.getReference(),
                message,
                niveau,
                new Date()
            );
            notifications.add(alert);
            
            LOGGER.log(Level.WARNING, "ALERTE {0}: {1} (Réf: {2})", 
                new Object[]{niveau, message, materiel.getReference()});
        }
        
        LOGGER.info("Vérification terminée. " + notifications.size() + " alerte(s) trouvée(s)");
        
        broadcastToClients();
    }

    private void broadcastToClients() {
        if (clients.isEmpty()) {
            return;
        }
        try {
            JsonArrayBuilder arrayBuilder = Json.createArrayBuilder();
            for (AlertNotification alert : notifications) {
                arrayBuilder.add(toJson(alert));
            }
            
            String jsonData = arrayBuilder.build().toString();
            
            List<SseEventSink> closedClients = new ArrayList<>();
            
            for (SseEventSink client : clients) {
                try {
                    if (!client.isClosed()) {
                        client.send(sseInstance.newEventBuilder()
                                .name("alertes")
                                .data(jsonData)
                                .build());
                    } else {
                        closedClients.add(client);
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.FINE, "Client SSE déconnecté: {0}", e.getMessage());
                    closedClients.add(client);
                }
            }
            
            closedClients.forEach(clients::remove);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Erreur lors dubroadcast SSE: {0}", e.getMessage());
        }
    }

    private JsonObjectBuilder toJson(AlertNotification alert) {
        return Json.createObjectBuilder()
                .add("materielId", alert.getMaterielId())
                .add("reference", alert.getReference())
                .add("message", alert.getMessage())
                .add("niveau", alert.getNiveau())
                .add("dateAlert", alert.getDateAlert().getTime());
    }

    public List<AlertNotification> getNotifications() {
        return new ArrayList<>(notifications);
    }

    public int getNotificationCount() {
        return notifications.size();
    }

    public void clearNotifications() {
        notifications.clear();
    }

    public static class AlertNotification implements Serializable {
        private static final long serialVersionUID = 1L;
        
        private Long materielId;
        private String reference;
        private String message;
        private String niveau;
        private Date dateAlert;

        public AlertNotification(Long materielId, String reference, String message, String niveau, Date dateAlert) {
            this.materielId = materielId;
            this.reference = reference;
            this.message = message;
            this.niveau = niveau;
            this.dateAlert = dateAlert;
        }

        public Long getMaterielId() { return materielId; }
        public String getReference() { return reference; }
        public String getMessage() { return message; }
        public String getNiveau() { return niveau; }
        public Date getDateAlert() { return dateAlert; }
    }
}