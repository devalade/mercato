<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-user text-primary mr-3"></i>
            Détail de l'Employé
        </h1>
        <p class="text-gray-600">Informations et matériels affectés</p>
    </div>
    <div class="flex gap-2">
        <t:button href="${pageContext.request.contextPath}/employes" variant="ghost" icon="fa-arrow-left">
            Retour
        </t:button>
        <t:button href="${pageContext.request.contextPath}/employes/${employe.id}/edit" variant="warning" icon="fa-edit">
            Modifier
        </t:button>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Employee Info Card -->
    <div class="lg:col-span-1">
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
                <div class="text-center mb-6">
                    <div class="w-24 h-24 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
                        <span class="text-4xl text-primary-content font-bold">
                            ${employe.prenom.charAt(0)}${employe.nom.charAt(0)}
                        </span>
                    </div>
                    <h2 class="text-2xl font-bold">${employe.prenom} ${employe.nom}</h2>
                    <p class="text-gray-500 font-mono">${employe.matricule}</p>
                </div>
                
                <div class="space-y-4">
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-gray-500 mb-1">Service</p>
                        <p class="font-semibold">${employe.service}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Assigned Materials -->
    <div class="lg:col-span-2">
        <div class="card bg-base-100 shadow-xl">
            <div class="card-body">
                <h2 class="card-title text-xl mb-4">
                    <i class="fas fa-box text-info mr-2"></i>
                    Matériels Affectés
                </h2>
                
                <c:choose>
                    <c:when test="${empty mouvements}">
                        <div class="empty-state py-8">
                            <i class="fas fa-box-open"></i>
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
                                            <div class="w-10 h-10 rounded-full bg-info flex items-center justify-center">
                                                <i class="fas fa-box text-info-content"></i>
                                            </div>
                                        </div>
                                        <div class="flex-1">
                                            <div class="flex justify-between items-start">
                                                <div>
                                                    <p class="font-semibold">${mouvement.materiel.designation}</p>
                                                    <p class="text-sm text-gray-500">${mouvement.materiel.reference}</p>
                                                    <p class="text-sm text-gray-500 mt-1">
                                                        <fmt:formatDate value="${mouvement.dateMouvement}" pattern="dd/MM/yyyy" />
                                                    </p>
                                                </div>
                                                <span class="badge badge-info">Qté: ${mouvement.quantite}</span>
                                            </div>
                                            <c:if test="${not empty mouvement.commentaire}">
                                                <p class="text-sm text-gray-600 mt-2">
                                                    <i class="fas fa-comment mr-1"></i>
                                                    ${mouvement.commentaire}
                                                </p>
                                            </c:if>
                                            <div class="mt-3">
                                                <a href="${pageContext.request.contextPath}/materiels/${mouvement.materiel.id}" 
                                                   class="btn btn-sm btn-info btn-outline">
                                                    <i class="fas fa-eye mr-1"></i> Voir le matériel
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