package web;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.sse.Sse;
import jakarta.ws.rs.sse.SseEventSink;
import java.util.logging.Logger;
import service.NotificationService;

@Path("/sse")
public class SseNotificationResource {

    private static final Logger LOGGER = Logger.getLogger(SseNotificationResource.class.getName());

    @Inject
    private NotificationService notificationService;

    @GET
    @Path("/alertes")
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public void subscribeToAlerts(SseEventSink eventSink, Sse sse) {
        LOGGER.info("New SSE client connected for alerts");
        notificationService.addClient(eventSink, sse);
    }
}