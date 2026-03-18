<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enregistrement Réussi - Mercato</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${contextPath}/css/custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-base-200 min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md">
        <!-- Success Card -->
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body p-8 text-center">
                <!-- Success Icon -->
                <div class="mb-6">
                    <div class="inline-flex items-center justify-center w-20 h-20 bg-success/10 rounded-full">
                        <i class="fas fa-check-circle text-5xl text-success"></i>
                    </div>
                </div>
                
                <h1 class="text-2xl font-bold mb-2">Joueur enregistré !</h1>
                <p class="text-base-content/60 mb-6">Le joueur a été enregistré avec succès</p>
                
                <!-- Player Details -->
                <div class="bg-base-200 rounded-lg p-4 text-left mb-6">
                    <h3 class="font-semibold mb-3 text-sm uppercase tracking-wide text-base-content/60">Récapitulatif</h3>
                    
                    <div class="space-y-3">
                        <div class="flex justify-between">
                            <span class="text-base-content/60">Nom & Prénom</span>
                            <span class="font-medium">${joueur.nom} ${joueur.prenom}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-base-content/60">Poste</span>
                            <span class="badge badge-primary">${joueur.poste}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-base-content/60">Âge</span>
                            <span class="font-medium">${joueur.age} ans</span>
                        </div>
                    </div>
                </div>
                
                <!-- Actions -->
                <div class="space-y-2">
                    <a href="${contextPath}/joueur_form.html" class="btn btn-primary w-full gap-2">
                        <i class="fas fa-plus"></i>
                        Enregistrer un autre joueur
                    </a>
                    <a href="${contextPath}/dashboard" class="btn btn-ghost w-full gap-2">
                        <i class="fas fa-tachometer-alt"></i>
                        Retour au Dashboard
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="text-center mt-6 text-base-content/40 text-sm">
            <p>&copy; 2025 Mercato - Système de Gestion d'Inventaire</p>
        </div>
    </div>
</body>
</html>
