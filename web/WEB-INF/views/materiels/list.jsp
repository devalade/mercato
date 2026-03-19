<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-box text-xl"></i>
        </div>
        <div>
            <h1>Liste des Matériels</h1>
            <p class="page-header-subtitle">Gérez votre inventaire de matériels</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary btn-sm gap-2 btn-ripple">
            <i class="fas fa-plus"></i>
            <span class="hidden sm:inline">Nouveau</span>
        </a>
    </div>
</div>

<!-- Filters -->
<div class="filter-bar animate-fade-in">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/materiels" method="get" class="filter-form">
            <div class="form-group">
                <label class="label">
                    <span class="label-text">Recherche</span>
                </label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" name="search" value="${param.search}" 
                           placeholder="Référence ou désignation..." 
                           class="input input-bordered w-full pl-10 focus:input-primary" />
                </div>
            </div>
            
            <div class="form-group" style="min-width: 150px;">
                <label class="label">
                    <span class="label-text">Catégorie</span>
                </label>
                <div class="relative">
                    <select name="categorie" class="select select-bordered w-full appearance-none">
                        <option value="">Toutes les catégories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat}" ${param.categorie == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                    <span class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none text-base-content/40">
                        <i class="fas fa-chevron-down text-xs"></i>
                    </span>
                </div>
            </div>
            
            <div class="form-group" style="min-width: 150px;">
                <label class="label">
                    <span class="label-text">Statut</span>
                </label>
                <div class="relative">
                    <select name="statut" class="select select-bordered w-full appearance-none">
                        <option value="">Tous les statuts</option>
                        <c:forEach items="${statuts}" var="s">
                            <option value="${s}" ${param.statut == s ? 'selected' : ''}>
                                <c:choose>
                                    <c:when test="${s == 'EN_STOCK'}">En stock</c:when>
                                    <c:when test="${s == 'AFFECTE'}">Affecté</c:when>
                                    <c:when test="${s == 'HORS_SERVICE'}">Hors service</c:when>
                                    <c:when test="${s == 'EXPIRE'}">Expiré</c:when>
                                </c:choose>
                            </option>
                        </c:forEach>
                    </select>
                    <span class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none text-base-content/40">
                        <i class="fas fa-chevron-down text-xs"></i>
                    </span>
                </div>
            </div>
            
            <div class="flex gap-2">
                <button type="submit" class="btn btn-primary btn-ripple">
                    <i class="fas fa-filter mr-1"></i>Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost" title="Réinitialiser">
                    <i class="fas fa-times"></i>
                </a>
            </div>
        </form>
        
        <!-- Active Filter Tags -->
        <c:if test="${not empty param.search or not empty param.categorie or not empty param.statut}">
            <div class="filter-tags">
                <span class="text-sm text-base-content/60 mr-2">Filtres actifs:</span>
                <c:if test="${not empty param.search}">
                    <span class="filter-tag">
                        <i class="fas fa-search text-xs"></i>
                        Recherche: ${param.search}
                        <a href="${pageContext.request.contextPath}/materiels?${not empty param.categorie ? 'categorie='.concat(param.categorie).concat('&') : ''}${not empty param.statut ? 'statut='.concat(param.statut) : ''}" class="remove">
                            <i class="fas fa-times"></i>
                        </a>
                    </span>
                </c:if>
                <c:if test="${not empty param.categorie}">
                    <span class="filter-tag">
                        <i class="fas fa-tag text-xs"></i>
                        ${param.categorie}
                        <a href="${pageContext.request.contextPath}/materiels?${not empty param.search ? 'search='.concat(param.search).concat('&') : ''}${not empty param.statut ? 'statut='.concat(param.statut) : ''}" class="remove">
                            <i class="fas fa-times"></i>
                        </a>
                    </span>
                </c:if>
                <c:if test="${not empty param.statut}">
                    <span class="filter-tag">
                        <i class="fas fa-circle text-xs"></i>
                        <c:choose>
                            <c:when test="${param.statut == 'EN_STOCK'}">En stock</c:when>
                            <c:when test="${param.statut == 'AFFECTE'}">Affecté</c:when>
                            <c:when test="${param.statut == 'HORS_SERVICE'}">Hors service</c:when>
                            <c:when test="${param.statut == 'EXPIRE'}">Expiré</c:when>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/materiels?${not empty param.search ? 'search='.concat(param.search).concat('&') : ''}${not empty param.categorie ? 'categorie='.concat(param.categorie) : ''}" class="remove">
                            <i class="fas fa-times"></i>
                        </a>
                    </span>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<!-- Materials Table -->
<div class="card-clean animate-fade-in" style="animation-delay: 0.1s;">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty materiels}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <h3>Aucun matériel trouvé</h3>
                    <p>
                        <c:choose>
                            <c:when test="${not empty param.search or not empty param.categorie or not empty param.statut}">
                                Essayez de modifier vos filtres de recherche
                            </c:when>
                            <c:otherwise>
                                Commencez par ajouter un nouveau matériel à l'inventaire
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${empty param.search and empty param.categorie and empty param.statut}">
                        <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary mt-4">
                            <i class="fas fa-plus mr-2"></i>Ajouter un matériel
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="table-clean">
                        <thead>
                            <tr>
                                <th>
                                    <div class="flex items-center gap-1 cursor-pointer hover:text-primary transition-colors">
                                        Référence
                                        <i class="fas fa-sort text-xs text-base-content/30"></i>
                                    </div>
                                </th>
                                <th>
                                    <div class="flex items-center gap-1 cursor-pointer hover:text-primary transition-colors">
                                        Désignation
                                        <i class="fas fa-sort text-xs text-base-content/30"></i>
                                    </div>
                                </th>
                                <th>Catégorie</th>
                                <th class="text-center">Qté</th>
                                <th>Statut</th>
                                <th>Expiration</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${materiels}" var="materiel" varStatus="status">
                                <tr class="animate-list-item ${materiel.getJoursRestants() >= 0 && materiel.getJoursRestants() <= 30 ? 'status-warning' : ''}" style="animation-delay: ${status.index * 0.03}s;">
                                    <td class="font-mono font-medium">${materiel.reference}</td>
                                    <td>
                                        <div class="font-medium">${materiel.designation}</div>
                                    </td>
                                    <td>
                                        <span class="badge badge-ghost gap-1">
                                            <i class="fas fa-tag text-xs"></i>
                                            ${materiel.categorie}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge badge-outline badge-sm font-mono">${materiel.quantiteStock}</span>
                                    </td>
                                    <td>
                                        <t:statusBadge status="${materiel.statut}" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${materiel.dateExpiration != null}">
                                                <div class="flex items-center gap-2">
                                                    <i class="far fa-calendar-alt text-base-content/40"></i>
                                                    <t:formatDateTime date="${materiel.dateExpiration}" pattern="dd/MM/yy" />
                                                    <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                                    <c:if test="${joursRestants >= 0 && joursRestants <= 60}">
                                                        <span class="badge badge-xs ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}" title="${joursRestants} jours restants">
                                                            ${joursRestants}j
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-base-content/40">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-group justify-end">
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                               class="btn btn-sm btn-ghost btn-action-view" title="Voir le détail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/edit" 
                                               class="btn btn-sm btn-ghost btn-action-edit" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" 
                                                    onclick="confirmArchive('${materiel.id}', '${materiel.designation}')"
                                                    class="btn btn-sm btn-ghost btn-action-delete" title="Archiver">
                                                <i class="fas fa-archive"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <!-- Results Summary -->
                <div class="flex justify-between items-center mt-4 pt-4 border-t border-base-200">
                    <p class="text-sm text-base-content/60">
                        <i class="fas fa-list mr-1"></i>
                        <strong>${materiels.size()}</strong> matériel(s) affiché(s)
                    </p>
                    <c:if test="${materiels.size() > 10}">
                        <div class="join">
                            <button class="join-item btn btn-sm btn-disabled">«</button>
                            <button class="join-item btn btn-sm btn-primary">1</button>
                            <button class="join-item btn btn-sm btn-ghost">2</button>
                            <button class="join-item btn btn-sm btn-ghost">»</button>
                        </div>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Archive Confirmation Modal (hidden by default) -->
<dialog id="archiveModal" class="modal">
    <div class="modal-box">
        <h3 class="font-bold text-lg flex items-center gap-2">
            <i class="fas fa-archive text-warning"></i>
            Confirmer l'archivage
        </h3>
        <p class="py-4">
            Êtes-vous sûr de vouloir archiver le matériel <strong id="archiveMaterialName"></strong> ?
            <br><br>
            <span class="text-sm text-base-content/60">
                <i class="fas fa-info-circle"></i>
                Cette action marquera le matériel comme archivé. Vous pourrez le restaurer ultérieurement.
            </span>
        </p>
        <div class="modal-action">
            <form method="dialog" class="flex gap-2">
                <button class="btn btn-ghost">Annuler</button>
            </form>
            <form action="${pageContext.request.contextPath}/materiels/delete" method="post" class="inline">
                <input type="hidden" name="id" id="archiveMaterialId" />
                <button type="submit" class="btn btn-warning">
                    <i class="fas fa-archive mr-2"></i>
                    Archiver
                </button>
            </form>
        </div>
    </div>
    <form method="dialog" class="modal-backdrop">
        <button>close</button>
    </form>
</dialog>

<script>
function confirmArchive(id, name) {
    document.getElementById('archiveMaterialId').value = id;
    document.getElementById('archiveMaterialName').textContent = name;
    document.getElementById('archiveModal').showModal();
}
</script>
