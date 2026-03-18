<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<c:set var="isEdit" value="${not empty materiel}" />
<c:set var="pageTitle" value="${isEdit ? 'Modifier Matériel' : 'Nouveau Matériel'}" />

<!-- Page Header -->
<div class="page-header">
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

<!-- Form Card -->
<div class="card-clean max-w-4xl mx-auto">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/materiels/${isEdit ? 'update' : 'create'}" 
              method="post" class="space-y-6">
            
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${materiel.id}" />
            </c:if>
            
            <!-- Section: Identification -->
            <div>
                <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide mb-4">
                    <i class="fas fa-fingerprint mr-1"></i>Identification
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Référence <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="reference" value="${materiel.reference}" 
                               class="input input-bordered w-full font-mono bg-base-200" 
                               placeholder="Ex: PC-001" required
                               ${isEdit ? 'readonly' : ''} />
                        <label class="label">
                            <span class="label-text-alt">Identifiant unique du matériel</span>
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Désignation <span class="text-error">*</span></span>
                        </label>
                        <input type="text" name="designation" value="${materiel.designation}" 
                               class="input input-bordered w-full" 
                               placeholder="Ex: PC Portable Dell Latitude" required />
                    </div>
                </div>
            </div>
            
            <div class="divider"></div>
            
            <!-- Section: Classification -->
            <div>
                <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide mb-4">
                    <i class="fas fa-tags mr-1"></i>Classification
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Catégorie <span class="text-error">*</span></span>
                        </label>
                        <select name="categorie" class="select select-bordered w-full" required>
                            <option value="">Sélectionnez une catégorie</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat}" ${materiel.categorie == cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Date d'achat</span>
                        </label>
                        <input type="date" name="dateAchat" 
                               value="${materiel.dateAchat != null ? materiel.dateAchat.toLocalDate() : ''}" 
                               class="input input-bordered w-full" />
                    </div>
                </div>
            </div>
            
            <div class="divider"></div>
            
            <!-- Section: Stock -->
            <div>
                <h3 class="text-sm font-semibold text-base-content/60 uppercase tracking-wide mb-4">
                    <i class="fas fa-cubes mr-1"></i>Gestion du Stock
                </h3>
                <div class="form-grid-2">
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Quantité <span class="text-error">*</span></span>
                        </label>
                        <input type="number" name="quantiteStock" 
                               value="${materiel.quantiteStock != null ? materiel.quantiteStock : '1'}" 
                               class="input input-bordered w-full" 
                               min="1" required
                               ${isEdit ? 'readonly' : ''} />
                        <label class="label">
                            <span class="label-text-alt">Quantité initiale en stock</span>
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="label">
                            <span class="label-text">Durée de vie (jours) <span class="text-error">*</span></span>
                        </label>
                        <input type="number" name="dureeVieJours" 
                               value="${materiel.dureeVieJours != null ? materiel.dureeVieJours : '365'}" 
                               class="input input-bordered w-full" 
                               min="1" required />
                        <label class="label">
                            <span class="label-text-alt">Nombre de jours avant expiration</span>
                        </label>
                    </div>
                </div>
            </div>
            
            <!-- Info Alert for Edit Mode -->
            <c:if test="${isEdit && materiel.dateExpiration != null}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <p class="font-medium">Date d'expiration calculée</p>
                        <p class="text-sm">
                            <t:formatDateTime date="${materiel.dateExpiration}" />
                            <span class="mx-2">•</span>
                            <span class="${materiel.getJoursRestants() < 30 ? 'text-error font-medium' : ''}">
                                ${materiel.getJoursRestants()} jours restants
                            </span>
                        </p>
                    </div>
                </div>
            </c:if>
            
            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4 border-t border-base-200">
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost order-2 sm:order-1">
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary order-1 sm:order-2 gap-2">
                    <i class="fas fa-save"></i>
                    ${isEdit ? 'Enregistrer les modifications' : 'Créer le matériel'}
                </button>
            </div>
        </form>
    </div>
</div>
