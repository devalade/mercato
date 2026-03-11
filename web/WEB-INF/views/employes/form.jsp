<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<c:set var="isEdit" value="${not empty employe}" />
<c:set var="pageTitle" value="${isEdit ? 'Modifier Employé' : 'Nouvel Employé'}" />

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-${isEdit ? 'edit' : 'user-plus'} text-primary mr-3"></i>
            ${pageTitle}
        </h1>
        <p class="text-gray-600">
            ${isEdit ? 'Modifiez les informations de l\'employé' : 'Ajoutez un nouvel employé'}
        </p>
    </div>
    <t:button href="${pageContext.request.contextPath}/employes" variant="ghost" icon="fa-arrow-left">
        Retour à la liste
    </t:button>
</div>

<div class="card bg-base-100 shadow-xl max-w-2xl mx-auto">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/employes/${isEdit ? 'update' : 'create'}" 
              method="post" class="space-y-6">
            
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${employe.id}" />
            </c:if>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Matricule -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Matricule *</span>
                    </label>
                    <input type="text" name="matricule" value="${employe.matricule}" 
                           class="input input-bordered w-full font-mono" 
                           placeholder="Ex: EMP001" required
                           ${isEdit ? 'readonly' : ''} />
                    <label class="label">
                        <span class="label-text-alt">Identifiant unique de l'employé</span>
                    </label>
                </div>
                
                <!-- Service -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Service *</span>
                    </label>
                    <input type="text" name="service" value="${employe.service}" 
                           class="input input-bordered w-full" 
                           placeholder="Ex: Informatique" required />
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Nom -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Nom *</span>
                    </label>
                    <input type="text" name="nom" value="${employe.nom}" 
                           class="input input-bordered w-full" 
                           placeholder="Ex: Dupont" required />
                </div>
                
                <!-- Prénom -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Prénom *</span>
                    </label>
                    <input type="text" name="prenom" value="${employe.prenom}" 
                           class="input input-bordered w-full" 
                           placeholder="Ex: Jean" required />
                </div>
            </div>
            
            <!-- Form Actions -->
            <div class="flex justify-end gap-4 pt-4 border-t">
                <a href="${pageContext.request.contextPath}/employes" class="btn btn-ghost">
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-2"></i>
                    ${isEdit ? 'Enregistrer les modifications' : 'Créer l\'employé'}
                </button>
            </div>
        </form>
    </div>
</div>