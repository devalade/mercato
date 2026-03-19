<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<c:set var="isEdit" value="${not empty materiel}" />
<c:set var="pageTitle" value="${isEdit ? 'Modifier Matériel' : 'Nouveau Matériel'}" />

<!-- Page Header -->
<div class="page-header animate-fade-in">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-${isEdit ? 'edit' : 'plus'} text-xl"></i>
        </div>
        <div>
            <h1>${pageTitle}</h1>
            <p class="page-header-subtitle">
                ${isEdit ? 'Modifiez les informations du matériel' : 'Ajoutez un nouveau matériel à l\'inventaire'}
            </p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
    </div>
</div>

<!-- Progress Steps (for new material) -->
<c:if test="${!isEdit}">
    <div class="mb-6 animate-fade-in" style="animation-delay: 0.05s;">
        <ul class="steps w-full">
            <li class="step step-primary">
                <i class="fas fa-info-circle mb-1"></i>
                Informations
            </li>
            <li class="step">
                <i class="fas fa-box mb-1"></i>
                Stock
            </li>
            <li class="step">
                <i class="fas fa-check-circle mb-1"></i>
                Confirmation
            </li>
        </ul>
    </div>
</c:if>

<!-- Form Card -->
<div class="card-clean max-w-4xl mx-auto animate-fade-in" style="animation-delay: 0.1s;">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/materiels/${isEdit ? 'update' : 'create'}" 
              method="post" class="space-y-6" id="materialForm">
            
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${materiel.id}" />
            </c:if>
            
            <!-- Section: Identification -->
            <div class="form-section">
                <h3 class="form-section-title">
                    <i class="fas fa-fingerprint"></i>
                    Identification
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                Référence <span class="text-error">*</span>
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                <i class="fas fa-hashtag"></i>
                            </span>
                            <input type="text" name="reference" value="${materiel.reference}" 
                                   class="input input-bordered w-full pl-10 font-mono bg-base-100" 
                                   placeholder="Ex: PC-001" required
                                   ${isEdit ? 'readonly' : ''} />
                        </div>
                        <label class="label">
                            <span class="label-text-alt">
                                <i class="fas fa-info-circle text-xs mr-1"></i>
                                Identifiant unique du matériel
                            </span>
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                Désignation <span class="text-error">*</span>
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                <i class="fas fa-tag"></i>
                            </span>
                            <input type="text" name="designation" value="${materiel.designation}" 
                                   class="input input-bordered w-full pl-10" 
                                   placeholder="Ex: PC Portable Dell Latitude" required />
                        </div>
                        <label class="label">
                            <span class="label-text-alt">Nom complet du matériel</span>
                        </label>
                    </div>
                </div>
            </div>
            
            <!-- Section: Classification -->
            <div class="form-section">
                <h3 class="form-section-title">
                    <i class="fas fa-tags"></i>
                    Classification
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                Catégorie <span class="text-error">*</span>
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                <i class="fas fa-folder"></i>
                            </span>
                            <select name="categorie" class="select select-bordered w-full pl-10 appearance-none" required>
                                <option value="">Sélectionnez une catégorie</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat}" ${materiel.categorie == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                            <span class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none text-base-content/40">
                                <i class="fas fa-chevron-down text-xs"></i>
                            </span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                <i class="far fa-calendar-alt mr-1"></i>
                                Date d'achat
                            </span>
                        </label>
                        <input type="date" name="dateAchat" 
                               value="${materiel.dateAchat != null ? materiel.dateAchat.toLocalDate() : ''}" 
                               class="input input-bordered w-full" />
                    </div>
                </div>
            </div>
            
            <!-- Section: Stock -->
            <div class="form-section">
                <h3 class="form-section-title">
                    <i class="fas fa-cubes"></i>
                    Gestion du Stock
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                Quantité <span class="text-error">*</span>
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                <i class="fas fa-hashtag"></i>
                            </span>
                            <input type="number" name="quantiteStock" 
                                   value="${materiel.quantiteStock != null ? materiel.quantiteStock : '1'}" 
                                   class="input input-bordered w-full pl-10 font-mono" 
                                   min="1" required
                                   ${isEdit ? 'readonly' : ''} />
                        </div>
                        <label class="label">
                            <span class="label-text-alt">
                                <c:choose>
                                    <c:when test="${isEdit}">
                                        La quantité ne peut être modifiée que via les mouvements de stock
                                    </c:when>
                                    <c:otherwise>
                                        Quantité initiale en stock
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">
                                Durée de vie (jours) <span class="text-error">*</span>
                            </span>
                        </label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                <i class="fas fa-hourglass-half"></i>
                            </span>
                            <input type="number" name="dureeVieJours" 
                                   value="${materiel.dureeVieJours != null ? materiel.dureeVieJours : '365'}" 
                                   class="input input-bordered w-full pl-10 font-mono" 
                                   min="1" required />
                        </div>
                        <label class="label">
                            <span class="label-text-alt">Nombre de jours avant expiration (ex: 365 = 1 an)</span>
                        </label>
                    </div>
                </div>
                
                <!-- Info Alert for Edit Mode -->
                <c:if test="${isEdit && materiel.dateExpiration != null}">
                    <div class="alert alert-info mt-4">
                        <i class="fas fa-info-circle text-xl"></i>
                        <div>
                            <p class="font-medium">Date d'expiration calculée</p>
                            <p class="text-sm">
                                <i class="far fa-calendar-alt mr-1"></i>
                                <t:formatDateTime date="${materiel.dateExpiration}" />
                                <span class="mx-2">•</span>
                                <c:set var="joursRestants" value="${materiel.getJoursRestants()}" />
                                <span class="${joursRestants < 30 ? 'text-error font-bold' : 'text-success font-medium'}">
                                    <i class="fas fa-clock mr-1"></i>
                                    ${joursRestants} jours restants
                                </span>
                            </p>
                        </div>
                    </div>
                </c:if>
            </div>
            
            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4 border-t border-base-200">
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost order-2 sm:order-1">
                    <i class="fas fa-times mr-2"></i>
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary order-1 sm:order-2 gap-2 btn-ripple" id="submitBtn">
                    <i class="fas fa-save"></i>
                    ${isEdit ? 'Enregistrer les modifications' : 'Créer le matériel'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
// Form validation and enhancement
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('materialForm');
    const submitBtn = document.getElementById('submitBtn');
    
    form.addEventListener('submit', function(e) {
        // Add loading state
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Enregistrement...';
        
        // Form will submit normally
        return true;
    });
    
    // Auto-generate reference if empty (for new materials)
    const referenceInput = form.querySelector('input[name="reference"]');
    const designationInput = form.querySelector('input[name="designation"]');
    
    if (referenceInput && !referenceInput.value) {
        designationInput.addEventListener('blur', function() {
            if (!referenceInput.value && this.value) {
                // Generate a simple reference based on designation
                const words = this.value.split(' ');
                const prefix = words[0].substring(0, 3).toUpperCase();
                const randomNum = Math.floor(Math.random() * 900) + 100;
                referenceInput.value = prefix + '-' + randomNum;
            }
        });
    }
});
</script>
