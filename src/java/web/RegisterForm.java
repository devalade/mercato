package web;

import entity.Poste;
import jakarta.ws.rs.FormParam;
import java.util.Date;

/**
 *
 * @author AnsaEssilfieJohnson
 */
public class RegisterForm {
    
    @FormParam("nom")
    private String nom;
    
    @FormParam("prenom")
    private String prenom;
    
    @FormParam("dateNais")
    private Date dateNais;
    
    @FormParam("poste")
    private Poste poste;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Date getDateNais() {
        return dateNais;
    }

    public void setDateNais(Date dateNais) {
        this.dateNais = dateNais;
    }

    public Poste getPoste() {
        return poste;
    }

    public void setPoste(Poste poste) {
        this.poste = poste;
    }
    
    
    
}
