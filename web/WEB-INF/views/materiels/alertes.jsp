<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-exclamation-triangle text-warning text-xl"></i>
        </div>
        <div>
            <h1>Alertes d'expiration</h1>
            <p class="page-header-subtitle">Matériels expirant dans les 60 prochains jours</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
    </div>
</div>

<!-- Alerts Content -->
<div class="card-clean">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty alertes}">
                <div class="empty-state py-12">
                    <div class="empty-state-icon !bg-success/10 !text-success">
                        <i class="fas fa-check-circle text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-bold text-success">Aucune alerte !</h3>
                    <p class="text-base-content/60">Tous vos matériels sont en bon état et ne risquent pas d'expirer prochainement.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning mb-6">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span><strong>${alertes.size()}</strong> matériel(s) nécessitent votre attention</span>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="table-clean">
                        <thead>
                            <tr>
                                <th>Référence</th>
                                <th>Désignation</th>
                                <th>Catégorie</th>
                                <th class="text-center">Qté</th>
                                <th>Expiration</th>
                                <th>Statut</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${alertes}" var="materiel">
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
                                        <c:choose>
                                            <c:when test="${materiel.dateExpiration != null}">
                                                <t:formatDateTime date="${materiel.dateExpiration}" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-base-content/40">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                        <div class="flex items-center gap-2">
                                            <progress class="progress w-16 ${joursRestants < 30 ? 'progress-error' : 'progress-warning'}" 
                                                      value="${joursRestants}" max="60"></progress>
                                            <span class="badge badge-xs ${joursRestants < 30 ? 'badge-error' : 'badge-warning'}">
                                                ${joursRestants}j
                                            </span>
                                        </div>
                                    </td>
                                    <td class="text-right">
                                        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" 
                                           class="btn btn-sm btn-ghost text-info">
                                            <i class="fas fa-eye mr-1"></i> Détails
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
