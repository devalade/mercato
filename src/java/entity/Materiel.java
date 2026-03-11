package entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.Min;
import java.io.Serializable;
import java.util.Date;
import java.util.Calendar;

@Entity
public class Materiel implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String reference;

    private String designation;

    private String categorie;

    @Temporal(TemporalType.DATE)
    private Date dateIntroduction;

    @Temporal(TemporalType.DATE)
    private Date dateAchat;

    @Min(value = 0, message = "La quantité ne peut pas être négative")
    private int quantiteStock;

    private int dureeVieJours;

    @Temporal(TemporalType.DATE)
    private Date dateExpiration;

    @Enumerated(EnumType.STRING)
    private StatutMateriel statut;

    public Materiel() {
        this.dateIntroduction = new Date();
        this.statut = StatutMateriel.EN_STOCK;
    }

    public void calculerDateExpiration() {
        if (dateAchat != null && dureeVieJours > 0) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(dateAchat);
            cal.add(Calendar.DAY_OF_MONTH, dureeVieJours);
            this.dateExpiration = cal.getTime();
        }
    }

    public boolean estExpirantDans(int jours) {
        if (dateExpiration == null) return false;
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, jours);
        return dateExpiration.before(cal.getTime()) && dateExpiration.after(new Date());
    }

    public long getJoursRestants() {
        if (dateExpiration == null) return -1;
        long diff = dateExpiration.getTime() - new Date().getTime();
        return diff / (1000 * 60 * 60 * 24);
    }

    // Getters et Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public Date getDateIntroduction() {
        return dateIntroduction;
    }

    public void setDateIntroduction(Date dateIntroduction) {
        this.dateIntroduction = dateIntroduction;
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat = dateAchat;
    }

    public int getQuantiteStock() {
        return quantiteStock;
    }

    public void setQuantiteStock(int quantiteStock) {
        this.quantiteStock = quantiteStock;
    }

    public int getDureeVieJours() {
        return dureeVieJours;
    }

    public void setDureeVieJours(int dureeVieJours) {
        this.dureeVieJours = dureeVieJours;
    }

    public Date getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(Date dateExpiration) {
        this.dateExpiration = dateExpiration;
    }

    public StatutMateriel getStatut() {
        return statut;
    }

    public void setStatut(StatutMateriel statut) {
        this.statut = statut;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Materiel)) {
            return false;
        }
        Materiel other = (Materiel) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Materiel[ id=" + id + " ]";
    }
}
