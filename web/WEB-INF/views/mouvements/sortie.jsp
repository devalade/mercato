<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<!-- Page Header -->
<div class="page-header">
    <div class="page-header-title">
        <div class="icon-wrapper">
            <i class="fas fa-arrow-up text-error text-xl"></i>
        </div>
        <div>
            <h1>Sortie de Stock</h1>
            <p class="page-header-subtitle">Enregistrer une sortie de matériel</p>
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
                Matériel concerné
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
    
    <!-- Sortie Form -->
    <div class="card-clean">
        <div class="card-body">
            <h2 class="card-title flex items-center gap-2">
                <i class="fas fa-edit text-info"></i>
                Détails de la sortie
            </h2>
            
            <form action="${pageContext.request.contextPath}/materiels/${materiel.id}/sortie" 
                  method="post" class="space-y-5 mt-4" id="sortieForm">
                
                <div class="form-group">
                    <label class="label">
                        <span class="label-text">Quantité à sortir <span class="text-error">*</span></span>
                    </label>
                    <input type="number" name="quantite" id="quantite" 
                           class="input input-bordered w-full" 
                           min="1" max="${materiel.quantiteStock}" required
                           placeholder="Ex: 5" />
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
                              rows="3" placeholder="Motif de la sortie..."></textarea>
                </div>
                
                <div class="alert alert-warning alert-compact">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span class="text-sm">Cette action réduira le stock disponible</span>
                </div>
                
                <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4 border-t border-base-200">
                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" class="btn btn-ghost order-2 sm:order-1">
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-error order-1 sm:order-2 gap-2" id="submitBtn">
                        <i class="fas fa-arrow-up"></i>
                        Confirmer la sortie
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    document.getElementById('sortieForm').addEventListener('submit', function(e) {
        const quantite = parseInt(document.getElementById('quantite').value);
        const maxStock = ${materiel.quantiteStock};
        
        if (quantite > maxStock) {
            e.preventDefault();
            const errorEl = document.getElementById('quantiteError');
            errorEl.textContent = 'La quantité ne peut pas dépasser le stock disponible (' + maxStock + ')';
            errorEl.classList.remove('hidden');
            document.getElementById('quantite').classList.add('input-error');
        } else {
            return confirm('Êtes-vous sûr de vouloir effectuer cette sortie de stock?');
        }
    });
</script>
