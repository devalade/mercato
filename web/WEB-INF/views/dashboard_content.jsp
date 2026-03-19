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
        <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary btn-sm gap-2 btn-ripple">
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
    <div class="stat-card animate-fade-in" style="animation-delay: 0.05s;">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Total Matériels</p>
                    <h3 class="text-3xl font-bold">${totalMateriels != null ? totalMateriels : 0}</h3>
                    <p class="text-xs text-base-content/50 mt-2 flex items-center gap-1">
                        <i class="fas fa-layer-group text-primary/60"></i>
                        Dans l'inventaire
                    </p>
                </div>
                <div class="stat-icon stat-icon-primary">
                    <i class="fas fa-boxes"></i>
                </div>
            </div>
        </div>
    </div>
    
    <!-- In Stock -->
    <div class="stat-card animate-fade-in" style="animation-delay: 0.1s;">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">En Stock</p>
                    <h3 class="text-3xl font-bold text-success">${enStock != null ? enStock : 0}</h3>
                    <p class="text-xs text-success mt-2 flex items-center gap-1">
                        <i class="fas fa-check-circle"></i>
                        Disponibles
                    </p>
                </div>
                <div class="stat-icon stat-icon-success">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Assigned -->
    <div class="stat-card animate-fade-in" style="animation-delay: 0.15s;">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Affectés</p>
                    <h3 class="text-3xl font-bold text-info">${affectes != null ? affectes : 0}</h3>
                    <p class="text-xs text-info mt-2 flex items-center gap-1">
                        <i class="fas fa-user-check"></i>
                        En utilisation
                    </p>
                </div>
                <div class="stat-icon stat-icon-info">
                    <i class="fas fa-user-check"></i>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Alerts -->
    <div class="stat-card animate-fade-in" style="animation-delay: 0.2s;">
        <div class="card-body">
            <div class="flex items-start justify-between">
                <div>
                    <p class="text-sm text-base-content/60 mb-1">Alertes</p>
                    <h3 class="text-3xl font-bold ${alertesCount > 0 ? 'text-error' : 'text-success'}">${alertesCount != null ? alertesCount : 0}</h3>
                    <p class="text-xs ${alertesCount > 0 ? 'text-error' : 'text-success'} mt-2 flex items-center gap-1">
                        <i class="fas ${alertesCount > 0 ? 'fa-exclamation-triangle' : 'fa-shield-check'}"></i>
                        ${alertesCount > 0 ? 'Expiration imminente' : 'Aucune alerte'}
                    </p>
                </div>
                <div class="${alertesCount > 0 ? 'stat-icon-error animate-pulse-soft' : 'stat-icon-success'}">
                    <i class="fas ${alertesCount > 0 ? 'fa-exclamation-triangle' : 'fa-shield-check'}"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Alerts Section -->
<c:if test="${not empty alertesMateriels}">
    <div class="card-clean alert-warning mb-6 animate-fade-in" style="animation-delay: 0.25s;">
        <div class="card-body">
            <div class="flex items-center gap-2 mb-4">
                <div class="w-10 h-10 rounded-lg bg-warning/20 flex items-center justify-center">
                    <i class="fas fa-bell text-warning text-xl"></i>
                </div>
                <div>
                    <h2 class="card-title mb-0">Matériels proches de l'expiration</h2>
                    <p class="text-sm text-base-content/60">Ces matériels nécessitent votre attention</p>
                </div>
                <a href="${pageContext.request.contextPath}/materiels/alertes" class="btn btn-ghost btn-sm ml-auto">
                    Voir tout <i class="fas fa-arrow-right ml-1"></i>
                </a>
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
                        <c:forEach items="${alertesMateriels}" var="materiel" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <tr class="animate-list-item">
                                    <td class="font-mono font-medium">${materiel.reference}</td>
                                    <td class="font-medium">${materiel.designation}</td>
                                    <td><span class="badge badge-ghost">${materiel.categorie}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${materiel.dateExpiration != null}">
                                                <div class="flex items-center gap-2">
                                                    <i class="far fa-calendar-alt text-base-content/40"></i>
                                                    <t:formatDateTime date="${materiel.dateExpiration}" />
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-base-content/40">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                        <span class="badge ${joursRestants < 30 ? 'badge-error' : 'badge-warning'} gap-1">
                                            <i class="fas fa-clock text-xs"></i>
                                            ${joursRestants} jours
                                        </span>
                                    </td>
                                    <td class="text-right">
                                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                           class="btn btn-sm btn-ghost btn-action-view" title="Détail">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <c:if test="${alertesMateriels.size() > 5}">
                <div class="mt-4 pt-4 border-t border-base-200 text-center">
                    <p class="text-sm text-base-content/60">
                        Et ${alertesMateriels.size() - 5} autre(s) matériel(s) en alerte
                    </p>
                </div>
            </c:if>
        </div>
    </div>
</c:if>

<!-- Two Column Layout -->
<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Category Distribution -->
    <div class="card-clean animate-fade-in" style="animation-delay: 0.3s;">
        <div class="card-body">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center gap-2">
                    <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
                        <i class="fas fa-chart-pie text-primary text-xl"></i>
                    </div>
                    <div>
                        <h2 class="card-title mb-0">Répartition par catégorie</h2>
                        <p class="text-sm text-base-content/60">Distribution des matériels</p>
                    </div>
                </div>
            </div>
            
            <!-- Category List -->
            <div class="space-y-2">
                <c:choose>
                    <c:when test="${not empty categories}">
                        <c:forEach items="${categories}" var="cat" varStatus="status">
                            <div class="animate-list-item flex items-center justify-between p-3 bg-base-200 rounded-lg hover:bg-base-300 transition-all cursor-pointer hover-lift" style="animation-delay: ${status.index * 0.05}s;">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                                        <i class="fas fa-tag"></i>
                                    </div>
                                    <div>
                                        <span class="font-medium block">${cat.key}</span>
                                        <span class="text-xs text-base-content/60">${cat.value} matériel(s)</span>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3">
                                    <div class="w-24 h-2 bg-base-300 rounded-full overflow-hidden">
                                        <div class="h-full bg-primary rounded-full" style="width: ${(cat.value / totalMateriels) * 100}%"></div>
                                    </div>
                                    <span class="badge badge-primary badge-sm">${cat.value}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state py-8">
                            <div class="empty-state-icon">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <h3>Aucune catégorie</h3>
                            <p>Les catégories apparaîtront ici une fois que vous aurez ajouté des matériels</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Recent Movements -->
    <div class="card-clean animate-fade-in" style="animation-delay: 0.35s;">
        <div class="card-body">
            <div class="flex items-center justify-between mb-4">
                <div class="flex items-center gap-2">
                    <div class="w-10 h-10 rounded-lg bg-info/10 flex items-center justify-center">
                        <i class="fas fa-history text-info text-xl"></i>
                    </div>
                    <div>
                        <h2 class="card-title mb-0">Mouvements récents</h2>
                        <p class="text-sm text-base-content/60">Dernières activités</p>
                    </div>
                </div>
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
                    <div class="space-y-1">
                        <c:forEach items="${recentMovements}" var="mouvement" varStatus="status">
                            <c:if test="${status.index < 6}">
                                <div class="animate-list-item flex items-center gap-4 p-3 rounded-lg hover:bg-base-200 transition-colors" style="animation-delay: ${status.index * 0.05}s;">
                                    <div class="flex-shrink-0">
                                        <c:choose>
                                            <c:when test="${mouvement.type == 'ENTREE'}">
                                                <div class="timeline-icon bg-success/10 text-success border border-success/20">
                                                    <i class="fas fa-arrow-down"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'SORTIE'}">
                                                <div class="timeline-icon bg-error/10 text-error border border-error/20">
                                                    <i class="fas fa-arrow-up"></i>
                                                </div>
                                            </c:when>
                                            <c:when test="${mouvement.type == 'AFFECTATION'}">
                                                <div class="timeline-icon bg-info/10 text-info border border-info/20">
                                                    <i class="fas fa-user-plus"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="timeline-icon bg-warning/10 text-warning border border-warning/20">
                                                    <i class="fas fa-undo"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="flex-1 min-w-0">
                                        <p class="font-medium truncate">${mouvement.materiel.designation}</p>
                                        <p class="text-sm text-base-content/60 flex items-center gap-2 flex-wrap">
                                            <t:movementBadge type="${mouvement.type}" />
                                            <span class="text-base-content/30">•</span>
                                            <c:choose>
                                                <c:when test="${mouvement.dateMouvement != null}">
                                                    <i class="far fa-clock text-xs"></i>
                                                    <t:formatDateTime date="${mouvement.dateMouvement}" pattern="dd/MM/yy HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-base-content/40">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                    <span class="badge badge-ghost badge-sm">${mouvement.quantite}</span>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                    <div class="mt-4 pt-4 border-t border-base-200 text-center">
                        <a href="${pageContext.request.contextPath}/mouvements" class="btn btn-ghost btn-sm hover:bg-primary/10 hover:text-primary transition-colors">
                            Voir tous les mouvements <i class="fas fa-arrow-right ml-1"></i>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Quick Actions Section -->
<div class="mt-6 animate-fade-in" style="animation-delay: 0.4s;">
    <div class="card-clean">
        <div class="card-body">
            <h2 class="card-title">
                <i class="fas fa-bolt text-warning"></i>
                Actions rapides
            </h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3 mt-4">
                <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-outline justify-start gap-3 h-auto py-3 hover:bg-primary hover:text-white hover:border-primary transition-all">
                    <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center group-hover:bg-white/20">
                        <i class="fas fa-plus text-primary group-hover:text-white"></i>
                    </div>
                    <div class="text-left">
                        <span class="font-medium block">Nouveau matériel</span>
                        <span class="text-xs opacity-70">Ajouter à l'inventaire</span>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-outline justify-start gap-3 h-auto py-3 hover:bg-info hover:text-white hover:border-info transition-all">
                    <div class="w-10 h-10 rounded-lg bg-info/10 flex items-center justify-center">
                        <i class="fas fa-user-plus text-info"></i>
                    </div>
                    <div class="text-left">
                        <span class="font-medium block">Nouvel employé</span>
                        <span class="text-xs opacity-70">Ajouter au personnel</span>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-outline justify-start gap-3 h-auto py-3 hover:bg-success hover:text-white hover:border-success transition-all">
                    <div class="w-10 h-10 rounded-lg bg-success/10 flex items-center justify-center">
                        <i class="fas fa-box text-success"></i>
                    </div>
                    <div class="text-left">
                        <span class="font-medium block">Voir matériels</span>
                        <span class="text-xs opacity-70">Liste complète</span>
                    </div>
                </a>
                
                <a href="${pageContext.request.contextPath}/materiels/alertes" class="btn btn-outline justify-start gap-3 h-auto py-3 hover:bg-warning hover:text-white hover:border-warning transition-all">
                    <div class="w-10 h-10 rounded-lg bg-warning/10 flex items-center justify-center">
                        <i class="fas fa-bell text-warning"></i>
                    </div>
                    <div class="text-left">
                        <span class="font-medium block">Alertes</span>
                        <span class="text-xs opacity-70">${alertesCount != null ? alertesCount : 0} en attente</span>
                    </div>
                </a>
            </div>
        </div>
    </div>
</div>
