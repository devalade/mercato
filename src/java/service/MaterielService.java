package service;

import entity.Materiel;
import entity.StatutMateriel;
import entity.Mouvement;
import entity.TypeMouvement;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import jakarta.ejb.Stateless;

@Stateless
public class MaterielService {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Materiel creerMateriel(Materiel m) {
        m.setDateIntroduction(new Date());
        if (m.getStatut() == null) {
            m.setStatut(StatutMateriel.EN_STOCK);
        }
        
        if (m.getDateAchat() != null && m.getDureeVieJours() > 0) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(m.getDateAchat());
            cal.add(Calendar.DAY_OF_MONTH, m.getDureeVieJours());
            m.setDateExpiration(cal.getTime());
        }
        
        em.persist(m);
        
        if (m.getQuantiteStock() > 0) {
            Mouvement mouvement = new Mouvement();
            mouvement.setMateriel(m);
            mouvement.setType(TypeMouvement.ENTREE);
            mouvement.setQuantite(m.getQuantiteStock());
            mouvement.setDateMouvement(new Date());
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
        
        existing.setReference(m.getReference());
        existing.setDesignation(m.getDesignation());
        existing.setCategorie(m.getCategorie());
        existing.setDateAchat(m.getDateAchat());
        existing.setQuantiteStock(m.getQuantiteStock());
        
        boolean dureeVieChanged = existing.getDureeVieJours() != m.getDureeVieJours();
        existing.setDureeVieJours(m.getDureeVieJours());
        
        if (dureeVieChanged && existing.getDateAchat() != null && existing.getDureeVieJours() > 0) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(existing.getDateAchat());
            cal.add(Calendar.DAY_OF_MONTH, existing.getDureeVieJours());
            existing.setDateExpiration(cal.getTime());
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
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, jours);
        Date dateLimite = cal.getTime();
        Date maintenant = new Date();
        
        TypedQuery<Materiel> query = em.createQuery(
            "SELECT m FROM Materiel m WHERE m.dateExpiration IS NOT NULL " +
            "AND m.dateExpiration <= :dateLimite AND m.dateExpiration > :maintenant " +
            "AND m.statut != :horsService", Materiel.class);
        query.setParameter("dateLimite", dateLimite);
        query.setParameter("maintenant", maintenant);
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
