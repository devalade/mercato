<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-box text-primary mr-3"></i>
            Liste des Matériels
        </h1>
        <p class="text-gray-600">Gérez votre inventaire de matériels</p>
    </div>
    <t:button href="${pageContext.request.contextPath}/materiels/new" variant="primary" icon="fa-plus">
        Nouveau Matériel
    </t:button>
</div>

<!-- Filters -->
<div class="card bg-base-100 shadow-xl mb-6">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/materiels" method="get" class="flex flex-wrap gap-4 items-end">
            <div class="form-control flex-1 min-w-[200px]">
                <label class="label">
                    <span class="label-text">Recherche</span>
                </label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" name="search" value="${param.search}" 
                           placeholder="Référence ou désignation..." 
                           class="input input-bordered w-full pl-10" />
                </div>
            </div>
            
            <div class="form-control w-48">
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
            
            <div class="form-control w-48">
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
            
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-filter mr-2"></i>Filtrer
            </button>
            
            <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost">
                <i class="fas fa-times mr-2"></i>Réinitialiser
            </a>
        </form>
    </div>
</div>

<!-- Materials Table -->
<div class="card bg-base-100 shadow-xl">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty materiels}">
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>Aucun matériel trouvé</h3>
                    <p>Commencez par ajouter un nouveau matériel à l'inventaire</p>
                    <a href="${pageContext.request.contextPath}/materiels/new" class="btn btn-primary mt-4">
                        <i class="fas fa-plus mr-2"></i>Ajouter un matériel
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="table table-zebra w-full">
                        <thead>
                            <tr>
                                <th>Référence</th>
                                <th>Désignation</th>
                                <th>Catégorie</th>
                                <th class="text-center">Quantité</th>
                                <th>Statut</th>
                                <th>Date Expiration</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${materiels}" var="materiel">
                                <tr class="hover">
                                    <td class="font-mono font-semibold">${materiel.reference}</td>
                                    <td>${materiel.designation}</td>
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
                                                <fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" />
                                                <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                                <c:if test="${joursRestants >= 0 && joursRestants <= 60}">
                                                    <span class="badge badge-sm ${joursRestants < 30 ? 'badge-error' : 'badge-warning'} ml-2">
                                                        ${joursRestants}j
                                                    </span>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-gray-400">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="flex justify-center gap-2">
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                               class="btn btn-sm btn-info btn-outline" title="Détail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/edit" 
                                               class="btn btn-sm btn-warning btn-outline" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/materiels/delete" method="post" 
                                                  class="inline" onsubmit="return confirm('Êtes-vous sûr de vouloir archiver ce matériel?');">
                                                <input type="hidden" name="id" value="${materiel.id}" />
                                                <button type="submit" class="btn btn-sm btn-error btn-outline" title="Archiver">
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
                
                <!-- Pagination (simplified) -->
                <div class="flex justify-between items-center mt-4">
                    <p class="text-sm text-gray-500">
                        Affichage de ${materiels.size()} matériel(s)
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>