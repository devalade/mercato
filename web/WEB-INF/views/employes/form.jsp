<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<c:set var="isEdit" value="${not empty employe}" />
<c:set var="pageTitle" value="${isEdit ? 'Modifier Employé' : 'Nouvel Employé'}" />

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-${isEdit ? 'edit' : 'user-plus'} text-xl"></i>
        </div>
        <div>
            <h1>${pageTitle}</h1>
            <p class="page-header-subtitle">
                ${isEdit ? 'Modifiez les informations de l\'employé' : 'Ajoutez un nouvel employé'}
            </p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/employes" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
    </div>
</div>

<!-- Form Card -->
<div class="card-clean max-w-2xl mx-auto">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/employes/${isEdit ? 'update' : 'create'}" 
              method="post" class="space-y-6">
            
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${employe.id}" />
            </c:if>
            
            <!-- Section: Identification -->
            <div>
                <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide mb-4">
                    <i class="fas fa-fingerprint mr-1"></i>Identification
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Matricule <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="matricule" value="${employe.matricule}" 
                               class="input input-bordered w-full font-mono bg-base-200" 
                               placeholder="Ex: EMP-001" required
                               ${isEdit ? 'readonly' : ''} />
                        <label class="label">
                            <span class="label-text-alt">Identifiant unique de l'employé</span>
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Service <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="service" value="${employe.service}" 
                               class="input input-bordered w-full" 
                               placeholder="Ex: Informatique" required />
                    </div>
                </div>
            </div>
            
            <div class="divider"></div>
            
            <!-- Section: Informations Personnelles -->
            <div>
                <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide mb-4">
                    <i class="fas fa-user mr-1"></i>Informations Personnelles
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Nom <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="nom" value="${employe.nom}" 
                               class="input input-bordered w-full" 
                               placeholder="Ex: Dupont" required />
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Prénom <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="prenom" value="${employe.prenom}" 
                               class="input input-bordered w-full" 
                               placeholder="Ex: Jean" required />
                    </div>
                </div>
            </div>
            
            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4 border-t border-base-200">
                <a href="${pageContext.request.contextPath}/employes" class="btn btn-ghost order-2 sm:order-1">
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary order-1 sm:order-2 gap-2">
                    <i class="fas fa-save"></i>
                    ${isEdit ? 'Enregistrer les modifications' : 'Créer l\'employé'}
                </button>
            </div>
        </form>
    </div>
</div>
