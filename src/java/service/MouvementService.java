package service;

import entity.Mouvement;
import entity.Materiel;
import entity.Employe;
import entity.StatutMateriel;
import entity.TypeMouvement;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.Date;
import java.util.List;
import jakarta.ejb.Stateless;

@Stateless
public class MouvementService {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Mouvement entreeStock(Long materielId, int quantite, String commentaire) {
        Materiel materiel = em.find(Materiel.class, materielId);
        if (materiel == null) {
            throw new IllegalArgumentException("Matériel non trouvé avec l'id: " + materielId);
        }
        
        materiel.setQuantiteStock(materiel.getQuantiteStock() + quantite);
        materiel.setStatut(StatutMateriel.EN_STOCK);
        em.merge(materiel);
        
        Mouvement mouvement = new Mouvement();
        mouvement.setMateriel(materiel);
        mouvement.setType(TypeMouvement.ENTREE);
        mouvement.setQuantite(quantite);
        mouvement.setDateMouvement(new Date());
        mouvement.setCommentaire(commentaire);
        
        em.persist(mouvement);
        return mouvement;
    }

    @Transactional
    public Mouvement sortieStock(Long materielId, int quantite, String commentaire) {
        Materiel materiel = em.find(Materiel.class, materielId);
        if (materiel == null) {
            throw new IllegalArgumentException("Matériel non trouvé avec l'id: " + materielId);
        }
        
        if (materiel.getQuantiteStock() < quantite) {
            throw new IllegalStateException("Stock insuffisant. Disponible: " + materiel.getQuantiteStock());
        }
        
        materiel.setQuantiteStock(materiel.getQuantiteStock() - quantite);
        
        if (materiel.getQuantiteStock() == 0) {
            materiel.setStatut(StatutMateriel.HORS_SERVICE);
        }
        
        em.merge(materiel);
        
        Mouvement mouvement = new Mouvement();
        mouvement.setMateriel(materiel);
        mouvement.setType(TypeMouvement.SORTIE);
        mouvement.setQuantite(quantite);
        mouvement.setDateMouvement(new Date());
        mouvement.setCommentaire(commentaire);
        
        em.persist(mouvement);
        return mouvement;
    }

    @Transactional
    public Mouvement affecterMateriel(Long materielId, Long employeId, int quantite, String commentaire) {
        Materiel materiel = em.find(Materiel.class, materielId);
        if (materiel == null) {
            throw new IllegalArgumentException("Matériel non trouvé avec l'id: " + materielId);
        }
        
        if (materiel.getQuantiteStock() < quantite) {
            throw new IllegalStateException("Stock insuffisant. Disponible: " + materiel.getQuantiteStock());
        }
        
        Employe employe = em.find(Employe.class, employeId);
        if (employe == null) {
            throw new IllegalArgumentException("Employé non trouvé avec l'id: " + employeId);
        }
        
        materiel.setQuantiteStock(materiel.getQuantiteStock() - quantite);
        materiel.setStatut(StatutMateriel.AFFECTE);
        em.merge(materiel);
        
        Mouvement mouvement = new Mouvement();
        mouvement.setMateriel(materiel);
        mouvement.setEmploye(employe);
        mouvement.setType(TypeMouvement.AFFECTATION);
        mouvement.setQuantite(quantite);
        mouvement.setDateMouvement(new Date());
        mouvement.setCommentaire(commentaire);
        
        em.persist(mouvement);
        return mouvement;
    }

    @Transactional
    public Mouvement retourMateriel(Long mouvementAffectationId, int quantite) {
        Mouvement mouvementAffectation = em.find(Mouvement.class, mouvementAffectationId);
        if (mouvementAffectation == null) {
            throw new IllegalArgumentException("Mouvement non trouvé avec l'id: " + mouvementAffectationId);
        }
        
        if (mouvementAffectation.getType() != TypeMouvement.AFFECTATION) {
            throw new IllegalArgumentException("Le mouvement specified n'est pas une affectation");
        }
        
        Materiel materiel = mouvementAffectation.getMateriel();
        materiel.setQuantiteStock(materiel.getQuantiteStock() + quantite);
        materiel.setStatut(StatutMateriel.EN_STOCK);
        em.merge(materiel);
        
        Mouvement mouvementRetour = new Mouvement();
        mouvementRetour.setMateriel(materiel);
        mouvementRetour.setEmploye(mouvementAffectation.getEmploye());
        mouvementRetour.setType(TypeMouvement.RETOUR);
        mouvementRetour.setQuantite(quantite);
        mouvementRetour.setDateMouvement(new Date());
        mouvementRetour.setCommentaire("Retour du matériel - REF: " + mouvementAffectation.getId());
        
        em.persist(mouvementRetour);
        return mouvementRetour;
    }

    public List<Mouvement> getHistoriqueMateriel(Long materielId) {
        TypedQuery<Mouvement> query = em.createQuery(
            "SELECT m FROM Mouvement m WHERE m.materiel.id = :materielId ORDER BY m.dateMouvement DESC",
            Mouvement.class);
        query.setParameter("materielId", materielId);
        return query.getResultList();
    }

    public List<Mouvement> getMouvementsParEmploye(Long employeId) {
        TypedQuery<Mouvement> query = em.createQuery(
            "SELECT m FROM Mouvement m WHERE m.employe.id = :employeId ORDER BY m.dateMouvement DESC",
            Mouvement.class);
        query.setParameter("employeId", employeId);
        return query.getResultList();
    }

    public List<Mouvement> getAllMouvements() {
        TypedQuery<Mouvement> query = em.createQuery(
            "SELECT m FROM Mouvement m ORDER BY m.dateMouvement DESC",
            Mouvement.class);
        return query.getResultList();
    }
}
