package service;

import entity.Materiel;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.Resource;
import jakarta.ejb.Schedule;
import jakarta.ejb.Singleton;
import jakarta.ejb.Startup;
import jakarta.ejb.Timeout;
import jakarta.ejb.Timer;
import jakarta.ejb.TimerConfig;
import jakarta.ejb.TimerService;
import jakarta.inject.Inject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@Singleton
@Startup
public class NotificationService implements Serializable {

    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());
    private static final long serialVersionUID = 1L;

    @Inject
    private MaterielService materielService;

    @Resource
    private TimerService timerService;

    private List<AlertNotification> notifications = new ArrayList<>();

    @PostConstruct
    public void init() {
        LOGGER.info("NotificationService initialisé");
        try {
            verifierExpirations();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Impossible de vérifier les expirations au démarrage: {0}", e.getMessage());
        }
    }

    @Schedule(hour = "8", minute = "0", persistent = false)
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