-- Utilisateurs (for authentication)
INSERT INTO utilisateur (username, password, role) VALUES ('gestionnaire', 'password123', 'GESTIONNAIRE');

-- Employés
INSERT INTO employe (matricule, nom, prenom, service) VALUES ('EMP001', 'Dupont', 'Jean', 'Informatique');
INSERT INTO employe (matricule, nom, prenom, service) VALUES ('EMP002', 'Martin', 'Sophie', 'Ressources Humaines');
INSERT INTO employe (matricule, nom, prenom, service) VALUES ('EMP003', 'Bernard', 'Pierre', 'Comptabilité');
INSERT INTO employe (matricule, nom, prenom, service) VALUES ('EMP004', 'Petit', 'Marie', 'Direction');

-- Matériels (10 items: 3 PCs, 2 chairs, 2 printers, 3 others)
-- PC Portable 1 (normal expiration)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('PC001', 'Dell Latitude 5520', 'Informatique', '2026-01-15', '2026-01-10', 5, 730, 'EN_STOCK', '2027-01-10');

-- PC Portable 2 (normal expiration)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('PC002', 'HP EliteBook 840', 'Informatique', '2026-02-20', '2026-02-15', 3, 730, 'EN_STOCK', '2027-02-15');

-- PC Portable 3 (expiring soon - within 60 days)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('PC003', 'Lenovo ThinkPad T14', 'Informatique', '2024-12-01', '2024-06-01', 2, 300, 'EN_STOCK', '2026-04-27');

-- Chaise 1 (mobilier, normal)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('CHF001', 'Chaise ergonomique Herman Miller', 'Mobilier', '2026-01-20', '2024-11-15', 10, 1825, 'EN_STOCK', '2029-11-15');

-- Chaise 2 (mobilier, expiring soon)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('CHF002', 'Chaise de bureau standard', 'Mobilier', '2024-10-01', '2024-08-01', 15, 270, 'EN_STOCK', '2026-05-28');

-- Imprimante 1 (bureautique)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('IMP001', 'HP LaserJet Pro M404n', 'Bureautique', '2026-03-01', '2026-02-20', 2, 1095, 'EN_STOCK', '2028-02-20');

-- Imprimante 2 (bureautique)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('IMP002', 'Canon imageRUNNER 2520', 'Bureautique', '2024-11-15', '2024-09-01', 1, 1460, 'AFFECTE', '2028-09-01');

-- Clavier (autre)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('CLAV001', 'Clavier Logitech MX Keys', 'Autre', '2026-01-25', '2026-01-05', 8, 730, 'EN_STOCK', '2027-01-05');

-- Souris (autre)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('SOUR001', 'Souris Logitech MX Master 3', 'Autre', '2026-01-25', '2026-01-05', 8, 730, 'EN_STOCK', '2027-01-05');

-- Ecran (autre)
INSERT INTO materiel (reference, designation, categorie, dateintroduction, dateachat, quantitestock, dureeviejours, statut, dateexpiration) 
VALUES ('ECR001', 'Moniteur Dell UltraSharp 27"', 'Autre', '2026-02-10', '2026-01-20', 4, 1095, 'EN_STOCK', '2028-01-20');

-- Mouvements (traçabilité)
-- Entrée PC001
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('ENTREE', '2026-01-15', 5, 'Achat initial - Lot de 5 PC Dell', 1);

-- Entrée PC002
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('ENTREE', '2026-02-20', 3, 'Achat initial - Lot de 3 PC HP', 2);

-- Entrée PC003
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('ENTREE', '2024-12-01', 2, 'Achat initial - Lot de 2 PC Lenovo', 3);

-- Affectation IMP002 (employé EMP001 - Jean Dupont)
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id, employe_id) 
VALUES ('AFFECTATION', '2024-12-10', 1, 'Affectation au service Informatique', 6, 1);

-- Entrée CHF001
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('ENTREE', '2026-01-20', 10, 'Achat initial - Chaises ergonomiques', 4);

-- Entrée CHF002
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('ENTREE', '2024-10-01', 15, 'Achat initial - Chaises de bureau', 5);

-- Sortie CHF002 (some chairs used/damaged)
INSERT INTO mouvement (type, datemouvement, quantite, commentaire, materiel_id) 
VALUES ('SORTIE', '2026-02-15', 3, 'Chaises endommagées - mise au rebut', 5);
