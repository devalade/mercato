<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<div class="page-header">
    <div>
        <h1 class="text-3xl font-bold mb-2">
            <i class="fas fa-user-plus text-info mr-3"></i>
            Affectation à un Employé
        </h1>
        <p class="text-gray-600">Assigner du matériel à un employé</p>
    </div>
    <t:button href="${pageContext.request.contextPath}/materiels/${materiel.id}" variant="ghost" icon="fa-arrow-left">
        Retour
    </t:button>
</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
    <!-- Material Info -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title text-xl mb-4">
                <i class="fas fa-box text-primary mr-2"></i>
                Matériel à affecter
            </h2>
            
            <div class="bg-base-200 p-4 rounded-lg mb-4">
                <p class="text-sm text-gray-500 mb-1">Référence</p>
                <p class="font-mono font-semibold">${materiel.reference}</p>
            </div>
            
            <div class="bg-base-200 p-4 rounded-lg mb-4">
                <p class="text-sm text-gray-500 mb-1">Désignation</p>
                <p class="font-semibold">${materiel.designation}</p>
            </div>
            
            <div class="grid grid-cols-2 gap-4">
                <div class="bg-base-200 p-4 rounded-lg">
                    <p class="text-sm text-gray-500 mb-1">Catégorie</p>
                    <p class="font-semibold">${materiel.categorie}</p>
                </div>
                <div class="bg-base-200 p-4 rounded-lg">
                    <p class="text-sm text-gray-500 mb-1">Stock disponible</p>
                    <p class="font-bold text-2xl text-success">${materiel.quantiteStock}</p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Affectation Form -->
    <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
            <h2 class="card-title text-xl mb-4">
                <i class="fas fa-user text-info mr-2"></i>
                Détails de l'affectation
            </h2>
            
            <form action="${pageContext.request.contextPath}/materiels/${materiel.id}/affectation" 
                  method="post" class="space-y-6" id="affectationForm">
                
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Employé *</span>
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
                            <a href="${pageContext.request.contextPath}/employes/new" class="link link-primary">
                                <i class="fas fa-plus mr-1"></i>Ajouter un nouvel employé
                            </a>
                        </span>
                    </label>
                </div>
                
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Quantité à affecter *</span>
                    </label>
                    <input type="number" name="quantite" id="quantite" 
                           class="input input-bordered w-full" 
                           min="1" max="${materiel.quantiteStock}" required
                           placeholder="Ex: 1" />
                    <label class="label">
                        <span class="label-text-alt">Maximum disponible: ${materiel.quantiteStock}</span>
                    </label>
                    <p id="quantiteError" class="text-error text-sm hidden"></p>
                </div>
                
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Commentaire</span>
                    </label>
                    <textarea name="commentaire" class="textarea textarea-bordered w-full" 
                              rows="3" placeholder="Commentaire optionnel..."></textarea>
                </div>
                
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <span>Le matériel sera marqué comme "Affecté" et déduit du stock</span>
                </div>
                
                <div class="flex justify-end gap-4 pt-4 border-t">
                    <a href="${pageContext.request.contextPath}/materiels/${materiel.id}" class="btn btn-ghost">
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-info" id="submitBtn">
                        <i class="fas fa-user-plus mr-2"></i>
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