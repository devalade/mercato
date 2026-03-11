<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<c:set var="isEdit" value="${not empty materiel}" />
<c:set var="pageTitle" value="${isEdit ? 'Modifier Matériel' : 'Nouveau Matériel'}" />

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-${isEdit ? 'edit' : 'plus'} text-primary mr-3"></i>
            ${pageTitle}
        </h1>
        <p class="text-gray-600">
            ${isEdit ? 'Modifiez les informations du matériel' : 'Ajoutez un nouveau matériel à l\'inventaire'}
        </p>
    </div>
    <t:button href="${pageContext.request.contextPath}/materiels" variant="ghost" icon="fa-arrow-left">
        Retour à la liste
    </t:button>
</div>

<div class="card bg-base-100 shadow-xl max-w-4xl mx-auto">
    <div class="card-body">
        <form action="${pageContext.request.contextPath}/materiels/${isEdit ? 'update' : 'create'}" 
              method="post" class="space-y-6">
            
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${materiel.id}" />
            </c:if>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Reference -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Référence *</span>
                    </label>
                    <input type="text" name="reference" value="${materiel.reference}" 
                           class="input input-bordered w-full font-mono" 
                           placeholder="Ex: PC001" required
                           ${isEdit ? 'readonly' : ''} />
                    <label class="label">
                        <span class="label-text-alt">Identifiant unique du matériel</span>
                    </label>
                </div>
                
                <!-- Designation -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Désignation *</span>
                    </label>
                    <input type="text" name="designation" value="${materiel.designation}" 
                           class="input input-bordered w-full" 
                           placeholder="Ex: PC Portable Dell Latitude" required />
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Category -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Catégorie *</span>
                    </label>
                    <select name="categorie" class="select select-bordered w-full" required>
                        <option value="">Sélectionnez une catégorie</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat}" ${materiel.categorie == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <!-- Purchase Date -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Date d'achat</span>
                    </label>
                    <input type="date" name="dateAchat" 
                           value="${materiel.dateAchat != null ? materiel.dateAchat : ''}" 
                           class="input input-bordered w-full" />
                </div>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Quantity -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Quantité *</span>
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
                
                <!-- Lifespan -->
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Durée de vie (jours) *</span>
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
            
            <c:if test="${isEdit && materiel.dateExpiration != null}">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <span>
                        Date d'expiration calculée: 
                        <strong><fmt:formatDate value="${materiel.dateExpiration}" pattern="dd/MM/yyyy" /></strong>
                        (${materiel.getJoursRestants()} jours restants)
                    </span>
                </div>
            </c:if>
            
            <!-- Form Actions -->
            <div class="flex justify-end gap-4 pt-4 border-t">
                <a href="${pageContext.request.contextPath}/materiels" class="btn btn-ghost">
                    Annuler
                </a>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save mr-2"></i>
                    ${isEdit ? 'Enregistrer les modifications' : 'Créer le matériel'}
                </button>
            </div>
        </form>
    </div>
</div>