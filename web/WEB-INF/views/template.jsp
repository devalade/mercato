<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Mercato</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${contextPath}/css/custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
        }
        
        html { scroll-behavior: smooth; }
        
        ::-webkit-scrollbar { 
            width: 8px; 
            height: 8px; 
        }
        ::-webkit-scrollbar-track { 
            background: transparent; 
        }
        ::-webkit-scrollbar-thumb { 
            background: #cbd5e1; 
            border-radius: 4px; 
        }
        ::-webkit-scrollbar-thumb:hover { 
            background: #94a3b8; 
        }
        
        /* Smooth page transitions */
        .page-transition {
            animation: pageFadeIn 0.3s ease-out;
        }
        
        @keyframes pageFadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Sidebar active indicator */
        .menu li a.active {
            background: rgba(99, 102, 241, 0.1);
            color: #4f46e5;
            font-weight: 600;
            position: relative;
        }
        
        .menu li a.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 3px;
            height: 60%;
            background: #6366f1;
            border-radius: 0 2px 2px 0;
        }
        
        /* Notification badge pulse */
        .notification-badge {
            animation: badgePulse 2s ease-in-out infinite;
        }
        
        @keyframes badgePulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        /* Toast notifications */
        .toast-container {
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 100;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .toast {
            animation: toastSlideIn 0.3s ease-out;
        }
        
        @keyframes toastSlideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Keyboard shortcut hints */
        .kbd-shortcut {
            font-family: monospace;
            font-size: 0.75rem;
            padding: 2px 6px;
            background: rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            margin-left: auto;
            opacity: 0.6;
        }
        
        /* Hover reveal for shortcuts */
        .menu li a:hover .kbd-shortcut {
            opacity: 1;
        }
    </style>
</head>
<body class="bg-base-200 min-h-screen">
    <div class="drawer lg:drawer-open">
        <input id="sidebar-toggle" type="checkbox" class="drawer-toggle" />
        
        <div class="drawer-content flex flex-col min-h-screen">
            <!-- Navbar -->
            <div class="navbar bg-base-100 shadow-sm border-b border-base-300 sticky top-0 z-30 px-4 lg:px-6">
                <div class="navbar-start gap-4">
                    <label for="sidebar-toggle" class="btn btn-square btn-ghost lg:hidden">
                        <i class="fas fa-bars text-lg"></i>
                    </label>
                    <div class="hidden lg:flex text-sm breadcrumbs">
                        <ul>
                            <li>
                                <a href="${contextPath}/dashboard" class="hover:text-primary transition-colors">
                                    <i class="fas fa-home mr-1"></i>Accueil
                                </a>
                            </li>
                            <li class="font-medium text-primary">${pageTitle}</li>
                        </ul>
                    </div>
                </div>
                
                <div class="navbar-center lg:hidden">
                    <a href="${contextPath}/dashboard" class="btn btn-ghost gap-2">
                        <i class="fas fa-boxes text-primary text-xl"></i>
                        <span class="font-bold text-lg">Mercato</span>
                    </a>
                </div>
                
                <div class="navbar-end gap-2">
                    <!-- Search Button (Quick Access) -->
                    <button class="btn btn-ghost btn-circle hidden md:flex" onclick="document.getElementById('searchModal').showModal()" title="Rechercher (Ctrl+K)">
                        <i class="fas fa-search text-lg"></i>
                    </button>
                    
                    <!-- Notifications -->
                    <div class="dropdown dropdown-end">
                        <button tabindex="0" class="btn btn-ghost btn-circle relative">
                            <div class="indicator">
                                <i class="fas fa-bell text-lg"></i>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-xs badge-error indicator-item notification-badge">${sessionScope.alertCount}</span>
                                </c:if>
                            </div>
                        </button>
                        <div tabindex="0" class="dropdown-content z-50 menu p-2 shadow-xl bg-base-100 rounded-box w-80 mt-4 border border-base-300">
                            <div class="px-3 py-2 border-b border-base-200 flex justify-between items-center">
                                <span class="font-semibold text-sm">Notifications</span>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-error badge-xs">${sessionScope.alertCount}</span>
                                </c:if>
                            </div>
                            <c:choose>
                                <c:when test="${empty sessionScope.notifications}">
                                    <div class="px-3 py-8 text-sm text-base-content/60 text-center">
                                        <div class="w-12 h-12 bg-base-200 rounded-full flex items-center justify-center mx-auto mb-3">
                                            <i class="fas fa-inbox text-xl"></i>
                                        </div>
                                        Aucune notification
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="max-h-64 overflow-y-auto">
                                        <c:forEach items="${sessionScope.notifications}" var="notif" varStatus="status">
                                            <c:if test="${status.index < 5}">
                                                <li>
                                                    <a href="${contextPath}/materiels/${notif.materielId}" class="flex items-start gap-3 py-3 hover:bg-base-200 transition-colors">
                                                        <div class="w-8 h-8 rounded-full bg-warning/10 flex items-center justify-center flex-shrink-0">
                                                            <i class="fas fa-exclamation-triangle text-warning text-sm"></i>
                                                        </div>
                                                        <span class="line-clamp-2 text-sm">${notif.message}</span>
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <c:if test="${sessionScope.notifications.size() > 5}">
                                        <div class="px-3 py-2 border-t border-base-200 text-center">
                                            <a href="${contextPath}/materiels/alertes" class="text-sm text-primary hover:underline">
                                                Voir toutes les notifications
                                            </a>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="dropdown dropdown-end">
                        <button tabindex="0" class="btn btn-ghost btn-circle avatar hover:bg-base-200 transition-colors">
                            <div class="w-9 h-9 rounded-full bg-primary text-white flex items-center justify-center font-bold text-sm shadow-md">
                                ${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}
                            </div>
                        </button>
                        <ul tabindex="0" class="dropdown-content z-50 menu p-2 shadow-xl bg-base-100 rounded-box w-56 mt-4 border border-base-300">
                            <li class="menu-title px-3 py-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold">
                                        ${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}
                                    </div>
                                    <div>
                                        <div class="font-semibold text-sm">${sessionScope.username}</div>
                                        <div class="text-xs text-base-content/60">${sessionScope.role}</div>
                                    </div>
                                </div>
                            </li>
                            <li class="divider my-1"></li>
                            <li>
                                <a href="${contextPath}/dashboard" class="flex items-center gap-2">
                                    <i class="fas fa-tachometer-alt w-5 text-primary"></i>
                                    Dashboard
                                    <span class="kbd-shortcut">D</span>
                                </a>
                            </li>
                            <li>
                                <a href="${contextPath}/materiels" class="flex items-center gap-2">
                                    <i class="fas fa-box w-5 text-success"></i>
                                    Matériels
                                    <span class="kbd-shortcut">M</span>
                                </a>
                            </li>
                            <li>
                                <a href="${contextPath}/employes" class="flex items-center gap-2">
                                    <i class="fas fa-users w-5 text-info"></i>
                                    Employés
                                    <span class="kbd-shortcut">E</span>
                                </a>
                            </li>
                            <li class="divider my-1"></li>
                            <li>
                                <a href="${contextPath}/logout" class="text-error flex items-center gap-2">
                                    <i class="fas fa-sign-out-alt w-5"></i>
                                    Déconnexion
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Flash Messages -->
            <div class="px-4 lg:px-6 pt-4 space-y-2">
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success py-2 px-4 shadow-sm animate-fade-in">
                        <i class="fas fa-check-circle text-lg"></i>
                        <span class="text-sm">${sessionScope.successMessage}</span>
                        <button class="btn btn-ghost btn-xs btn-circle ml-auto" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error py-2 px-4 shadow-sm animate-fade-in">
                        <i class="fas fa-exclamation-circle text-lg"></i>
                        <span class="text-sm">${sessionScope.errorMessage}</span>
                        <button class="btn btn-ghost btn-xs btn-circle ml-auto" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>
            </div>
            
            <!-- Main Content -->
            <main class="flex-1 p-4 lg:p-6 page-transition">
                <jsp:include page="${contentPage}" />
            </main>
            
            <!-- Footer -->
            <footer class="footer footer-center p-4 bg-base-100 border-t border-base-300 text-base-content/60 text-sm mt-auto">
                <aside>
                    <p class="flex items-center gap-2">
                        <i class="fas fa-boxes text-primary"></i>
                        <span>&copy; 2026 Mercato - Système de Gestion d'Inventaire</span>
                    </p>
                    <p class="text-xs mt-1">M2 IRT AL - Jakarta EE 10</p>
                </aside>
            </footer>
        </div>
        
        <!-- Sidebar -->
        <div class="drawer-side z-40">
            <label for="sidebar-toggle" class="drawer-overlay"></label>
            <aside class="w-72 bg-base-100 min-h-full border-r border-base-300 flex flex-col">
                <!-- Brand -->
                <div class="flex items-center gap-3 px-6 py-5 border-b border-base-300">
                    <div class="w-12 h-12 rounded-xl bg-primary flex items-center justify-center text-white text-xl shadow-lg">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <div>
                        <h1 class="font-bold text-xl tracking-tight">Mercato</h1>
                        <p class="text-xs text-base-content/50">Gestion d'Inventaire</p>
                    </div>
                </div>
                
                <!-- Navigation -->
                <nav class="flex-1 overflow-y-auto p-4">
                    <ul class="menu menu-sm gap-1">
                        <!-- Dashboard -->
                        <li>
                            <a href="${contextPath}/dashboard" class="${pageTitle == 'Dashboard' ? 'active' : ''} rounded-lg flex items-center gap-3">
                                <i class="fas fa-tachometer-alt w-5 text-center"></i>
                                <span>Dashboard</span>
                                <span class="kbd-shortcut">D</span>
                            </a>
                        </li>
                        
                        <li class="menu-title text-xs uppercase tracking-wider text-base-content/50 mt-4 mb-2">Inventaire</li>
                        
                        <!-- Materials -->
                        <li>
                            <details ${pageTitle == 'Liste des Matériels' || pageTitle == 'Nouveau Matériel' || pageTitle == 'Détail Matériel' || pageTitle == 'Alertes' ? 'open' : ''}>
                                <summary class="rounded-lg flex items-center gap-3">
                                    <i class="fas fa-box w-5 text-center"></i>
                                    <span>Matériels</span>
                                </summary>
                                <ul class="ml-4 mt-1">
                                    <li>
                                        <a href="${contextPath}/materiels" class="${pageTitle == 'Liste des Matériels' ? 'active' : ''} rounded-lg flex items-center gap-2">
                                            <i class="fas fa-list w-4 text-center text-xs"></i>
                                            Liste
                                            <span class="kbd-shortcut">M</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${contextPath}/materiels/new" class="${pageTitle == 'Nouveau Matériel' ? 'active' : ''} rounded-lg flex items-center gap-2">
                                            <i class="fas fa-plus w-4 text-center text-xs"></i>
                                            Nouveau
                                        </a>
                                    </li>
                                </ul>
                            </details>
                        </li>
                        
                        <!-- Alerts -->
                        <li>
                            <a href="${contextPath}/materiels/alertes" class="${pageTitle == 'Alertes' ? 'active' : ''} rounded-lg justify-between flex items-center">
                                <div class="flex items-center gap-3">
                                    <i class="fas fa-bell w-5 text-center"></i>
                                    <span>Alertes</span>
                                </div>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-error badge-sm notification-badge">${sessionScope.alertCount}</span>
                                </c:if>
                            </a>
                        </li>
                        
                        <li class="menu-title text-xs uppercase tracking-wider text-base-content/50 mt-4 mb-2">Personnel</li>
                        
                        <!-- Employees -->
                        <li>
                            <details ${pageTitle == 'Liste des Employés' || pageTitle == 'Nouvel Employé' || pageTitle == 'Détail Employé' ? 'open' : ''}>
                                <summary class="rounded-lg flex items-center gap-3">
                                    <i class="fas fa-users w-5 text-center"></i>
                                    <span>Employés</span>
                                </summary>
                                <ul class="ml-4 mt-1">
                                    <li>
                                        <a href="${contextPath}/employes" class="${pageTitle == 'Liste des Employés' ? 'active' : ''} rounded-lg flex items-center gap-2">
                                            <i class="fas fa-list w-4 text-center text-xs"></i>
                                            Liste
                                            <span class="kbd-shortcut">E</span>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${contextPath}/employes/new" class="${pageTitle == 'Nouvel Employé' ? 'active' : ''} rounded-lg flex items-center gap-2">
                                            <i class="fas fa-plus w-4 text-center text-xs"></i>
                                            Nouveau
                                        </a>
                                    </li>
                                </ul>
                            </details>
                        </li>
                    </ul>
                </nav>
                
                <!-- Sidebar Footer -->
                <div class="p-4 border-t border-base-300">
                    <div class="flex items-center gap-3 p-3 bg-base-200 rounded-xl border border-base-200">
                        <div class="avatar">
                            <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold shadow-md">
                                ${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}
                            </div>
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="font-medium text-sm truncate">${sessionScope.username}</p>
                            <span class="badge badge-primary badge-sm">${sessionScope.role}</span>
                        </div>
                        <a href="${contextPath}/logout" class="btn btn-ghost btn-circle btn-sm text-error hover:bg-error/10 transition-colors" title="Déconnexion">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>
                    </div>
                </div>
            </aside>
        </div>
    </div>
    
    <!-- Search Modal -->
    <dialog id="searchModal" class="modal">
        <div class="modal-box max-w-2xl">
            <h3 class="font-bold text-lg mb-4 flex items-center gap-2">
                <i class="fas fa-search text-primary"></i>
                Rechercher
            </h3>
            <div class="form-control">
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center text-base-content/40">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" 
                           placeholder="Rechercher des matériels, employés..." 
                           class="input input-bordered w-full pl-12 text-lg"
                           id="globalSearch"
                           autocomplete="off" />
                    <span class="absolute inset-y-0 right-0 pr-4 flex items-center text-base-content/40 text-sm">
                        <kbd class="kbd kbd-sm">ESC</kbd>
                    </span>
                </div>
            </div>
            <div class="mt-4">
                <p class="text-sm text-base-content/60 mb-2">Suggestions rapides:</p>
                <div class="flex flex-wrap gap-2">
                    <a href="${contextPath}/materiels" class="badge badge-outline cursor-pointer hover:bg-primary hover:text-white transition-colors">
                        <i class="fas fa-box mr-1"></i> Matériels
                    </a>
                    <a href="${contextPath}/employes" class="badge badge-outline cursor-pointer hover:bg-info hover:text-white transition-colors">
                        <i class="fas fa-users mr-1"></i> Employés
                    </a>
                    <a href="${contextPath}/materiels/alertes" class="badge badge-outline cursor-pointer hover:bg-warning hover:text-white transition-colors">
                        <i class="fas fa-bell mr-1"></i> Alertes
                    </a>
                </div>
            </div>
        </div>
        <form method="dialog" class="modal-backdrop">
            <button>close</button>
        </form>
    </dialog>
    
    <script src="${contextPath}/js/main.js"></script>
    <script>
        // SSE Notifications
        (function() {
            const EventSource = window.EventSource;
            if (!EventSource) {
                console.log('SSE not supported by browser');
                return;
            }
            
            let reconnectAttempts = 0;
            const maxReconnectAttempts = 5;
            let eventSource = null;
            
            function connectSSE() {
                if (eventSource) {
                    eventSource.close();
                }
                
                eventSource = new EventSource('${contextPath}/api/sse/alertes');
                
                eventSource.onopen = function() {
                    console.log('SSE connection established');
                    reconnectAttempts = 0;
                };
                
                eventSource.addEventListener('init', function(e) {
                    console.log('SSE init received');
                    updateNotifications(JSON.parse(e.data));
                });
                
                eventSource.addEventListener('alertes', function(e) {
                    console.log('SSE alertes update received');
                    updateNotifications(JSON.parse(e.data));
                    showToastNotification();
                });
                
                eventSource.onerror = function(e) {
                    console.log('SSE connection error');
                    eventSource.close();
                    
                    if (reconnectAttempts < maxReconnectAttempts) {
                        reconnectAttempts++;
                        const delay = Math.min(1000* Math.pow(2, reconnectAttempts), 30000);
                        console.log('SSE reconnecting in ' + delay + 'ms (attempt ' + reconnectAttempts + ')');
                        setTimeout(connectSSE, delay);
                    }
                };
            }
            
            function updateNotifications(alertes) {
                // Update session storage for notification count
                if (alertes && alertes.length > 0) {
                    sessionStorage.setItem('alertCount', alertes.length);
                    sessionStorage.setItem('notifications', JSON.stringify(alertes));
                    updateNotificationBadge(alertes.length);
                } else {
                    sessionStorage.removeItem('alertCount');
                    sessionStorage.removeItem('notifications');
                    updateNotificationBadge(0);
                }
            }
            
            function updateNotificationBadge(count) {
                const badges = document.querySelectorAll('.notification-badge');
                badges.forEach(function(badge) {
                    if (count > 0) {
                        badge.textContent = count;
                        badge.style.display = 'inline-flex';
                    } else {
                        badge.style.display = 'none';
                    }
                });
            }
            
            function showToastNotification() {
                const count = sessionStorage.getItem('alertCount') || '0';
                if (parseInt(count) > 0) {
                    const container = document.querySelector('.toast-container') || createToastContainer();
                    const toast = document.createElement('div');
                    toast.className = 'toast toast-end';
                    toast.innerHTML = 
                        '<div class="alert alert-warning shadow-lg animate-pulse">' +
                            '<i class="fas fa-exclamation-triangle"></i>' +
                            '<span>' + count + ' matériel(s) expire(nt) bientôt!</span>' +
                            '<a href="${contextPath}/materiels/alertes" class="btn btn-xs btn-ghost">Voir</a>' +
                        '</div>';
                    container.appendChild(toast);
                    
                    setTimeout(function() {
                        toast.remove();
                    }, 5000);
                }
            }
            
            function createToastContainer() {
                const container = document.createElement('div');
                container.className = 'toast-container';
                document.body.appendChild(container);
                return container;
            }
            
            // Initial connection
            connectSSE();
            
            // Restore from session on page load
            const savedAlerts = sessionStorage.getItem('notifications');
            if (savedAlerts) {
                try {
                    updateNotifications(JSON.parse(savedAlerts));
                } catch (e) {
                    console.error('Error parsing saved notifications:', e);
                }
            }
        })();
        
        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + K for search
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                document.getElementById('searchModal').showModal();
                document.getElementById('globalSearch').focus();
            }
            
            // Navigation shortcuts (when not in input)
            if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                switch(e.key.toLowerCase()) {
                    case 'd':
                        window.location.href = '${contextPath}/dashboard';
                        break;
                    case 'm':
                        window.location.href = '${contextPath}/materiels';
                        break;
                    case 'e':
                        window.location.href = '${contextPath}/employes';
                        break;
                }
            }
            
            // ESC to close modal
            if (e.key === 'Escape') {
                const modal = document.getElementById('searchModal');
                if (modal.open) {
                    modal.close();
                }
            }
        });
        
        // Auto-hide flash messages after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.5s ease';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    </script>
</body>
</html>
