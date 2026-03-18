package entity;

import jakarta.json.bind.annotation.JsonbDateFormat;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.Min;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@Entity
public class Materiel implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String reference;

    private String designation;

    private String categorie;

    @JsonbDateFormat(value = "yyyy-MM-dd")
    private LocalDate dateIntroduction;

    @JsonbDateFormat(value = "yyyy-MM-dd")
    private LocalDate dateAchat;

    @Min(value = 0, message = "La quantité ne peut pas être négative")
    private int quantiteStock;

    private int dureeVieJours;

    @JsonbDateFormat(value = "yyyy-MM-dd")
    private LocalDate dateExpiration;

    @Enumerated(EnumType.STRING)
    private StatutMateriel statut;

    public Materiel() {
        this.dateIntroduction = LocalDate.now();
        this.statut = StatutMateriel.EN_STOCK;
    }

    public void calculerDateExpiration() {
        if (dateAchat != null && dureeVieJours > 0) {
            this.dateExpiration = dateAchat.plusDays(dureeVieJours);
        }
    }

    public boolean estExpirantDans(int jours) {
        if (dateExpiration == null) return false;
        LocalDate now = LocalDate.now();
        LocalDate future = now.plusDays(jours);
        return !dateExpiration.isAfter(future) && dateExpiration.isAfter(now);
    }

    public long getJoursRestants() {
        if (dateExpiration == null) return -1;
        return ChronoUnit.DAYS.between(LocalDate.now(), dateExpiration);
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

    public LocalDate getDateIntroduction() {
        return dateIntroduction;
    }

    public void setDateIntroduction(LocalDate dateIntroduction) {
        this.dateIntroduction = dateIntroduction;
    }

    public LocalDate getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(LocalDate dateAchat) {
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

    public LocalDate getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDate dateExpiration) {
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
