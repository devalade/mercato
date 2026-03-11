// Main JavaScript for Mercato Inventory System

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all tooltips
    initializeTooltips();
    
    // Initialize confirmation dialogs
    initializeConfirmations();
    
    // Initialize form validations
    initializeFormValidations();
});

// Initialize tooltips
function initializeTooltips() {
    const tooltipTriggers = document.querySelectorAll('[data-tooltip]');
    tooltipTriggers.forEach(trigger => {
        trigger.addEventListener('mouseenter', function() {
            const tooltip = document.createElement('div');
            tooltip.className = 'tooltip tooltip-open';
            tooltip.textContent = this.getAttribute('data-tooltip');
            this.appendChild(tooltip);
        });
        trigger.addEventListener('mouseleave', function() {
            const tooltip = this.querySelector('.tooltip');
            if (tooltip) {
                tooltip.remove();
            }
        });
    });
}

// Initialize confirmation dialogs for dangerous actions
function initializeConfirmations() {
    const confirmButtons = document.querySelectorAll('[data-confirm]');
    confirmButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const message = this.getAttribute('data-confirm');
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    });
}

// Initialize form validations
function initializeFormValidations() {
    const forms = document.querySelectorAll('form[data-validate]');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            let isValid = true;
            const inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
            
            inputs.forEach(input => {
                if (!input.value.trim()) {
                    isValid = false;
                    input.classList.add('input-error');
                    showFieldError(input, 'Ce champ est requis');
                } else {
                    input.classList.remove('input-error');
                    hideFieldError(input);
                }
            });
            
            // Validate number inputs with min/max
            const numberInputs = form.querySelectorAll('input[type="number"]');
            numberInputs.forEach(input => {
                const value = parseFloat(input.value);
                const min = parseFloat(input.getAttribute('min'));
                const max = parseFloat(input.getAttribute('max'));
                
                if (!isNaN(min) && value < min) {
                    isValid = false;
                    input.classList.add('input-error');
                    showFieldError(input, `La valeur minimale est ${min}`);
                }
                if (!isNaN(max) && value > max) {
                    isValid = false;
                    input.classList.add('input-error');
                    showFieldError(input, `La valeur maximale est ${max}`);
                }
            });
            
            if (!isValid) {
                e.preventDefault();
            }
        });
    });
}

// Show field error message
function showFieldError(input, message) {
    // Remove existing error
    hideFieldError(input);
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'text-error text-sm mt-1 field-error';
    errorDiv.textContent = message;
    input.parentNode.appendChild(errorDiv);
}

// Hide field error message
function hideFieldError(input) {
    const existingError = input.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
}

// Auto-dismiss flash messages after 5 seconds
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        alert.style.opacity = '0';
        alert.style.transition = 'opacity 0.5s ease';
        setTimeout(() => alert.remove(), 500);
    });
}, 5000);

// Format date to local string
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

// Calculate days between two dates
function daysBetween(date1, date2) {
    const oneDay = 24 * 60 * 60 * 1000;
    const firstDate = new Date(date1);
    const secondDate = new Date(date2);
    return Math.round(Math.abs((firstDate - secondDate) / oneDay));
}

// Export functions for use in other scripts
window.Mercato = {
    formatDate,
    daysBetween,
    showFieldError,
    hideFieldError
};