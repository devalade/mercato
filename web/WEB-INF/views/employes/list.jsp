<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-users text-primary mr-3"></i>
            Liste des Employés
        </h1>
        <p class="text-gray-600">Gérez le personnel de l'entreprise</p>
    </div>
    <t:button href="${pageContext.request.contextPath}/employes/new" variant="primary" icon="fa-plus">
        Nouvel Employé
    </t:button>
</div>

<div class="card bg-base-100 shadow-xl">
    <div class="card-body">
        <c:choose>
            <c:when test="${empty employes}">
                <div class="empty-state">
                    <i class="fas fa-users-slash"></i>
                    <h3>Aucun employé enregistré</h3>
                    <p>Commencez par ajouter un nouvel employé</p>
                    <a href="${pageContext.request.contextPath}/employes/new" class="btn btn-primary mt-4">
                        <i class="fas fa-plus mr-2"></i>Ajouter un employé
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="overflow-x-auto">
                    <table class="table table-zebra w-full">
                        <thead>
                            <tr>
                                <th>Matricule</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Service</th>
                                <th class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${employes}" var="employe">
                                <tr class="hover">
                                    <td class="font-mono font-semibold">${employe.matricule}</td>
                                    <td>${employe.nom}</td>
                                    <td>${employe.prenom}</td>
                                    <td>
                                        <span class="badge badge-ghost">${employe.service}</span>
                                    </td>
                                    <td>
                                        <div class="flex justify-center gap-2">
                                            <a href="${pageContext.request.contextPath}/employes/${employe.id}" 
                                               class="btn btn-sm btn-info btn-outline" title="Détail">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/employes/${employe.id}/edit" 
                                               class="btn btn-sm btn-warning btn-outline" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <div class="flex justify-between items-center mt-4">
                    <p class="text-sm text-gray-500">
                        Affichage de ${employes.size()} employé(s)
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>