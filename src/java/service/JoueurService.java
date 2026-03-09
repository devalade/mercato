package service;

import entity.Joueur;
import jakarta.enterprise.context.SessionScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.io.Serializable;
import java.util.List;
import web.RegisterForm;

/**
 *
 * @author AnsaEssilfieJohnson
 */

@SessionScoped
public class JoueurService implements Serializable{
    
    @PersistenceContext
    EntityManager em;
    
    @Transactional
    public Joueur enregistrer(Joueur joueur) {
        em.persist(joueur);
        return joueur;        
    }
    
    public List<Joueur> lister() {
        String query = "SELECT j FROM Joueur j";
        return em.createQuery(query, Joueur.class)
                .getResultList();
    }
    
    public Joueur getJoueur(long id) {
        return em.find(Joueur.class, id);
    } 
    
    public Joueur enregistrerForm(RegisterForm form) {
        Joueur j = new Joueur();
        j.setNom(form.getNom());
        j.setPrenom(form.getPrenom());
        j.setDateNais(form.getDateNais());
        j.setPoste(form.getPoste());
        return enregistrer(j);
    }
}
