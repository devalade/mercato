<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Welcome Section -->
<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-tachometer-alt text-primary mr-3"></i>
            Dashboard
        </h1>
        <p class="text-gray-600">Vue d'ensemble du système d'inventaire</p>
    </div>
    <div class="flex gap-2">
        <t:button href="${pageContext.request.contextPath}/materiels/new" variant="primary" icon="fa-plus">
            Nouveau Matériel
        </t:button>
        <t:button href="${pageContext.request.contextPath}/employes/new" variant="secondary" icon="fa-user-plus">
            Nouvel Employé
        </t:button>
    </div>
</div>

<!-- Stats Cards -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
    <!-- Total Materials -->
    <div class="card bg-base-100 shadow-xl stat-card">
        <div class="card-body">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-500 mb-1">Total Matériels</p>
                    <h2 class="text-3xl font-bold">${totalMateriels}</h2>
                </div>
                <div class="w-14 h-14 bg-primary rounded-full flex items-center justify-center">
                    <i class="fas fa-boxes text-2xl text-primary-content"></i>
                </div>
            </div>
            <div class="mt-4">
                <span class="text-sm text-gray-500">Dans l'inventaire</span>
            </div>
        </div>
    </div>
    
    <!-- In Stock -->
    <div class="card bg-base-100 shadow-xl stat-card">
        <div class="card-body">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-500 mb-1">En Stock</p>
                    <h2 class="text-3xl font-bold text-success">${enStock}</h2>
                </div>
                <div class="w-14 h-14 bg-success rounded-full flex items-center justify-center">
                    <i class="fas fa-check-circle text-2xl text-success-content"></i>
                </div>
            </div>
            <div class="mt-4">
                <span class="text-sm text-success">Disponibles</span>
            </div>
        </div>
    </div>
    
    <!-- Assigned -->
    <div class="card bg-base-100 shadow-xl stat-card">
        <div class="card-body">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-500 mb-1">Affectés</p>
                    <h2 class="text-3xl font-bold text-info">${affectes}</h2>
                </div>
                <div class="w-14 h-14 bg-info rounded-full flex items-center justify-center">
                    <i class="fas fa-user-check text-2xl text-info-content"></i>
                </div>
            </div>
            <div class="mt-4">
                <span class="text-sm text-info">En utilisation</span>
            </div>
        </div>
    </div>
    
    <!-- Alerts -->
    <div class="card bg-base-100 shadow-xl stat-card">
        <div class="card-body">
            <div class="flex items-center justify-between">
                <div>
                    <p class="text-sm text-gray-500 mb-1">Alertes</p>
                    <h2 class="text-3xl font-bold ${alertesCount > 0 ? 'text-error' : 'text-success'}">${alertesCount}</h2>
                </div>
                <div class="w-14 h-14 ${alertesCount > 0 ? 'bg-error' : 'bg-success'} rounded-full flex items-center justify-center">
                    <i class="fas fa-exclamation-triangle text-2xl text-error-content"></i>
                </div>
            </div>
            <div class="mt-4">
                <span class="text-sm ${alertesCount > 0 ? 'text-error' : 'text-success'}">
                    ${alertesCount > 0 ? 'Expiration imminente' : 'Aucune alerte'}
                </span>
            </div>
        </div>
    </div>
</div>

<!-- Alerts Section -->
<c:if test="${not empty alertesMateriels}">
    <div class="card bg-base-100 shadow-xl mb-8">
        <div class="card-body">
            <h2 class="card-title text-xl mb-4">
                <i class="fas fa-bell text-warning mr-2"></i>
                Matériels proches de l'expiration
            </h2>
            <div class="overflow-x-auto">
                <table class="table table-zebra w-full">
                    <thead>
                        <tr>
                            <th>Référence</th>
                            <th>Désignation</th>
                            <th>Catégorie</th>
                            <th>Date d'expiration</th>
                            <th>Jours restants</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${alertesMateriels}" var="materiel">
                            <tr>
                                <td class="font-mono">${materiel.reference}</td>
                                <td>${materiel.designation}</td>
                                <td>${materiel.categorie}</td>
                                <td>
                                    <fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                    <span class="badge ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}">
                                        ${joursRestants} jours
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                       class="btn btn-sm btn-info btn-outline">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</c:if>

<!-- Charts Section (Optional) -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Category Distribution -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title text-xl mb-4">
                <i class="fas fa-chart-pie text-primary mr-2"></i>
                Répartition par catégorie
            </h2>
            <div class="h-64 flex items-center justify-center bg-base-200 rounded-lg">
                <div class="text-center text-gray-500">
                    <i class="fas fa-chart-pie text-4xl mb-2"></i>
                    <p>Graphique de répartition</p>
                    <p class="text-sm">(Intégration Chart.js possible)</p>
                </div>
            </div>
            <!-- Category List -->
            <div class="mt-4 space-y-2">
                <c:forEach items="${categories}" var="cat">
                    <div class="flex justify-between items-center p-2 bg-base-200 rounded">
                        <span class="font-medium">${cat.key}</span>
                        <span class="badge badge-primary">${cat.value}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    
    <!-- Recent Movements -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title text-xl mb-4">
                <i class="fas fa-history text-info mr-2"></i>
                Mouvements récents
            </h2>
            <c:choose>
                <c:when test="${empty recentMovements}">
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Aucun mouvement récent</h3>
                        <p>Les derniers mouvements apparaîtront ici</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach items="${recentMovements}" var="mouvement" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <div class="flex items-center gap-4 p-3 bg-base-200 rounded-lg">
                                    <div class="flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${mouvement.type == 'ENTREE'}">
                                                <div class="w-10 h-10 rounded-full bg-success flex items-center justify-center">
                                                    <i class="fas fa-arrow-down text-success-content"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'SORTIE'}">
                                                <div class="w-10 h-10 rounded-full bg-error flex items-center justify-center">
                                                    <i class="fas fa-arrow-up text-error-content"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'AFFECTATION'}">
                                                <div class="w-10 h-10 rounded-full bg-info flex items-center justify-center">
                                                    <i class="fas fa-user-plus text-info-content"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="w-10 h-10 rounded-full bg-warning flex items-center justify-center">
                                                    <i class="fas fa-undo text-warning-content"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-1">
                                        <p class="font-semibold">${mouvement.materiel.designation}</p>
                                        <p class="text-sm text-gray-500">
                                            ${mouvement.type} - 
                                            <fmt:formatDate value="${mouvement.dateMouvement}" pattern="dd/MM/yyyy HH:mm" />
                                        </p>
                                    </div>
                                    <span class="badge badge-ghost">Qté: ${mouvement.quantite}</span>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/mouvements" class="btn btn-ghost btn-sm">
                            Voir tous les mouvements <i class="fas fa-arrow-right ml-2"></i>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>