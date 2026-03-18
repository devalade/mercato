<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-tachometer-alt text-xl"></i>
        </div>
        <div>
            <h1>Dashboard</h1>
            <p class="page-header-subtitle">Vue d'ensemble du système d'inventaire</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary btn-sm gap-2">
            <i class="fas fa-plus"></i>
            <span class="hidden sm:inline">Nouveau Matériel</span>
        </a>
        <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-outline btn-sm gap-2">
            <i class="fas fa-user-plus"></i>
            <span class="hidden sm:inline">Nouvel Employé</span>
        </a>
    </div>
</div>

<!-- Stats Grid -->
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
    <!-- Total Materials -->
    <div class="stat-card">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Total Matériels</p>
                    <h3 class="text-2xl font-bold">${totalMateriels != null ? totalMateriels : 0}</h3>
                </div>
                <div class="stat-icon-primary">
                    <i class="fas fa-boxes"></i>
                </div>
            </div>
            <p class="text-xs text-base-content/50 mt-2">Dans l'inventaire</p>
        </div>
    </div>
    
    <!-- In Stock -->
    <div class="stat-card">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">En Stock</p>
                    <h3 class="text-2xl font-bold text-success">${enStock != null ? enStock : 0}</h3>
                </div>
                <div class="stat-icon-success">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
            <p class="text-xs text-success mt-2">Disponibles</p>
        </div>
    </div>
    
    <!-- Assigned -->
    <div class="stat-card">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Affectés</p>
                    <h3 class="text-2xl font-bold text-info">${affectes != null ? affectes : 0}</h3>
                </div>
                <div class="stat-icon-info">
                    <i class="fas fa-user-check"></i>
                </div>
            </div>
            <p class="text-xs text-info mt-2">En utilisation</p>
        </div>
    </div>
    
    <!-- Alerts -->
    <div class="stat-card">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Alertes</p>
                    <h3 class="text-2xl font-bold ${alertesCount > 0 ? 'text-error' : 'text-success'}">${alertesCount != null ? alertesCount : 0}</h3>
                </div>
                <div class="${alertesCount > 0 ? 'stat-icon-error' : 'stat-icon-success'}">
                    <i class="fas ${alertesCount > 0 ? 'fa-exclamation-triangle' : 'fa-shield-check'}"></i>
                </div>
            </div>
            <p class="text-xs ${alertesCount > 0 ? 'text-error' : 'text-success'} mt-2">
                ${alertesCount > 0 ? 'Expiration imminente' : 'Aucune alerte'}
            </p>
        </div>
    </div>
</div>

<!-- Alerts Section -->
<c:if test="${not empty alertesMateriels}">
    <div class="card-clean mb-6 border-l-4 border-l-warning">
        <div class="card-body">
            <div class="flex items-center gap-2 mb-4">
                <i class="fas fa-bell text-warning text-xl"></i>
                <h2 class="card-title">Matériels proches de l'expiration</h2>
            </div>
            <div class="overflow-x-auto">
                <table class="table-clean">
                    <thead>
                        <tr>
                            <th>Référence</th>
                            <th>Désignation</th>
                            <th>Catégorie</th>
                            <th>Date d'expiration</th>
                            <th>Jours restants</th>
                            <th class="text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${alertesMateriels}" var="materiel">
                            <tr>
                                <td class="font-mono font-medium">${materiel.reference}</td>
                                <td>${materiel.designation}</td>
                                <td><span class="badge badge-ghost">${materiel.categorie}</span></td>
                                <td>
                                    <fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                    <span class="badge ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}">
                                        ${joursRestants} jours
                                    </span>
                                </td>
                                <td class="text-right">
                                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                       class="btn btn-sm btn-ghost text-info">
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

<!-- Two Column Layout -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Category Distribution -->
    <div class="card-clean">
        <div class="card-body">
            <div class="flex items-center gap-2 mb-4">
                <i class="fas fa-chart-pie text-primary text-xl"></i>
                <h2 class="card-title">Répartition par catégorie</h2>
            </div>
            
            <!-- Category List -->
            <div class="space-y-2">
                <c:choose>
                    <c:when test="${not empty categories}">
                        <c:forEach items="${categories}" var="cat">
                            <div class="flex items-center justify-between p-3 bg-base-200 rounded-lg hover:bg-base-300 transition-colors">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                                        <i class="fas fa-tag text-sm"></i>
                                    </div>
                                    <span class="font-medium">${cat.key}</span>
                                </div>
                                <span class="badge badge-primary">${cat.value}</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state py-8">
                            <div class="empty-state-icon">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <h3>Aucune catégorie</h3>
                            <p>Les catégories apparaîtront ici</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Recent Movements -->
    <div class="card-clean">
        <div class="card-body">
            <div class="flex items-center gap-2 mb-4">
                <i class="fas fa-history text-info text-xl"></i>
                <h2 class="card-title">Mouvements récents</h2>
            </div>
            
            <c:choose>
                <c:when test="${empty recentMovements}">
                    <div class="empty-state py-8">
                        <div class="empty-state-icon">
                            <i class="fas fa-inbox"></i>
                        </div>
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
                                                <div class="timeline-icon bg-success/10 text-success">
                                                    <i class="fas fa-arrow-down"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'SORTIE'}">
                                                <div class="timeline-icon bg-error/10 text-error">
                                                    <i class="fas fa-arrow-up"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'AFFECTATION'}">
                                                <div class="timeline-icon bg-info/10 text-info">
                                                    <i class="fas fa-user-plus"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="timeline-icon bg-warning/10 text-warning">
                                                    <i class="fas fa-undo"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <p class="font-medium truncate">${mouvement.materiel.designation}</p>
                                        <p class="text-sm text-base-content/60">
                                            <t:movementBadge type="${mouvement.type}" />
                                            <span class="mx-1">•</span>
                                            <fmt:formatDate value="${mouvement.dateMouvement}" pattern="dd/MM/yy" />
                                        </p>
                                    </div>
                                    <span class="badge badge-ghost">${mouvement.quantite}</span>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/mouvements" class="btn btn-ghost btn-sm">
                            Voir tous les mouvements <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
