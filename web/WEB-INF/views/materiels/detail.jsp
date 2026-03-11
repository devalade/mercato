<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-box text-primary mr-3"></i>
            Détail du Matériel
        </h1>
        <p class="text-gray-600">Informations complètes et historique</p>
    </div>
    <div class="flex gap-2">
        <t:button href="${pageContext.request.contextPath}/materiels" variant="ghost" icon="fa-arrow-left">
            Retour
        </t:button>
        <t:button href="${pageContext.request.contextPath}/materiels/${materiel.id}/edit" variant="warning" icon="fa-edit">
            Modifier
        </t:button>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Material Info Card -->
    <div class="lg:col-span-2">
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
                <div class="flex justify-between items-start mb-6">
                    <div>
                        <h2 class="card-title text-2xl">${materiel.designation}</h2>
                        <p class="text-gray-500 font-mono mt-1">${materiel.reference}</p>
                    </div>
                    <t:statusBadge status="${materiel.statut}" />
                </div>
                
                <div class="grid grid-cols-2 gap-4 mb-6">
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-gray-500 mb-1">Catégorie</p>
                        <p class="font-semibold">${materiel.categorie}</p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-gray-500 mb-1">Quantité en stock</p>
                        <p class="font-semibold text-2xl">${materiel.quantiteStock}</p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-gray-500 mb-1">Date d'achat</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${materiel.dateAchat != null}">
                                    <fmt:formatDate value="${materiel.dateAchat}" pattern="dd/MM/yyyy" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-gray-500 mb-1">Durée de vie</p>
                        <p class="font-semibold">${materiel.dureeVieJours} jours</p>
                    </div>
                </div>
                
                <div class="border-t pt-4">
                    <h3 class="font-bold mb-3">Date d'expiration</h3>
                    <c:choose>
                        <c:when test="${materiel.dateExpiration != null}">
                            <div class="flex items-center gap-4">
                                <p class="text-lg">
                                    <fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" />
                                </p>
                                <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                <span class="badge ${joursRestants < 30 ? 'badge-error' : (joursRestants < 60 ? 'badge-warning' : 'badge-success')} badge-lg">
                                    ${joursRestants} jours restants
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-gray-500">Non définie</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- History Section -->
        <div class="card bg-base-100 shadow-xl mt-6">
            <div class="card-body">
                <h2 class="card-title text-xl mb-4">
                    <i class="fas fa-history text-info mr-2"></i>
                    Historique des Mouvements
                </h2>
                
                <c:choose>
                    <c:when test="${empty historique}">
                        <div class="empty-state py-8">
                            <i class="fas fa-clipboard-list"></i>
                            <h3>Aucun mouvement</h3>
                            <p>L'historique des mouvements apparaîtra ici</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach items="${historique}" var="mouvement">
                                <div class="flex items-start gap-4 p-4 bg-base-200 rounded-lg">
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
                                        <div class="flex justify-between items-start">
                                            <div>
                                                <p class="font-semibold">
                                                    <t:movementBadge type="${mouvement.type}" />
                                                </p>
                                                <p class="text-sm text-gray-500 mt-1">
                                                    <fmt:formatDate value="${mouvement.dateMouvement}" pattern="dd/MM/yyyy HH:mm" />
                                                </p>
                                                <c:if test="${not empty mouvement.employe}">
                                                    <p class="text-sm text-info mt-1">
                                                        <i class="fas fa-user mr-1"></i>
                                                        ${mouvement.employe.prenom} ${mouvement.employe.nom}
                                                    </p>
                                                </c:if>
                                            </div>
                                            <span class="badge badge-ghost badge-lg">Qté: ${mouvement.quantite}</span>
                                        </div>
                                        <c:if test="${not empty mouvement.commentaire}">
                                            <p class="text-sm text-gray-600 mt-2 bg-base-100 p-2 rounded">
                                                <i class="fas fa-comment mr-1"></i>
                                                ${mouvement.commentaire}
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Actions Sidebar -->
    <div class="lg:col-span-1">
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
                <h2 class="card-title text-xl mb-4">
                    <i class="fas fa-cogs text-primary mr-2"></i>
                    Actions
                </h2>
                
                <div class="space-y-3">
                    <c:if test="${materiel.quantiteStock > 0}">
                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/sortie" 
                           class="btn btn-error w-full justify-start">
                            <i class="fas fa-arrow-up mr-2"></i>
                            Sortie de stock
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/affectation" 
                           class="btn btn-info w-full justify-start">
                            <i class="fas fa-user-plus mr-2"></i>
                            Affecter à un employé
                        </a>
                    </c:if>
                    
                    <div class="divider"></div>
                    
                    <form action="${pageContext.request.contextPath}/materiels/delete" method="post" 
                          onsubmit="return confirm('Êtes-vous sûr de vouloir archiver ce matériel? Cette action est irréversible.');">
                        <input type="hidden" name="id" value="${materiel.id}" />
                        <button type="submit" class="btn btn-error btn-outline w-full justify-start">
                            <i class="fas fa-archive mr-2"></i>
                            Archiver le matériel
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>