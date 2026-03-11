package service;

import entity.Utilisateur;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;
import java.util.Optional;
import jakarta.ejb.Stateless;

@Stateless
public class UtilisateurService {

    @PersistenceContext(unitName = "mercatoPU")
    private EntityManager em;

    public Optional<Utilisateur> authentifier(String username, String password) {
        TypedQuery<Utilisateur> query = em.createQuery(
            "SELECT u FROM Utilisateur u WHERE u.username = :username AND u.password = :password",
            Utilisateur.class);
        query.setParameter("username", username);
        query.setParameter("password", password);
        
        try {
            Utilisateur user = query.getSingleResult();
            return Optional.of(user);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Transactional
    public Utilisateur creerUtilisateur(String username, String password, String role) {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setUsername(username);
        utilisateur.setPassword(password);
        utilisateur.setRole(role);
        em.persist(utilisateur);
        return utilisateur;
    }
}
