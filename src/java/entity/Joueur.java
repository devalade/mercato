package entity;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import java.io.Serializable;
import java.util.Calendar;
import java.util.Date;

/**
 *
 * @author AnsaEssilfieJohnson
 */
@Entity
public class Joueur implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nom;
    private String prenom;
    @Temporal(TemporalType.DATE)
    private Date dateNais;    
    @Enumerated(EnumType.STRING)
    private Poste poste;   

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Joueur)) {
            return false;
        }
        Joueur other = (Joueur) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Joueur[ id=" + id + " ]";
    }
    
    public String getIdentity() {
        return nom + " " + prenom;
    }
    
    public int getAge() {
        if (dateNais == null) {
            throw new IllegalArgumentException("dateNais cannot be null");
        }
        Calendar birthCal = Calendar.getInstance();
        birthCal.setTime(dateNais);

        Calendar todayCal = Calendar.getInstance();

        // Vérifier date future
        if (birthCal.after(todayCal)) {
            throw new IllegalArgumentException("dateNais cannot be in the future");
        }

        int age = todayCal.get(Calendar.YEAR) - birthCal.get(Calendar.YEAR);

        // Vérifier si l'anniversaire est déjà passé cette année
        int todayMonth = todayCal.get(Calendar.MONTH);
        int birthMonth = birthCal.get(Calendar.MONTH);

        int todayDay = todayCal.get(Calendar.DAY_OF_MONTH);
        int birthDay = birthCal.get(Calendar.DAY_OF_MONTH);

        if (todayMonth < birthMonth || 
           (todayMonth == birthMonth && todayDay < birthDay)) {
            age--;
        }
        return age;
    }
    
}
