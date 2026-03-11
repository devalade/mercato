<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-exclamation-triangle text-warning mr-3"></i>
            Alertes d'expiration
        </h1>
        <p class="text-gray-600">Matériels expirant dans les 60 prochains jours</p>
    </div>
    <t:button href="${pageContext.request.contextPath}/materiels" variant="ghost" icon="fa-arrow-left">
        Retour aux matériels
    </t:button>
</div>

<div class="card bg-base-100 shadow-xl">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty alertes}">
                <div class="empty-state py-12">
                    <div class="w-24 h-24 bg-success rounded-full flex items-center justify-center mx-auto mb-6">
                        <i class="fas fa-check-circle text-5xl text-success-content"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-success mb-2">Aucune alerte !</h3>
                    <p class="text-gray-600">Tous vos matériels sont en bon état et ne risquent pas d'expirer prochainement.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning mb-6">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span><strong>${alertes.size()}</strong> matériel(s) nécessitent votre attention</span>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="table table-zebra w-full">
                        <thead>
                            <tr>
                                <th>Référence</th>
                                <th>Désignation</th>
                                <th>Catégorie</th>
                                <th>Quantité</th>
                                <th>Date d'expiration</th>
                                <th>Jours restants</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${alertes}" var="materiel">
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
                                        <fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" />
                                    </td>
                                    <td>
                                        <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                        <div class="flex items-center gap-2">
                                            <progress class="progress w-20 ${joursRestants < 30 ? 'progress-error' : 'progress-warning'}" 
                                                      value="${joursRestants}" max="60"></progress>
                                            <span class="badge ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}">
                                                ${joursRestants} j
                                            </span>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                           class="btn btn-sm btn-info btn-outline">
                                            <i class="fas fa-eye"></i> Détails
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>