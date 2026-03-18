# Mercato - Système de Gestion d'Inventaire

Application de gestion d'inventaire matériel développée avec Jakarta EE 10, JPA, JAX-RS, JWT et DaisyUI.

## 📋 Description

Mercato est une application web complète permettant de :
- Gérer le stock de matériels (informatique, bureautique, mobilier, etc.)
- Suivre les affectations de matériels aux employés
- Gérer les mouvements de stock (entrées, sorties, retours)
- Recevoir des alertes sur les matériels proches de l'expiration
- Consulter l'historique complet des mouvements

## 🚀 Prérequis

- **Java 21** ou supérieur
- **Maven 3.8+**
- **GlassFish 7.0+** (ou tout serveur compatible Jakarta EE 10)
- **PostgreSQL 14+**

## 🛠️ Installation

### 1. Cloner le projet

```bash
git clone <repository-url>
cd mercato
```

### 2. Configurer la base de données

Créer une base de données PostgreSQL :

```bash
createdb mercato_db
```

Modifier `src/conf/persistence.xml` avec vos informations de connexion :

```xml
<property name="jakarta.persistence.jdbc.url" value="jdbc:postgresql://localhost:5432/mercato_db"/>
<property name="jakarta.persistence.jdbc.user" value="votre_user"/>
<property name="jakarta.persistence.jdbc.password" value="votre_password"/>
```

### 3. Démarrer la base de données

```bash
make db-start
```

### 4. Compiler et packager

```bash
make build
```

Ou avec Maven directement :

```bash
mvn clean package
```

### 5. Déployer sur GlassFish

```bash
make server-start
make deploy
```

Ou manuellement :

1. Copier `target/mercato.war` dans `glassfish7/glassfish/domains/domain1/autodeploy/`
2. Démarrer GlassFish : `glassfish7/glassfish/bin/asadmin start-domain`

## 🌐 Accès à l'application

- **Application Web:** http://localhost:8080/mercato/
- **API REST:** http://localhost:8080/mercato/api/
- **Console Admin GlassFish:** http://localhost:4848/

### Identifiants par défaut

- **Utilisateur:** `gestionnaire`
- **Mot de passe:** `password123`
- **Rôle:** `GESTIONNAIRE`

## 📁 Structure du projet

```
mercato/
├── src/
│   ├── java/
│   │   ├── entity/           # Entités JPA (Materiel, Employe, Mouvement, Utilisateur)
│   │   ├── service/          # Logique métier (EJBs)
│   │   ├── web/              # Contrôleurs MVC et API REST
│   │   ├── security/         # JWT (JwtUtils, JwtFilter)
│   │   └── resources/        # Scripts SQL
│   └── conf/
│       └── persistence.xml   # Configuration JPA
├── web/
│   ├── WEB-INF/views/        # Pages JSP
│   │   ├── template.jsp      # Template principal DaisyUI
│   │   ├── dashboard.jsp     # Tableau de bord
│   │   ├── materiels/        # CRUD matériels
│   │   ├── employes/         # CRUD employés
│   │   └── mouvements/       # Gestion des mouvements
│   ├── css/
│   │   └── custom.css        # Styles personnalisés
│   └── js/
│       └── main.js           # Scripts JavaScript
├── API_DOCUMENTATION.md      # Documentation API REST
├── docker-compose.yaml       # Configuration Docker PostgreSQL
├── Makefile                  # Commandes de build
└── pom.xml                   # Configuration Maven
```

## 🎯 Fonctionnalités

### Gestion des Matériels
- ✅ CRUD complet (Créer, Lire, Modifier, Archiver)
- ✅ Recherche et filtrage par catégorie/statut
- ✅ Calcul automatique des dates d'expiration
- ✅ Alertes sur les matériels expirant dans 60 jours

### Gestion du Stock
- ✅ Entrées de stock
- ✅ Sorties de stock avec validation
- ✅ Affectations aux employés
- ✅ Retours de matériel

### Gestion des Employés
- ✅ CRUD employés
- ✅ Consultation des matériels affectés
- ✅ Historique par employé

### Tableau de Bord
- ✅ Statistiques en temps réel
- ✅ Indicateurs visuels (DaisyUI)
- ✅ Liste des alertes d'expiration
- ✅ Mouvements récents

### Sécurité
- ✅ Authentification JWT
- ✅ Sessions utilisateur
- ✅ Protection des routes API

### Notifications
- ✅ @Schedule quotidien (8h00)
- ✅ Badge d'alertes dans la navbar
- ✅ Liste des notifications

## 🛠️ Technologies utilisées

| Technologie | Version | Usage |
|------------|---------|-------|
| Jakarta EE | 10.0 | Framework backend |
| Java | 21 | Langage principal |
| JPA (Hibernate) | 6.x | Persistance des données |
| JAX-RS | 3.1 | API REST |
| JWT (JJWT) | 0.12.3 | Authentification |
| PostgreSQL | 16 | Base de données |
| GlassFish | 7.1.0 | Serveur d'application |
| Maven | 3.x | Build et gestion des dépendances |
| JSP | 3.1 | Templates frontend |
| DaisyUI | 4.x | Composants UI (Tailwind CSS) |
| Font Awesome | 6.x | Icônes |

## 📝 Commandes Make disponibles

```bash
make build         # Compile et package l'application
make clean         # Nettoie les artefacts de build
make db-start      # Démarre PostgreSQL (Docker)
make db-stop       # Arrête PostgreSQL
make server-start  # Démarre GlassFish
make server-stop   # Arrête GlassFish
make deploy        # Déploie l'application
make undeploy      # Retire l'application
make run           # Démarre tout (DB + deploy)
make test          # Exécute les tests
```

## 📖 Documentation API

La documentation complète de l'API REST est disponible dans [API_DOCUMENTATION.md](API_DOCUMENTATION.md).

Points d'entrée principaux :

- `POST /api/auth/login` - Authentification
- `GET /api/materiels` - Liste des matériels (avec filtres optionnels: ?categorie=, ?statut=)
- `POST /api/materiels` - Créer un matériel
- `GET /api/materiels/{id}` - Détail d'un matériel
- `POST /api/materiels/{id}/entree` - Entrée de stock
- `POST /api/materiels/{id}/sortie` - Sortie de stock
- `POST /api/materiels/{id}/affectation` - Affectation à un employé
- `GET /api/materiels/{id}/historique` - Historique des mouvements
- `GET /api/employes` - Liste des employés
- `POST /api/employes` - Créer un employé

## 🔧 Configuration

### Configuration JPA (persistence.xml)

```xml
<persistence-unit name="mercatoPU" transaction-type="JTA">
    <jta-data-source>jdbc/mercato</jta-data-source>
    <class>entity.Materiel</class>
    <class>entity.Employe</class>
    <class>entity.Mouvement</class>
    <class>entity.Utilisateur</class>
    <properties>
        <property name="jakarta.persistence.schema-generation.database.action" value="create"/>
        <property name="hibernate.show_sql" value="true"/>
    </properties>
</persistence-unit>
```

### Configuration JWT

Le token JWT est configuré avec :
- **Secret:** Changez-le en production!
- **Expiration:** 24 heures
- **Algorithme:** HS256

Modifier dans `security/JwtUtils.java` :

```java
private static final String SECRET_KEY = "votre-cle-secrete-tres-longue-et-securisee";
private static final long EXPIRATION_TIME = 86400000; // 24 heures
```

## 🧪 Tests

Exécuter les tests :

```bash
make test
```

Ou :

```bash
mvn test
```

## 🚀 Déploiement en production

1. **Modifier la configuration JWT** avec une clé secrète forte
2. **Configurer HTTPS** sur GlassFish
3. **Changer les identifiants par défaut**
4. **Configurer un pool de connexions** JNDI dans GlassFish
5. **Désactiver** `hibernate.show_sql`
6. **Utiliser** `schema-generation.database.action=none` après la première exécution

## 👥 Auteurs

- **Développeur:** M2 IRT AL 2025-2026
- **Projet:** TP Jakarta EE - Gestion d'Inventaire

## 📄 Licence

Ce projet est développé dans le cadre d'un TP universitaire.

## 🐛 Dépannage

### Problème: "Persistence unit not found"
- Vérifier que le fichier `persistence.xml` est dans `src/conf/META-INF/`
- Redémarrer GlassFish

### Problème: "Token invalide"
- Vérifier que le secret JWT est identique dans toute l'application
- Supprimer les cookies de session

### Problème: "Database connection failed"
- Vérifier que PostgreSQL est démarré : `make db-start`
- Vérifier les identifiants dans `persistence.xml`

### Problème: "404 Not Found" sur les pages JSP
- Vérifier que l'application est bien déployée
- Vérifier l'URL de contexte dans `pom.xml`

## 📞 Support

Pour toute question ou problème :
1. Consulter la documentation API
2. Vérifier les logs GlassFish dans `glassfish7/glassfish/domains/domain1/logs/`
3. Vérifier les logs de l'application

---

**Version:** 1.0  
**Date:** Mars 2025