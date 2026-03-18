<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-user-plus text-info text-xl"></i>
        </div>
        <div>
            <h1>Affectation à un Employé</h1>
            <p class="page-header-subtitle">Assigner du matériel à un employé</p>
        </div>
    </div>
    <div class="page-header-actions">
        <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" class="btn btn-ghost btn-sm gap-2">
            <i class="fas fa-arrow-left"></i>
            Retour
        </a>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Material Info -->
    <div class="card-clean">
        <div class="card-body">
            <h2 class="card-title flex items-center gap-2">
                <i class="fas fa-box text-primary"></i>
                Matériel à affecter
            </h2>
            
            <div class="mt-4 space-y-3">
                <div class="bg-base-200 p-4 rounded-lg">
                    <p class="text-sm text-base-content/60 mb-1">Référence</p>
                    <p class="font-mono font-semibold">${materiel.reference}</p>
                </div>
                
                <div class="bg-base-200 p-4 rounded-lg">
                    <p class="text-sm text-base-content/60 mb-1">Désignation</p>
                    <p class="font-semibold">${materiel.designation}</p>
                </div>
                
                <div class="grid grid-cols-2 gap-3">
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-base-content/60 mb-1">Catégorie</p>
                        <p class="font-semibold">${materiel.categorie}</p>
                    </div>
                    <div class="bg-base-200 p-4 rounded-lg">
                        <p class="text-sm text-base-content/60 mb-1">Stock disponible</p>
                        <p class="font-bold text-2xl text-success">${materiel.quantiteStock}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Affectation Form -->
    <div class="card-clean">
        <div class="card-body">
            <h2 class="card-title flex items-center gap-2">
                <i class="fas fa-user text-info"></i>
                Détails de l'affectation
            </h2>
            
            <form action="${pageContext.request.contextPath}/materiels/${materiel.id}/affectation" 
                  method="post" class="space-y-5 mt-4" id="affectationForm">
                
                <div class="form-group">
                    <label class="label">
                        <span class="label-text">Employé <span class="text-error">*</span></span>
                    </label>
                    <select name="employeId" class="select select-bordered w-full" required>
                        <option value="">Sélectionnez un employé</option>
                        <c:forEach items="${employes}" var="employe">
                            <option value="${employe.id}">
                                ${employe.prenom} ${employe.nom} - ${employe.matricule}
                            </option>
                        </c:forEach>
                    </select>
                    <label class="label">
                        <span class="label-text-alt">
                            <a href="${pageContext.request.contextPath}/employes/new" class="link link-primary text-xs">
                                <i class="fas fa-plus mr-1"></i>Ajouter un nouvel employé
                            </a>
                        </span>
                    </label>
                </div>
                
                <div class="form-group">
                    <label class="label">
                        <span class="label-text">Quantité à affecter <span class="text-error">*</span></span>
                    </label>
                    <input type="number" name="quantite" id="quantite" 
                           class="input input-bordered w-full" 
                           min="1" max="${materiel.quantiteStock}" required
                           placeholder="Ex: 1" />
                    <label class="label">
                        <span class="label-text-alt">Maximum disponible: ${materiel.quantiteStock}</span>
                    </label>
                    <p id="quantiteError" class="text-error text-sm hidden mt-1"></p>
                </div>
                
                <div class="form-group">
                    <label class="label">
                        <span class="label-text">Commentaire</span>
                    </label>
                    <textarea name="commentaire" class="textarea textarea-bordered w-full" 
                              rows="3" placeholder="Commentaire optionnel..."></textarea>
                </div>
                
                <div class="alert alert-info alert-compact">
                    <i class="fas fa-info-circle"></i>
                    <span class="text-sm">Le matériel sera marqué comme "Affecté" et déduit du stock</span>
                </div>
                
                <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4 border-t border-base-200">
                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" class="btn btn-ghost order-2 sm:order-1">
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-info order-1 sm:order-2 gap-2" id="submitBtn">
                        <i class="fas fa-user-plus"></i>
                        Confirmer l'affectation
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById('affectationForm').addEventListener('submit', function(e) {
        const quantite = parseInt(document.getElementById('quantite').value);
        const maxStock = ${materiel.quantiteStock};
        
        if (quantite > maxStock) {
            e.preventDefault();
            const errorEl = document.getElementById('quantiteError');
            errorEl.textContent = 'La quantité ne peut pas dépasser le stock disponible (' + maxStock + ')';
            errorEl.classList.remove('hidden');
            document.getElementById('quantite').classList.add('input-error');
        } else {
            return confirm('Êtes-vous sûr de vouloir affecter ce matériel?');
        }
    });
</script>
