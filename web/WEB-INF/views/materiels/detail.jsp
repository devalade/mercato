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
            <h1>Détail du Matériel</h1>
            <p class="page-header-subtitle">Informations complètes et historique</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/edit" class="btn btn-warning btn-sm gap-2">
            <i class="fas fa-edit"></i>
            Modifier
        </a>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Material Info Card -->
    <div class="lg:col-span-2 space-y-6">
        <!-- Main Info -->
        <div class="card-clean">
            <div class="card-body">
                <div class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4 mb-6">
                    <div>
                        <h2 class="text-xl font-bold">${materiel.designation}</h2>
                        <p class="font-mono text-base-content/60 mt-1">${materiel.reference}</p>
                    </div>
                    <t:statusBadge status="${materiel.statut}" />
                </div>
                
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4">
                    <div class="bg-base-200 p-4 rounded-lg text-center">
                        <p class="text-sm text-base-content/60 mb-1">Catégorie</p>
                        <p class="font-semibold">${materiel.categorie}</p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg text-center">
                        <p class="text-sm text-base-content/60 mb-1">Quantité</p>
                        <p class="font-semibold text-xl">${materiel.quantiteStock}</p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg text-center">
                        <p class="text-sm text-base-content/60 mb-1">Date d'achat</p>
                        <p class="font-semibold">
                            <c:choose>
                                <c:when test="${materiel.dateAchat != null}">
                                    <t:formatDateTime date="${materiel.dateAchat}" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg text-center">
                        <p class="text-sm text-base-content/60 mb-1">Durée de vie</p>
                        <p class="font-semibold">${materiel.dureeVieJours} j</p>
                    </div>
                </div>
                
                <!-- Expiration Info -->
                <div class="mt-6 pt-6 border-t border-base-200">
                    <h3 class="font-semibold mb-3 flex items-center gap-2">
                        <i class="fas fa-calendar-alt text-base-content/60"></i>
                        Date d'expiration
                    </h3>
                    <c:choose>
                        <c:when test="${materiel.dateExpiration != null}">
                            <div class="flex items-center gap-4">
                                <p class="text-lg font-medium">
                                    <t:formatDateTime date="${materiel.dateExpiration}" />
                                </p>
                                <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                <span class="badge badge-lg ${joursRestants < 30 ? 'badge-error' : (joursRestants < 60 ? 'badge-warning' : 'badge-success')}">
                                    ${joursRestants} jours restants
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="text-base-content/50">Non définie</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        
        <!-- History Section -->
        <div class="card-clean">
            <div class="card-body">
                <div class="flex items-center gap-2 mb-4">
                    <i class="fas fa-history text-info text-xl"></i>
                    <h2 class="card-title">Historique des Mouvements</h2>
                </div>
                
                <c:choose>
                    <c:when test="${empty historique}">
                        <div class="empty-state py-8">
                            <div class="empty-state-icon">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
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
                                        <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-2">
                                            <div>
                                                <t:movementBadge type="${mouvement.type}" />
                                                <p class="text-sm text-base-content/60 mt-1">
                                                    <t:formatDateTime date="${mouvement.dateMouvement}" />
                                                </p>
                                                <c:if test="${not empty mouvement.employe}">
                                                    <p class="text-sm text-info mt-1 flex items-center gap-1">
                                                        <i class="fas fa-user"></i>
                                                        ${mouvement.employe.prenom} ${mouvement.employe.nom}
                                                    </p>
                                                </c:if>
                                            </div>
                                            <span class="badge badge-ghost">Qté: ${mouvement.quantite}</span>
                                        </div>
                                        <c:if test="${not empty mouvement.commentaire}">
                                            <p class="text-sm text-base-content/70 mt-2 bg-base-100 p-2 rounded">
                                                <i class="fas fa-comment mr-1 text-base-content/40"></i>
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
        <div class="card-clean sticky top-24">
            <div class="card-body">
                <h2 class="card-title flex items-center gap-2">
                    <i class="fas fa-cogs text-primary"></i>
                    Actions
                </h2>
                
                <div class="space-y-2 mt-4">
                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/entree" 
                       class="btn btn-success w-full justify-start gap-2">
                        <i class="fas fa-arrow-down"></i>
                        Entrée de stock
                    </a>
                    
                    <c:if test="${materiel.quantiteStock > 0}">
                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/sortie" 
                           class="btn btn-error w-full justify-start gap-2">
                            <i class="fas fa-arrow-up"></i>
                            Sortie de stock
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}/affectation" 
                           class="btn btn-info w-full justify-start gap-2">
                            <i class="fas fa-user-plus"></i>
                            Affecter à un employé
                        </a>
                    </c:if>
                    
                    <div class="divider my-2"></div>
                    
                    <form action="${pageContext.request.contextPath}/materiels/delete" method="post" 
                          onsubmit="return confirm('Êtes-vous sûr de vouloir archiver ce matériel? Cette action est irréversible.');">
                        <input type="hidden" name="id" value="${materiel.id}" />
                        <button type="submit" class="btn btn-error btn-outline w-full justify-start gap-2">
                            <i class="fas fa-archive"></i>
                            Archiver le matériel
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
