package service;

import entity.Materiel;
import entity.StatutMateriel;
import entity.Mouvement;
import entity.TypeMouvement;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.ejb.Stateless;

@Stateless
public class MaterielService {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Materiel creerMateriel(Materiel m) {
        m.setDateIntroduction(LocalDateTime.now());
        if (m.getStatut() == null) {
            m.setStatut(StatutMateriel.EN_STOCK);
        }

        if (m.getDateAchat() != null && m.getDureeVieJours() > 0) {
            m.setDateExpiration(m.getDateAchat().plusDays(m.getDureeVieJours()));
        }

        em.persist(m);

        if (m.getQuantiteStock() > 0) {
            Mouvement mouvement = new Mouvement();
            mouvement.setMateriel(m);
            mouvement.setType(TypeMouvement.ENTREE);
            mouvement.setQuantite(m.getQuantiteStock());
            mouvement.setDateMouvement(LocalDateTime.now());
            mouvement.setCommentaire("Entrée en stock - création du matériel");
            em.persist(mouvement);
        }

        return m;
    }

    @Transactional
    public Materiel modifierMateriel(Long id, Materiel m) {
        Materiel existing = em.find(Materiel.class, id);
        if (existing == null) {
            throw new IllegalArgumentException("Matériel non trouvé avec l'id: " + id);
        }

        // Only update fields that are provided (not null)
        if (m.getReference() != null && !m.getReference().isEmpty()) {
            existing.setReference(m.getReference());
        }
        if (m.getDesignation() != null && !m.getDesignation().isEmpty()) {
            existing.setDesignation(m.getDesignation());
        }
        if (m.getCategorie() != null && !m.getCategorie().isEmpty()) {
            existing.setCategorie(m.getCategorie());
        }
        if (m.getDateAchat() != null) {
            existing.setDateAchat(m.getDateAchat());
        }
        if (m.getQuantiteStock() >= 0) {
            existing.setQuantiteStock(m.getQuantiteStock());
        }

        boolean dureeVieChanged = m.getDureeVieJours() > 0 && existing.getDureeVieJours() != m.getDureeVieJours();
        if (m.getDureeVieJours() > 0) {
            existing.setDureeVieJours(m.getDureeVieJours());
        }

        if (dureeVieChanged && existing.getDateAchat() != null && existing.getDureeVieJours() > 0) {
            existing.setDateExpiration(existing.getDateAchat().plusDays(existing.getDureeVieJours()));
        }

        return em.merge(existing);
    }

    public Materiel getMateriel(Long id) {
        return em.find(Materiel.class, id);
    }

    public List<Materiel> listerMateriels() {
        TypedQuery<Materiel> query = em.createQuery("SELECT m FROM Materiel m", Materiel.class);
        return query.getResultList();
    }

    public List<Materiel> rechercherParCategorie(String categorie) {
        TypedQuery<Materiel> query = em.createQuery(
            "SELECT m FROM Materiel m WHERE m.categorie = :categorie", Materiel.class);
        query.setParameter("categorie", categorie);
        return query.getResultList();
    }

    public List<Materiel> rechercherParStatut(StatutMateriel statut) {
        TypedQuery<Materiel> query = em.createQuery(
            "SELECT m FROM Materiel m WHERE m.statut = :statut", Materiel.class);
        query.setParameter("statut", statut);
        return query.getResultList();
    }

    public List<Materiel> getMaterielsExpirantDans(int jours) {
        LocalDateTime dateLimite = LocalDateTime.now().plusDays(jours);

        TypedQuery<Materiel> query = em.createQuery(
            "SELECT m FROM Materiel m WHERE m.dateExpiration IS NOT NULL " +
            "AND m.dateExpiration <= :dateLimite " +
            "AND m.statut != :horsService " +
            "ORDER BY m.dateExpiration ASC", Materiel.class);
        query.setParameter("dateLimite", dateLimite);
        query.setParameter("horsService", StatutMateriel.HORS_SERVICE);
        return query.getResultList();
    }

    @Transactional
    public Materiel archiverMateriel(Long id) {
        Materiel m = em.find(Materiel.class, id);
        if (m == null) {
            throw new IllegalArgumentException("Matériel non trouvé avec l'id: " + id);
        }
        m.setStatut(StatutMateriel.HORS_SERVICE);
        return em.merge(m);
    }
}
