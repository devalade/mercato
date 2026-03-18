# Documentation API - Mercato Inventaire

## Introduction

Cette documentation décrit l'API REST du système de gestion d'inventaire Mercato.

**Base URL:** `http://localhost:8080/mercato/api`

## Authentification

Tous les endpoints (sauf `/auth/login`) nécessitent un token JWT dans l'en-tête Authorization.

```
Authorization: Bearer <token>
```

### POST /api/auth/login

Authentifie un utilisateur et retourne un token JWT.

**Request:**
```json
{
  "username": "gestionnaire",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "role": "GESTIONNAIRE"
}
```

**Response (401 Unauthorized):**
```json
{
  "error": "Nom d'utilisateur ou mot de passe invalide"
}
```

---

## Matériels

### GET /api/materiels

Liste tous les matériels ou filtre par catégorie/statut.

**Query Parameters (optionnels):**
- `categorie` - Filtrer par catégorie (ex: Informatique)
- `statut` - Filtrer par statut (EN_STOCK, AFFECTE, HORS_SERVICE, EXPIRE)

**Exemples:**
- `GET /api/materiels` - Liste tous les matériels
- `GET /api/materiels?categorie=Informatique` - Filtre par catégorie
- `GET /api/materiels?statut=EN_STOCK` - Filtre par statut

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "reference": "PC001",
    "designation": "PC Portable Dell Latitude",
    "categorie": "Informatique",
    "dateIntroduction": "2025-01-15T00:00:00",
    "dateAchat": "2025-01-10T00:00:00",
    "quantiteStock": 5,
    "dureeVieJours": 1095,
    "dateExpiration": "2028-01-10T00:00:00",
    "statut": "EN_STOCK"
  }
]
```

### GET /api/materiels/{id}

Détail d'un matériel spécifique.

**Response (200 OK):**
```json
{
  "id": 1,
  "reference": "PC001",
  "designation": "PC Portable Dell Latitude",
  "categorie": "Informatique",
  "quantiteStock": 5,
  "statut": "EN_STOCK"
}
```

### POST /api/materiels

Crée un nouveau matériel.

**Request:**
```json
{
  "reference": "PC002",
  "designation": "PC Portable HP ProBook",
  "categorie": "Informatique",
  "dateAchat": "2025-03-10T00:00:00",
  "quantiteStock": 3,
  "dureeVieJours": 1095
}
```

**Response (201 Created):**
```json
{
  "id": 2,
  "reference": "PC002",
  "designation": "PC Portable HP ProBook",
  ...
}
```

### PUT /api/materiels/{id}

Modifie un matériel existant.

**Request:**
```json
{
  "designation": "PC Portable HP ProBook (Modifié)",
  "categorie": "Informatique",
  "dureeVieJours": 1460
}
```

### DELETE /api/materiels/{id}

Archive un matériel (met le statut à HORS_SERVICE).

**Response (200 OK):**
```json
{
  "message": "Matériel archivé avec succès"
}
```

### GET /api/materiels/alertes

Retourne les matériels expirant dans les 60 jours.

**Response (200 OK):**
```json
[
  {
    "id": 3,
    "reference": "IMP001",
    "designation": "Imprimante Laser",
    "dateExpiration": "2025-04-15T00:00:00",
    "joursRestants": 35
  }
]
```

## Mouvements

### POST /api/materiels/{materielId}/entree

Enregistre une entrée en stock.

**Request:**
```json
{
  "quantite": 5,
  "commentaire": "Nouvelle livraison"
}
```

### POST /api/materiels/{materielId}/sortie

Enregistre une sortie de stock.

**Request:**
```json
{
  "quantite": 2,
  "commentaire": "Sortie pour maintenance"
}
```

**Response (400 Bad Request):**
```json
{
  "error": "Stock insuffisant. Disponible: 3"
}
```

### POST /api/materiels/{materielId}/affectation

Affecte un matériel à un employé.

**Request:**
```json
{
  "employeId": 1,
  "quantite": 1,
  "commentaire": "Affectation à Jean Dupont"
}
```

### GET /api/materiels/{materielId}/historique

Retourne l'historique des mouvements d'un matériel.

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "type": "ENTREE",
    "dateMouvement": "2025-01-15T10:30:00",
    "quantite": 5,
    "commentaire": "Nouvelle livraison",
    "employe": null
  },
  {
    "id": 2,
    "type": "AFFECTATION",
    "dateMouvement": "2025-02-01T14:20:00",
    "quantite": 1,
    "commentaire": "Affectation",
    "employe": {
      "id": 1,
      "nom": "Dupont",
      "prenom": "Jean"
    }
  }
]
```

---

## Employés

### GET /api/employes

Liste tous les employés.

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "matricule": "EMP001",
    "nom": "Dupont",
    "prenom": "Jean",
    "service": "Informatique"
  }
]
```

### GET /api/employes/{id}

Détail d'un employé.

### POST /api/employes

Crée un nouvel employé.

**Request:**
```json
{
  "matricule": "EMP002",
  "nom": "Martin",
  "prenom": "Marie",
  "service": "Ressources Humaines"
}
```

---

## Codes d'Erreur

| Code | Description |
|------|-------------|
| 200 | Succès |
| 201 | Créé avec succès |
| 400 | Requête invalide |
| 401 | Non autorisé - Token manquant ou invalide |
| 403 | Interdit - Permissions insuffisantes |
| 404 | Ressource non trouvée |
| 500 | Erreur serveur |

---

## Exemples d'utilisation avec curl

### Authentification
```bash
curl -X POST http://localhost:8080/mercato/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "gestionnaire", "password": "password123"}'
```

### Liste des matériels
```bash
curl -X GET http://localhost:8080/mercato/api/materiels \
  -H "Authorization: Bearer <token>"
```

### Créer un matériel
```bash
curl -X POST http://localhost:8080/mercato/api/materiels \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "reference": "PC003",
    "designation": "PC Portable Lenovo",
    "categorie": "Informatique",
    "quantiteStock": 2,
    "dureeVieJours": 1095
  }'
```

### Entrée de stock
```bash
curl -X POST http://localhost:8080/mercato/api/materiels/1/entree \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "quantite": 5,
    "commentaire": "Nouvelle livraison"
  }'
```

### Sortie de stock
```bash
curl -X POST http://localhost:8080/mercato/api/materiels/1/sortie \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "quantite": 2,
    "commentaire": "Sortie pour maintenance"
  }'
```

### Affecter un matériel
```bash
curl -X POST http://localhost:8080/mercato/api/materiels/1/affectation \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "employeId": 1,
    "quantite": 1,
    "commentaire": "Nouvel employé"
  }'
```

---

## Notes

- Les dates sont au format ISO 8601: `yyyy-MM-dd` ou `yyyy-MM-ddTHH:mm:ss`
- Les statuts de matériel sont: `EN_STOCK`, `AFFECTE`, `HORS_SERVICE`, `EXPIRE`
- Les types de mouvement sont: `ENTREE`, `SORTIE`, `AFFECTATION`, `RETOUR`
- Le token JWT expire après 24 heures

---

**Version:** 1.0  
**Dernière mise à jour:** Mars 2025