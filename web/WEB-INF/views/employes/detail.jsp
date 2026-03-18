<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-user text-xl"></i>
        </div>
        <div>
            <h1>Détail de l'Employé</h1>
            <p class="page-header-subtitle">Informations et matériels affectés</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/employes" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
        <a href="${pageContext.request.contextPath}/employes/${employe.id}/edit" class="btn btn-warning btn-sm gap-2">
            <i class="fas fa-edit"></i>
            Modifier
        </a>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Employee Info Card -->
    <div class="lg:col-span-1">
        <div class="card-clean">
            <div class="card-body text-center">
                <!-- Avatar -->
                <div class="avatar avatar-placeholder mx-auto mb-4">
                    <div class="bg-primary text-primary-content rounded-full w-24 h-24 text-2xl font-bold flex items-center justify-center">
                        ${employe.prenom.charAt(0)}${employe.nom.charAt(0)}
                    </div>
                </div>
                
                <h2 class="text-xl font-bold">${employe.prenom} ${employe.nom}</h2>
                <p class="font-mono text-base-content/60 mt-1">${employe.matricule}</p>
                
                <div class="mt-6 text-left">
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-base-content/60 mb-1">Service</p>
                        <p class="font-semibold">${employe.service}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Assigned Materials -->
    <div class="lg:col-span-2">
        <div class="card-clean">
            <div class="card-body">
                <div class="flex items-center gap-2 mb-4">
                    <i class="fas fa-box text-info text-xl"></i>
                    <h2 class="card-title">Matériels Affectés</h2>
                </div>
                
                <c:choose>
                    <c:when test="${empty mouvements}">
                        <div class="empty-state py-8">
                            <div class="empty-state-icon">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <h3>Aucun matériel affecté</h3>
                            <p>Cet employé n'a pas encore de matériel assigné</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="space-y-3">
                            <c:forEach items="${mouvements}" var="mouvement">
                                <c:if test="${mouvement.type == 'AFFECTATION'}">
                                    <div class="flex items-start gap-4 p-4 bg-base-200 rounded-lg">
                                        <div class="flex-shrink-0">
                                            <div class="timeline-icon bg-info/10 text-info">
                                                <i class="fas fa-box"></i>
                                            </div>
                                        </div>
                                        <div class="flex-1 min-w-0">
                                            <div class="flex flex-col sm:flex-row sm:justify-between sm:items-start gap-2">
                                                <div>
                                                    <p class="font-semibold">${mouvement.materiel.designation}</p>
                                                    <p class="text-sm text-base-content/60 font-mono">${mouvement.materiel.reference}</p>
                                                    <p class="text-sm text-base-content/50 mt-1">
                                                        <i class="fas fa-calendar mr-1"></i>
                                                        <fmt:formatDate value="${mouvement.dateMouvement}" pattern="dd/MM/yyyy" />
                                                    </p>
                                                </div>
                                                <span class="badge badge-info">Qté: ${mouvement.quantite}</span>
                                            </div>
                                            <c:if test="${not empty mouvement.commentaire}">
                                                <p class="text-sm text-base-content/70 mt-2 bg-base-100 p-2 rounded">
                                                    <i class="fas fa-comment mr-1 text-base-content/40"></i>
                                                    ${mouvement.commentaire}
                                                </p>
                                            </c:if>
                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/materiels/${mouvement.materiel.id}" 
                                                   class="btn btn-sm btn-ghost text-info gap-1">
                                                    <i class="fas fa-eye"></i> Voir le matériel
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
