# Mercato - Inventory Management System

## Project Overview

**Framework:** Jakarta EE 10  
**Database:** PostgreSQL  
**Application Server:** Glassfish 7+  
**Build Tool:** Maven

This is a comprehensive inventory management system for tracking company equipment and materials, including lifecycle management, employee assignments, and expiration notifications.

---

## Implemented Features

### 1. Authentication & Authorization

- **Login System** (`/login`)
  - Username/password authentication
  - Session-based authentication with JWT tokens
  - Role-based access control (GESTIONNAIRErole)
  - Protected routes requiring authentication

- **Entities:**
  - `Utilisateur` - User entity with username, password, and role

---

### 2. Material Management (Matériel)

#### Entity Fields
- `id` - Unique identifier
- `reference` - Material reference code
- `designation` - Description/name
- `categorie` - Category (Informatique, Bureautique, Mobilier, Électronique, Autre)
- `dateIntroduction` - Introduction date to stock
- `dateAchat` - Purchase date
- `quantiteStock` - Stock quantity
- `dureeVieJours` - Lifetime in days
- `dateExpiration` - Calculated expiration date
- `statut` - Status (EN_STOCK, AFFECTE, HORS_SERVICE, EXPIRE)

#### Operations
| Operation | Endpoint (REST) | Endpoint (MVC) | Description |
|-----------|-----------------|-----------------|-------------|
| List materials | `GET /api/materiels` | `GET /materiels` | List all materials with filtering |
| Get material | `GET /api/materiels/{id}` | `GET /materiels/{id}` | View material details |
| Create material | `POST /api/materiels` | `POST /materiels/create` | Add new material to stock |
| Update material | `PUT /api/materiels/{id}` | `POST /materiels/update` | Modify material information |
| Archive material | `DELETE /api/materiels/{id}` | `POST /materiels/delete` | Set status to HORS_SERVICE |
| Filter by category | `GET /api/materiels?categorie=X` | `GET /materiels?categorie=X` | Filter materials by category |
| Filter by status | `GET /api/materiels?statut=X` | `GET /materiels?statut=X` | Filter materials by status |
| Search | - | `GET /materiels?search=X` | Search by reference or designation |

#### Features
- Automatic entry movement creation when material is created
- Automatic expiration date calculation based on purchase date and lifetime
- Status tracking throughout material lifecycle

---

### 3. Stock Movements (Mouvement)

#### Types
- `ENTREE` - Stock entry (addingquantity)
- `SORTIE` - Stock exit (removing quantity)
- `AFFECTATION` - Assignment to employee
- `RETOUR` - Return from employee

#### Operations
| Operation | Endpoint (REST) | Endpoint (MVC) | Description |
|-----------|-----------------|-----------------|-------------|
| Stock entry | `POST /api/materiels/{id}/entree` | `POST /materiels/{id}/entree` | Add quantity to existing material |
| Stock exit | `POST /api/materiels/{id}/sortie` | `POST /materiels/{id}/sortie` | Remove quantity from stock |
| Assign to employee | `POST /api/materiels/{id}/affectation` | `POST /materiels/{id}/affectation` | Assign material to employee |
| Return from employee | `POST /api/mouvements/retour/{mouvementId}` | - | Return material from assignment |
| View history | `GET /api/materiels/{id}/historique` | Included in detail page | View all movements for material |

#### Business Rules
- Stock validation: Cannot exit/assign more than available stock
- Employee validation: Cannot assign to non-existent employee
- Status updates: Automatically updates material status based on operations
- Atomic transactions: Movement and stock update are atomic

---

### 4. Employee Management (Employé)

#### Entity Fields
- `id` - Unique identifier
- `matricule` - Employee ID/matricule
- `nom` - Last name
- `prenom` - First name
- `service` - Department/service

#### Operations
| Operation | Endpoint (REST) | Endpoint (MVC) | Description |
|-----------|-----------------|-----------------|-------------|
| List employees | `GET /api/employes` | `GET /employes` | List all employees |
| Get employee | `GET /api/employes/{id}` | `GET /employes/{id}` | View employee details |
| Create employee | `POST /api/employes` | `POST /employes/create` | Add new employee |
| Update employee | - | `POST /employes/update` | Modify employee information |
| Search by matricule | `GET /api/employes/search/matricule/{matricule}` | - | Find employee by matricule |
| View assignments | - | `GET /employes/{id}` | View all material assignments for employee |

---

### 5. Dashboard

**Endpoint:** `GET /dashboard`

#### Statistics Displayed
- Total materials count
- Materials in stock count
- Assigned materials count
- Expiring materials count (within 60 days)

#### Features
- Category distribution chart
- Recent movements list
- Alert badges for expiring materials

---

### 6. Expiration Notifications (SSE)

#### Implementation
- **Backend:** `NotificationService` with `@Schedule(minute = "*/1", hour = "*")`
- **SSE Endpoint:** `GET /api/sse/alertes`
- **Frontend:** EventSource connection in `template.jsp`

#### Features
- Real-time push notifications via Server-Sent Events
- Automatic detection of materials expiring within 60 days
- Urgency levels: WARNING (< 60 days), URGENT (< 30 days)
- Toast notifications in UI when alerts are received
- Notification badge update in navigation bar

---

### 7. Export Functionality

#### CSV Export
- **Endpoint:** `GET /api/export/csv`
- **Format:** UTF-8 CSV with BOM for Excel compatibility
- **Fields:** ID, Reference, Designation, Category, Introduction Date, Purchase Date, Quantity, Lifetime, Expiration Date, Status

#### PDF Export
- **Endpoint:** `GET /api/export/pdf`
- **Format:** PDF document with tabular layout
- **Features:** Title, date, table with all material information

#### UI Access
- Export dropdown button in materials list page (`/materiels`)
- Links to both CSV and PDF export endpoints

---

### 8. Frontend (Jakarta MVC + JSP)

#### Pages Implemented
| Page | URL | Description |
|------|-----|-------------|
| Login | `/login` | Authentication page |
| Dashboard | `/dashboard` | Statistics and overview |
| Materials List | `/materiels` | List with search/filter |
| Material Create | `/materiels/new` | Create new material |
| Material Edit | `/materiels/{id}/edit` | Edit material |
| Material Detail | `/materiels/{id}` | View details and history |
| Stock Entry | `/materiels/{id}/entree` | Add stock |
| Stock Exit | `/materiels/{id}/sortie` | Remove stock |
| Material Assignment | `/materiels/{id}/affectation` | Assign to employee |
| Alerts | `/materiels/alertes` | View expiring materials |
| Employees List | `/employes` | List all employees |
| Employee Create | `/employes/new` | Create new employee |
| Employee Edit | `/employes/{id}/edit` | Edit employee |
| Employee Detail | `/employes/{id}` | View details and assignments |

#### UI Features
- Responsive design with DaisyUI/Tailwind CSS
- Sidebar navigation
- Flash messages (success/error)
- Keyboard shortcuts (D=Dashboard, M=Materials, E=Employees)
- Global search modal (Ctrl+K)
- Filter tags display
- Empty states

---

### 9. Security

#### Implemented
- Session-based authentication
- JWT token generation
- Authentication filter in `BaseController`
- Protected routes (all except `/login`)

#### Files
- `security/JwtFilter.java` - JWT validation filter
- `security/JwtUtils.java` - JWT token generation utilities
- `web/LoginController.java` - Login handling
- `web/LogoutController.java` - Logout handling

---

### 10. Validation

#### Bean Validation Used
- `@NotBlank` - Required string fields
- `@Min(value = 0)` - Non-negative quantities
- `@Min(value = 1)` - Movement quantity minimum
- `@NotNull` - Required object references

#### Business Validation
- Stock sufficiency check before exit/assignment
- Employee existence check before assignment
- Material existence check for all operations

---

### 11. Transaction Management

- All write operations use `@Transactional`
- Atomic operations for movement + stock update
- Automatic rollback on error

---

## API Endpoints Summary

### REST API (JSON)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/materiels` | List all materials |
| GET | `/api/materiels/{id}` | Get material by ID |
| POST | `/api/materiels` | Create material |
| PUT | `/api/materiels/{id}` | Update material |
| DELETE | `/api/materiels/{id}` | Archive material |
| GET | `/api/materiels/alertes` | Get expiring materials |
| POST | `/api/materiels/{id}/entree` | Stock entry |
| POST | `/api/materiels/{id}/sortie` | Stock exit |
| POST | `/api/materiels/{id}/affectation` | Assign to employee |
| GET | `/api/materiels/{id}/historique` | Movement history |
| GET | `/api/employes` | List all employees |
| GET | `/api/employes/{id}` | Get employee by ID |
| POST | `/api/employes` | Create employee |
| GET | `/api/sse/alertes` | SSE notifications |
| GET | `/api/export/csv` | Export to CSV |
| GET | `/api/export/pdf` | Export to PDF |

---

## Technology Stack

| Component | Technology |
|-----------|------------|
| Backend Framework | Jakarta EE 10 |
| Web Framework | Jakarta MVC 2.1 |
| REST API | Jakarta REST (JAX-RS) |
| Persistence | Jakarta Persistence (JPA) |
| Dependency Injection | Jakarta CDI |
| Validation | Jakarta Bean Validation |
| Security | Jakarta Security |
| View Technology | JSP with JSTL |
| CSS Framework | DaisyUI + Tailwind CSS |
| Database | PostgreSQL |
| Application Server | Glassfish 7+ |
| PDF Generation | Apache PDFBox 3.0.2 |
| JWT | JJWT 0.12.3 |

---

## Project Structure

```
mercato/
├── src/
│   ├── java/
│   │   ├── entity/          # JPA Entities
│   │   │   ├── Employe.java
│   │   │   ├── Materiel.java
│   │   │   ├── Mouvement.java
│   │   │   ├── StatutMateriel.java
│   │   │   ├── TypeMouvement.java
│   │   │   └── Utilisateur.java
│   │   ├── service/         # Business Logic (EJB)
│   │   │   ├── EmployeService.java
│   │   │   ├── MaterielService.java
│   │   │   ├── MouvementService.java
│   │   │   ├── NotificationService.java
│   │   │   └── UtilisateurService.java
│   │   ├── web/             # Web Layer
│   │   │   ├── ApplicationController.java
│   │   │   ├── AuthentificationResource.java
│   │   │   ├── BaseController.java
│   │   │   ├── DashboardController.java
│   │   │   ├── EmployeController.java
│   │   │   ├── EmployeResource.java
│   │   │   ├── ExportResource.java
│   │   │   ├── LoginController.java
│   │   │   ├── LogoutController.java
│   │   │   ├── MaterielController.java
│   │   │   ├── MaterielResource.java
│   │   │   ├── MouvementResource.java
│   │   │   ├── RedirectException.java
│   │   │   └── SseNotificationResource.java
│   │   └── security/        # Security Components
│   │       ├── JwtFilter.java
│   │       └── JwtUtils.java
│   └── conf/
│       └── META-INF/
│           └── persistence.xml
├── web/
│   ├── WEB-INF/
│   │   ├── views/
│   │   │   ├── dashboard.jsp
│   │   │   ├── dashboard_content.jsp
│   │   │   ├── login.jsp
│   │   │   ├── template.jsp
│   │   │   ├── employes/
│   │   │   └── materiels/
│   │   ├── tags/
│   │   └── web.xml
│   ├── css/
│   └── js/
└── pom.xml
```

---

## Configuration Files

- `pom.xml` - Maven dependencies and build configuration
- `src/conf/META-INF/persistence.xml` - JPA persistence unit configuration

---

## Notes for Future Development

### Potential Enhancements
1. Pagination for large datasets
2. Advanced search with multiple criteria
3. Bulk import/export
4. Email notifications for expiration alerts
5. Role-based permissions (admin vs viewer)
6. Audit trail with user tracking
7. Barcode/QR code generation
8. Mobile-responsive improvements

### Known Limitations
- No pagination on list pages
- SSE reconnects limited to5 attempts
- PDF uses basic Helvetica font (no UTF-8 special characters)
- No password hashing (plain text storage)