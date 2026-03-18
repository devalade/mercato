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
        <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary btn-sm gap-2">
            <i class="fas fa-plus"></i>
            <span class="hidden sm:inline">Nouveau</span>
        </a>
    </div>
</div>

<!-- Filters -->
<div class="filter-bar">
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
                           class="input input-bordered w-full pl-10" />
                </div>
            </div>
            
            <div class="form-group" style="min-width: 150px;">
                <label class="label">
                    <span class="label-text">Catégorie</span>
                </label>
                <select name="categorie" class="select select-bordered w-full">
                    <option value="">Toutes</option>
                    <c:forEach items="${categories}" var="cat">
                        <option value="${cat}" ${param.categorie == cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="min-width: 150px;">
                <label class="label">
                    <span class="label-text">Statut</span>
                </label>
                <select name="statut" class="select select-bordered w-full">
                    <option value="">Tous</option>
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
            </div>
            
            <div class="flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-filter mr-1"></i>Filtrer
                </button>
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost">
                    <i class="fas fa-times"></i>
                </a>
            </div>
        </form>
    </div>
</div>

<!-- Materials Table -->
<div class="card-clean">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty materiels}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-box-open"></i>
                    </div>
                    <h3>Aucun matériel trouvé</h3>
                    <p>Commencez par ajouter un nouveau matériel à l'inventaire</p>
                    <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary mt-4">
                        <i class="fas fa-plus mr-2"></i>Ajouter un matériel
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="table-clean">
                        <thead>
                            <tr>
                                <th>Référence</th>
                                <th>Désignation</th>
                                <th>Catégorie</th>
                                <th class="text-center">Qté</th>
                                <th>Statut</th>
                                <th>Expiration</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${materiels}" var="materiel">
                                <tr>
                                    <td class="font-mono font-medium">${materiel.reference}</td>
                                    <td>
                                        <div class="font-medium">${materiel.designation}</div>
                                    </td>
                                    <td>
                                        <span class="badge badge-ghost">${materiel.categorie}</span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge badge-outline">${materiel.quantiteStock}</span>
                                    </td>
                                    <td>
                                        <t:statusBadge status="${materiel.statut}" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${materiel.dateExpiration != null}">
                                                <div class="flex items-center gap-2">
                                                    <t:formatDateTime date="${materiel.dateExpiration}" pattern="dd/MM/yy HH:mm" />
                                                    <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                                    <c:if test="${joursRestants >= 0 && joursRestants <= 60}">
                                                        <span class="badge badge-xs ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}">
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
                                        <div class="flex justify-end gap-1">
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                               class="btn btn-sm btn-ghost text-info" title="Détail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/edit" 
                                               class="btn btn-sm btn-ghost text-warning" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/materiels/delete" method="post" 
                                                  class="inline" onsubmit="return confirm('Êtes-vous sûr de vouloir archiver ce matériel?');">
                                                <input type="hidden" name="id" value="${materiel.id}" />
                                                <button type="submit" class="btn btn-sm btn-ghost text-error" title="Archiver">
                                                    <i class="fas fa-archive"></i>
                                                </button>
                                            </form>
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
                        ${materiels.size()} matériel(s) affiché(s)
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
