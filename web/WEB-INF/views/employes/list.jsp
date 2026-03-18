<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-users text-xl"></i>
        </div>
        <div>
            <h1>Liste des Employés</h1>
            <p class="page-header-subtitle">Gérez le personnel de l'entreprise</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-primary btn-sm gap-2">
            <i class="fas fa-plus"></i>
            <span class="hidden sm:inline">Nouvel Employé</span>
        </a>
    </div>
</div>

<!-- Employees Table -->
<div class="card-clean">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty employes}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-users-slash"></i>
                    </div>
                    <h3>Aucun employé enregistré</h3>
                    <p>Commencez par ajouter un nouvel employé</p>
                    <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-primary mt-4">
                        <i class="fas fa-plus mr-2"></i>Ajouter un employé
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="table-clean">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Service</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${employes}" var="employe">
                                <tr>
                                    <td class="font-mono font-medium">${employe.matricule}</td>
                                    <td class="font-medium">${employe.nom}</td>
                                    <td>${employe.prenom}</td>
                                    <td>
                                        <span class="badge badge-ghost">${employe.service}</span>
                                    </td>
                                    <td>
                                        <div class="flex justify-end gap-1">
                                            <a href="${pageContext.request.contextPath}/employes/${employe.id}" 
                                               class="btn btn-sm btn-ghost text-info" title="Détail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/employes/${employe.id}/edit" 
                                               class="btn btn-sm btn-ghost text-warning" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
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
                        <i class="fas fa-users mr-1"></i>
                        ${employes.size()} employé(s) enregistré(s)
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
