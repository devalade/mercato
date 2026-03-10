# PLAN DÉTAILLÉ - Application Inventaire Matériel
**Durée:** 2 jours | **Technos:** Jakarta EE, JPA, JAX-RS, JWT, DaisyUI

---

## 📋 STRUCTURE DU PROJET

```
src/java/
├── entity/           # Entités JPA
├── service/          # Logique métier
├── web/              # API REST + MVC Controllers
├── security/         # JWT Filter & Utils
└── resources/
    └── scripts/      # data.sql

web/
├── WEB-INF/views/    # JSP pages
├── css/              # DaisyUI + custom
└── js/               # Scripts frontend
```

---

## DAY 1 - Backend & API (8h)

### Phase 1.1: Entités JPA (1h30)
**Livrable:** Modèle de données complet et compilable

**Tâches détaillées:**
- [x] Créer `entity/StatutMateriel.java` (enum: EN_STOCK, AFFECTE, HORS_SERVICE, EXPIRE)
- [x] Créer `entity/TypeMouvement.java` (enum: ENTREE, SORTIE, AFFECTATION, RETOUR)
- [x] Créer `entity/Materiel.java`:
  - @Id, @GeneratedValue
  - reference (String, unique)
  - designation (String)
  - categorie (String)
  - dateIntroduction (Date)
  - dateAchat (Date, nullable)
  - quantiteStock (int)
  - dureeVieJours (int)
  - dateExpiration (Date, calculée)
  - statut (Enum)
- [x] Créer `entity/Employe.java`:
  - matricule (String, unique)
  - nom, prenom
  - service (String)
- [x] Créer `entity/Mouvement.java`:
  - @ManyToOne → Materiel
  - @ManyToOne → Employe (nullable)
  - type (Enum)
  - dateMouvement (Date)
  - quantite (int)
  - commentaire (String)
- [x] Créer `entity/Utilisateur.java` (pour JWT auth)
  - username, password, role
- [x] Supprimer anciennes entités: Joueur, Club, Transfert, Poste
- [x] Mettre à jour `persistence.xml`

**Validation:** `ant clean build` passe sans erreur

---

### Phase 1.2: Services Métier (2h)
**Livrable:** Services fonctionnels avec logique métier

**MaterielService.java:**
- [x] `creerMateriel(Materiel m)`:
  - Calcule dateExpiration = dateAchat + dureeVieJours
  - Persist materiel
  - Crée mouvement ENTREE automatique
  - @Transactional
- [x] `modifierMateriel(Long id, Materiel m)`:
  - Vérifie existence
  - Met à jour champs modifiables
  - Recalcule dateExpiration si dureeVie modifiée
- [x] `getMateriel(Long id)` → Materiel
- [x] `listerMateriels()` → List<Materiel>
- [x] `rechercherParCategorie(String cat)` → List<Materiel>
- [x] `rechercherParStatut(StatutMateriel statut)` → List<Materiel>
- [x] `getMaterielsExpirantDans(int jours)` → List<Materiel> (pour alertes)
- [x] `archiverMateriel(Long id)` - statut HORS_SERVICE

**EmployeService.java:**
- [x] `creerEmploye(Employe e)`
- [x] `getEmploye(Long id)`
- [x] `listerEmployes()`
- [x] `rechercherParMatricule(String matricule)`

**MouvementService.java:**
- [x] `entreeStock(Long materielId, int quantite, String commentaire)`:
  - @Transactional
  - Incrémente quantiteStock
  - Crée mouvement ENTREE
  - Met à jour statut EN_STOCK
- [x] `sortieStock(Long materielId, int quantite, String commentaire)`:
  - @Transactional
  - Vérifie quantiteStock >= quantite (sinon throw IllegalStateException)
  - Décrémente quantiteStock
  - Crée mouvement SORTIE
  - Si quantiteStock == 0 → statut HORS_SERVICE
- [x] `affecterMateriel(Long materielId, Long employeId, int quantite, String commentaire)`:
  - @Transactional
  - Vérifie stock disponible
  - Décrémente stock
  - Crée mouvement AFFECTATION
  - Met à jour statut AFFECTE
- [x] `retourMateriel(Long mouvementAffectationId, int quantite)`:
  - @Transactional
  - Vérifie mouvement existe et est AFFECTATION
  - Incrémente stock
  - Crée mouvement RETOUR
- [x] `getHistoriqueMateriel(Long materielId)` → List<Mouvement> (order by date desc)
- [x] `getMouvementsParEmploye(Long employeId)` → List<Mouvement>

**UtilisateurService.java:**
- [x] `authentifier(String username, String password)` → Optional<Utilisateur>
- [x] `creerUtilisateur(String username, String password, String role)`

**Validation:** Tests manuels via main() ou simples appels

---

### Phase 1.3: JWT Security (1h30)
**Livrable:** Authentification JWT fonctionnelle

**security/JwtUtils.java:**
- [ ] `genererToken(String username, String role)` → String (JWT)
- [ ] `validerToken(String token)` → boolean
- [ ] `extraireUsername(String token)` → String
- [ ] `extraireRole(String token)` → String

**security/JwtFilter.java:**
- [ ] @WebFilter sur /api/*
- [ ] Intercepte header Authorization: Bearer <token>
- [ ] Valide token
- [ ] Injecte utilisateur dans contexte sécurité
- [ ] Renvoie 401 si token invalide/manquant

**security/AuthentificationResource.java:**
- [ ] POST `/api/auth/login`:
  - Body: {username, password}
  - Vérifie credentials
  - Génère JWT
  - Retourne: {token, role}
- [ ] POST `/api/auth/register` (optionnel, pour créer compte)

**Configuration web.xml:**
- [ ] Déclarer JwtFilter
- [ ] Configurer security constraints

**Validation:** Tests avec curl/Postman - login retourne token, accès API protégé

---

### Phase 1.4: API REST (2h)
**Livrable:** Tous endpoints fonctionnels et testés

**MaterielResource.java** (@Path("/api/materiels")):
- [ ] @GET → List<Materiel> (JSON)
- [ ] @GET @Path("/{id}") → Materiel
- [ ] @POST → Créer matériel (body JSON)
- [ ] @PUT @Path("/{id}") → Modifier matériel
- [ ] @DELETE @Path("/{id}") → Archiver matériel
- [ ] @GET @Path("/alertes") → List<Materiel> expirant dans 60j
- [ ] @GET @Path("/search") @QueryParam("categorie") → Filtrer
- [ ] @GET @Path("/search") @QueryParam("statut") → Filtrer

**MouvementResource.java** (@Path("/api/mouvements")):
- [ ] @POST @Path("/{id}/entree") → Body: {quantite, commentaire}
- [ ] @POST @Path("/{id}/sortie") → Body: {quantite, commentaire}
- [ ] @POST @Path("/{id}/affectation") → Body: {employeId, quantite, commentaire}
- [ ] @GET @Path("/{id}/historique") → List<Mouvement> (JSON)

**EmployeResource.java** (@Path("/api/employes")):
- [ ] @GET → List<Employe>
- [ ] @GET @Path("/{id}") → Employe
- [ ] @POST → Créer employe

**web/LoginController.java** (MVC):
- [ ] @GET @Path("/login") → Affiche login.jsp
- [ ] @POST @Path("/login") → Authentifie, stocke token en session

**Validation:** Postman collection avec tous les endpoints testés

---

### Phase 1.5: Données SQL (30min)
**Livrable:** data.sql prêt pour démo

- [ ] 10 matériels variés:
  - 3 PC portables (informatique)
  - 2 Chaises (mobilier)
  - 2 Imprimantes (bureautique)
  - 3 Autres (claviers, souris...)
- [ ] Dates d'achat variées (certains vieux pour expiration)
- [ ] 2 matériels avec dateExpiration dans < 60j (pour alertes)
- [ ] 4 employés avec services variés
- [ ] 5-6 mouvements pour traçabilité:
  - ENTREE pour chaque matériel
  - AFFECTATION pour certains
  - SORTIE pour un ou deux

**Utilisateur par défaut:**
- gestionnaire / password123 / role GESTIONNAIRE

---

## DAY 2 - Frontend & Finalisation (8h)

### Phase 2.1: Layout & DaisyUI Setup (1h)
**Livrable:** Template de base avec DaisyUI fonctionnel

**web/WEB-INF/views/template.jsp:**
- [ ] Header commun avec navigation
- [ ] Inclusion DaisyUI via CDN
- [ ] Menu responsive avec drawer
- [ ] Footer simple

**web/css/custom.css:**
- [ ] Variables de couleur thème entreprise
- [ ] Classes utilitaires pour badges statuts

**web/WEB-INF/tags/:**
- [ ] Taglib pour composants réutilisables (card, badge, button)

**Navigation structure:**
- Dashboard
- Matériels (liste)
- Employés (liste)
- Déconnexion

**Validation:** Page test avec DaisyUI s'affiche correctement

---

### Phase 2.2: Pages Authentification (45min)
**Livrable:** Login fonctionnel

**web/login.jsp:**
- [ ] Formulaire username/password
- [ ] Style DaisyUI (card centrée, inputs styled)
- [ ] Message erreur si credentials invalides
- [ ] Redirection vers dashboard si déjà authentifié

**web/WEB-INF/views/dashboard.jsp:**
- [ ] Layout avec sidebar navigation
- [ ] Zone contenu dynamique
- [ ] Affichage nom utilisateur connecté
- [ ] Bouton déconnexion

**Validation:** Login → Dashboard fonctionne, JWT stocké en session

---

### Phase 2.3: Dashboard (1h15)
**Livrable:** Dashboard avec indicateurs et alertes

**DashboardController.java:**
- [ ] @GET @Path("/dashboard") @Controller
- [ ] Injecte données: totalMatériels, enStock, affectes, alertesExpiration
- [ ] Redirige vers login si non authentifié

**dashboard.jsp:**
- [ ] Cards indicateurs (DaisyUI stats):
  - Total matériels (badge primary)
  - En stock (badge success)
  - Affectés (badge info)
  - Alertes expiration (badge error/warning si > 0)
- [ ] Tableau alertes expiration:
  - Référence, Désignation, Date expiration, Jours restants
  - Badge rouge si < 30j, orange si < 60j
- [ ] Graphique simple (optionnel - chart.js):
  - Répartition par catégorie (camembert)
  - Ou bar chart matériels par statut
- [ ] Boutons rapides:
  - "Nouveau matériel"
  - "Voir tous les matériels"

**Validation:** Dashboard affiche données réelles de la BDD

---

### Phase 2.4: Gestion Matériels (2h)
**Livrable:** CRUD complet UI

**web/WEB-INF/views/materiels/list.jsp:**
- [ ] Tableau DaisyUI avec:
  - Référence, Désignation, Catégorie, Quantité, Statut (badge coloré), Actions
- [ ] Filtres:
  - Input recherche par référence
  - Select catégorie
  - Select statut
- [ ] Bouton "Nouveau matériel"
- [ ] Pagination (si > 10 items)

**web/WEB-INF/views/materiels/form.jsp:**
- [ ] Formulaire création/modification:
  - Référence (input text)
  - Désignation (input text)
  - Catégorie (select: Informatique, Bureautique, Mobilier, Autre)
  - Date achat (input date)
  - Quantité (input number, min=1)
  - Durée de vie (jours) (input number)
  - Commentaire (textarea optionnel)
- [ ] Validation HTML5 (required, min, etc.)
- [ ] Bouton submit avec spinner (DaisyUI loading)

**web/WEB-INF/views/materiels/detail.jsp:**
- [ ] Fiche détaillée (card DaisyUI):
  - Tous les champs en lecture
  - Badges statut colorés
  - Date expiration avec alerte si proche
- [ ] Boutons actions:
  - "Modifier" → vers form.jsp
  - "Sortie stock" → vers sortie.jsp
  - "Affecter" → vers affectation.jsp (si quantité > 0)
  - "Voir historique" → vers historique.jsp
- [ ] Archiver (bouton danger)

**MaterielController.java (MVC):**
- [ ] @GET @Path("/materiels") → list.jsp
- [ ] @GET @Path("/materiels/new") → form.jsp (mode création)
- [ ] @POST @Path("/materiels") → Créer + redirect liste
- [ ] @GET @Path("/materiels/{id}") → detail.jsp
- [ ] @GET @Path("/materiels/{id}/edit") → form.jsp (mode édition)
- [ ] @POST @Path("/materiels/{id}/edit") → Modifier + redirect
- [ ] @POST @Path("/materiels/{id}/delete") → Archiver + redirect

**Validation:** CRUD complet testable via UI

---

### Phase 2.5: Mouvements & Historique (1h30)
**Livrable:** Sortie, affectation, historique fonctionnels

**web/WEB-INF/views/mouvements/sortie.jsp:**
- [ ] Affiche infos matériel (readonly)
- [ ] Input quantité (max=quantitéStock)
- [ ] Input commentaire
- [ ] Validation: quantité ≤ stock disponible
- [ ] Message confirmation avant submit

**web/WEB-INF/views/mouvements/affectation.jsp:**
- [ ] Affiche infos matériel
- [ ] Select employé (liste déroulante EmployeService.lister())
- [ ] Input quantité
- [ ] Input commentaire
- [ ] Validation: quantité ≤ stock
- [ ] Validation: employé sélectionné

**web/WEB-INF/views/mouvements/historique.jsp:**
- [ ] Timeline verticale (DaisyUI timeline component):
  - Date du mouvement
  - Type (badge coloré: ENTREE=green, SORTIE=red, AFFECTATION=blue, RETOUR=orange)
  - Quantité
  - Employé (si affectation)
  - Commentaire
- [ ] Filtre par type de mouvement
- [ ] Export bouton (optionnel)

**MouvementController.java (MVC):**
- [ ] @GET @Path("/materiels/{id}/sortie") → sortie.jsp
- [ ] @POST @Path("/materiels/{id}/sortie") → Exécuter sortie + redirect détail
- [ ] @GET @Path("/materiels/{id}/affectation") → affectation.jsp
- [ ] @POST @Path("/materiels/{id}/affectation") → Exécuter affectation + redirect historique
- [ ] @GET @Path("/materiels/{id}/historique") → historique.jsp

**Validation:** Scénario: créer matériel → affecter → voir historique avec 2 mouvements

---

### Phase 2.6: Gestion Employés (45min)
**Livrable:** CRUD employés simple

**web/WEB-INF/views/employes/list.jsp:**
- [ ] Tableau employés (matricule, nom, prénom, service)
- [ ] Bouton "Nouvel employé"

**web/WEB-INF/views/employes/form.jsp:**
- [ ] Formulaire création: matricule, nom, prénom, service

**web/WEB-INF/views/employes/detail.jsp:**
- [ ] Fiche employé
- [ ] Liste matériels affectés (avec lien vers détail matériel)

**EmployeController.java:**
- [ ] CRUD basique MVC

**Validation:** Créer employé → visible dans select affectation

---

### Phase 2.7: Notifications & Polish (1h)
**Livrable:** Système notification + UI finalisée

**service/NotificationService.java:**
- [ ] @Singleton @Startup
- [ ] @Schedule(hour="8", minute="0", persistent=false) - tous les jours 8h
- [ ] Méthode `verifierExpirations()`:
  - Appelle MaterielService.getMaterielsExpirantDans(60)
  - Pour chaque matériel: log alerte + stocker en mémoire/application scope
- [ ] Endpoint GET `/api/notifications` → liste alertes non lues

**UI Notifications:**
- [ ] Badge nombre alertes dans navbar (DaisyUI indicator)
- [ ] Dropdown notifications (DaisyUI dropdown)
- [ ] Marquer comme lu (optionnel)

**Polish UI:**
- [ ] Messages flash (success/error) après actions (DaisyUI alert)
- [ ] Loading states sur boutons submit
- [ ] Empty states (tableaux vides avec message friendly)
- [ ] Confirmation modals pour suppressions (DaisyUI modal)
- [ ] Responsive mobile (tester sur petit écran)

**Validation:** Alerte visible dans dashboard + navbar

---

### Phase 2.8: Documentation & Déploiement (1h)
**Livrable:** Documentation complète + app déployée

**API_DOCUMENTATION.md:**
```markdown
# Documentation API Inventaire Matériel

## Authentification
Tous les endpoints (sauf /api/auth/login) nécessitent header:
Authorization: Bearer <token>

### POST /api/auth/login
Body: {"username": "gestionnaire", "password": "password123"}
Response: {"token": "eyJ...", "role": "GESTIONNAIRE"}

## Matériels
### GET /api/materiels
Liste tous les matériels
Response: [{"id": 1, "reference": "PC001", ...}]

### GET /api/materiels/{id}
Détail d'un matériel
Response: {"id": 1, "reference": "PC001", ...}

### POST /api/materiels
Créer un matériel
Body: {"reference": "PC002", "designation": "...", "categorie": "Informatique", ...}

### PUT /api/materiels/{id}
Modifier un matériel
Body: même format que POST

### DELETE /api/materiels/{id}
Archiver un matériel (statut HORS_SERVICE)

### GET /api/materiels/alertes
Matériels expirant dans les 60 jours
Response: Liste matériels avec dateExpiration

### GET /api/materiels/search?categorie=Informatique
Filtrer par catégorie

### GET /api/materiels/search?statut=EN_STOCK
Filtrer par statut

## Mouvements
### POST /api/mouvements/{id}/entree
Entrée en stock
Body: {"quantite": 5, "commentaire": "..."}

### POST /api/mouvements/{id}/sortie
Sortie de stock
Body: {"quantite": 2, "commentaire": "..."}

### POST /api/mouvements/{id}/affectation
Affecter à employé
Body: {"employeId": 1, "quantite": 1, "commentaire": "..."}

### GET /api/mouvements/{id}/historique
Historique des mouvements d'un matériel
Response: [{"id": 1, "type": "ENTREE", "dateMouvement": "...", ...}]

## Employés
### GET /api/employes
Liste employés

### POST /api/employes
Créer employé
Body: {"matricule": "EMP001", "nom": "...", "prenom": "...", "service": "..."}
```

**README.md:**
- [ ] Prérequis (Java 17+, GlassFish 7+, MySQL)
- [ ] Installation base de données (script SQL)
- [ ] Déploiement GlassFish (copier .war)
- [ ] Configuration persistence.xml
- [ ] Identifiants par défaut
- [ ] Guide démarrage rapide

**Tests finaux:**
- [ ] Build complet: `ant clean build`
- [ ] Déploiement sur GlassFish
- [ ] Test scénario démo complet:
  1. Login gestionnaire
  2. Créer matériel "PC Portable Dell"
  3. Affecter à employé "Jean Dupont"
  4. Vérifier historique (2 mouvements: ENTREE + AFFECTATION)
  5. Consulter alertes expiration
  6. Déconnexion

---

## ✅ CHECKLIST FINALE

### Fonctionnalités obligatoires (TP):
- [ ] Entité matériel en stock
- [ ] Sortie de stock
- [ ] Affectation à employé
- [ ] Modifier article
- [ ] Consultation article
- [ ] Consultation historique / cycle de vie
- [ ] Notification expiration (60j avant)
- [ ] API REST complète
- [ ] Frontend JSP/MVC
- [ ] Authentification
- [ ] Déploiement GlassFish

### Bonus (points supplémentaires):
- [ ] Dashboard statistiques
- [ ] @Schedule pour notifications
- [ ] Export CSV/PDF (optionnel)

---

## RISQUES & MITIGATION

**Risque 1:** Temps insuffisant pour JWT
- **Mitigation:** Prévoir fallback Basic Auth si JWT trop long

**Risque 2:** Problèmes JPA relations
- **Mitigation:** Tester relations dès Phase 1.1

**Risque 3:** DaisyUI pas intégrable facilement
- **Mitigation:** Utiliser Tailwind + composants simples
