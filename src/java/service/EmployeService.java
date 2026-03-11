package service;

import entity.Employe;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.List;
import jakarta.ejb.Stateless;

@Stateless
public class EmployeService {

    @PersistenceContext
    private EntityManager em;

    @Transactional
    public Employe creerEmploye(Employe e) {
        em.persist(e);
        return e;
    }

    public Employe getEmploye(Long id) {
        return em.find(Employe.class, id);
    }

    public List<Employe> listerEmployes() {
        TypedQuery<Employe> query = em.createQuery("SELECT e FROM Employe e", Employe.class);
        return query.getResultList();
    }

    public Employe rechercherParMatricule(String matricule) {
        TypedQuery<Employe> query = em.createQuery(
            "SELECT e FROM Employe e WHERE e.matricule = :matricule", Employe.class);
        query.setParameter("matricule", matricule);
        List<Employe> results = query.getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Transactional
    public Employe updateEmploye(Employe employe) {
        return em.merge(employe);
    }
}
