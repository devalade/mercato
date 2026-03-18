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
    <style>
        html { scroll-behavior: smooth; }
        ::-webkit-scrollbar { width: 8px; height: 8px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: #94a3b8; }
    </style>
</head>
<body class="bg-base-200 min-h-screen">
    <div class="drawer lg:drawer-open">
        <input id="sidebar-toggle" type="checkbox" class="drawer-toggle" />
        
        <div class="drawer-content flex flex-col min-h-screen">
            <!-- Navbar -->
            <div class="navbar bg-base-100 shadow-sm border-b border-base-300 sticky top-0 z-30 px-4">
                <div class="navbar-start">
                    <label for="sidebar-toggle" class="btn btn-square btn-ghost lg:hidden">
                        <i class="fas fa-bars text-lg"></i>
                    </label>
                    <div class="hidden lg:flex text-sm breadcrumbs">
                        <ul>
                            <li><a href="${contextPath}/dashboard"><i class="fas fa-home mr-1"></i>Accueil</a></li>
                            <li class="font-medium">${pageTitle}</li>
                        </ul>
                    </div>
                </div>
                
                <div class="navbar-center lg:hidden">
                    <a href="${contextPath}/dashboard" class="btn btn-ghost gap-2">
                        <i class="fas fa-boxes text-primary"></i>
                        <span class="font-bold">Mercato</span>
                    </a>
                </div>
                
                <div class="navbar-end gap-2">
                    <!-- Notifications -->
                    <div class="dropdown dropdown-end">
                        <button tabindex="0" class="btn btn-ghost btn-circle">
                            <div class="indicator">
                                <i class="fas fa-bell text-lg"></i>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-xs badge-error indicator-item">${sessionScope.alertCount}</span>
                                </c:if>
                            </div>
                        </button>
                        <div tabindex="0" class="dropdown-content z-50 menu p-2 shadow-xl bg-base-100 rounded-box w-80 mt-4 border border-base-300">
                            <div class="px-3 py-2 border-b border-base-200">
                                <span class="font-semibold text-sm">Notifications</span>
                            </div>
                            <c:choose>
                                <c:when test="${empty sessionScope.notifications}">
                                    <div class="px-3 py-4 text-sm text-base-content/60 text-center">
                                        <i class="fas fa-inbox text-2xl mb-2 block"></i>
                                        Aucune notification
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${sessionScope.notifications}" var="notif" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <li>
                                                <a href="${contextPath}/materiels/${notif.materielId}" class="flex items-start gap-3 py-2">
                                                    <i class="fas fa-exclamation-triangle text-warning mt-0.5"></i>
                                                    <span class="line-clamp-2 text-sm">${notif.message}</span>
                                                </a>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="dropdown dropdown-end">
                        <button tabindex="0" class="btn btn-ghost btn-circle avatar">
                            <div class="w-9 h-9 rounded-full bg-primary text-primary-content flex items-center justify-center font-bold text-sm">
                                ${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}
                            </div>
                        </button>
                        <ul tabindex="0" class="dropdown-content z-50 menu p-2 shadow-xl bg-base-100 rounded-box w-52 mt-4 border border-base-300">
                            <li class="menu-title px-3 py-2">
                                <div>
                                    <div class="font-semibold text-sm">${sessionScope.username}</div>
                                    <div class="text-xs text-base-content/60">${sessionScope.role}</div>
                                </div>
                            </li>
                            <li><a href="${contextPath}/dashboard"><i class="fas fa-tachometer-alt w-5"></i>Dashboard</a></li>
                            <div class="divider my-1"></div>
                            <li><a href="${contextPath}/logout" class="text-error"><i class="fas fa-sign-out-alt w-5"></i>Déconnexion</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Flash Messages -->
            <div class="px-4 lg:px-6 pt-4 space-y-2">
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success py-2 px-4 shadow-sm">
                        <i class="fas fa-check-circle"></i>
                        <span class="text-sm">${sessionScope.successMessage}</span>
                        <button class="btn btn-ghost btn-xs btn-circle ml-auto" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>
                
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error py-2 px-4 shadow-sm">
                        <i class="fas fa-exclamation-circle"></i>
                        <span class="text-sm">${sessionScope.errorMessage}</span>
                        <button class="btn btn-ghost btn-xs btn-circle ml-auto" onclick="this.parentElement.remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                </c:if>
            </div>
            
            <!-- Main Content -->
            <main class="flex-1 p-4 lg:p-6">
                <jsp:include page="${contentPage}" />
            </main>
            
            <!-- Footer -->
            <footer class="footer footer-center p-4 bg-base-100 border-t border-base-300 text-base-content/60 text-sm mt-auto">
                <aside>
                    <p>&copy; 2025 Mercato - Système de Gestion d'Inventaire</p>
                </aside>
            </footer>
        </div>
        
        <!-- Sidebar -->
        <div class="drawer-side z-40">
            <label for="sidebar-toggle" class="drawer-overlay"></label>
            <aside class="w-72 bg-base-100 min-h-full border-r border-base-300 flex flex-col">
                <!-- Brand -->
                <div class="flex items-center gap-3 px-6 py-5 border-b border-base-300">
                    <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-white text-xl shadow-lg">
                        <i class="fas fa-boxes"></i>
                    </div>
                    <div>
                        <h1 class="font-bold text-xl">Mercato</h1>
                        <p class="text-xs text-base-content/50">Gestion d'Inventaire</p>
                    </div>
                </div>
                
                <!-- Navigation -->
                <nav class="flex-1 overflow-y-auto p-4">
                    <ul class="menu menu-sm gap-1">
                        <!-- Dashboard -->
                        <li>
                            <a href="${contextPath}/dashboard" class="${pageTitle == 'Dashboard' ? 'active' : ''} rounded-lg">
                                <i class="fas fa-tachometer-alt w-5 text-center"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                        
                        <li class="menu-title text-xs uppercase tracking-wider text-base-content/50 mt-4 mb-2">Inventaire</li>
                        
                        <!-- Materials -->
                        <li>
                            <details ${pageTitle == 'Liste des Matériels' || pageTitle == 'Nouveau Matériel' || pageTitle == 'Détail Matériel' ? 'open' : ''}>
                                <summary class="rounded-lg">
                                    <i class="fas fa-box w-5 text-center"></i>
                                    <span>Matériels</span>
                                </summary>
                                <ul class="ml-4 mt-1">
                                    <li>
                                        <a href="${contextPath}/materiels" class="${pageTitle == 'Liste des Matériels' ? 'active' : ''} rounded-lg">
                                            <i class="fas fa-list w-4 text-center text-xs"></i>Liste
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${contextPath}/materiels/new" class="${pageTitle == 'Nouveau Matériel' ? 'active' : ''} rounded-lg">
                                            <i class="fas fa-plus w-4 text-center text-xs"></i>Nouveau
                                        </a>
                                    </li>
                                </ul>
                            </details>
                        </li>
                        
                        <!-- Alerts -->
                        <li>
                            <a href="${contextPath}/materiels/alertes" class="${pageTitle == 'Alertes' ? 'active' : ''} rounded-lg justify-between">
                                <div class="flex items-center gap-3">
                                    <i class="fas fa-bell w-5 text-center"></i>
                                    <span>Alertes</span>
                                </div>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-error badge-sm">${sessionScope.alertCount}</span>
                                </c:if>
                            </a>
                        </li>
                        
                        <li class="menu-title text-xs uppercase tracking-wider text-base-content/50 mt-4 mb-2">Personnel</li>
                        
                        <!-- Employees -->
                        <li>
                            <details ${pageTitle == 'Liste des Employés' || pageTitle == 'Nouvel Employé' || pageTitle == 'Détail Employé' ? 'open' : ''}>
                                <summary class="rounded-lg">
                                    <i class="fas fa-users w-5 text-center"></i>
                                    <span>Employés</span>
                                </summary>
                                <ul class="ml-4 mt-1">
                                    <li>
                                        <a href="${contextPath}/employes" class="${pageTitle == 'Liste des Employés' ? 'active' : ''} rounded-lg">
                                            <i class="fas fa-list w-4 text-center text-xs"></i>Liste
                                        </a>
                                    </li>
                                    <li>
                                        <a href="${contextPath}/employes/new" class="${pageTitle == 'Nouvel Employé' ? 'active' : ''} rounded-lg">
                                            <i class="fas fa-plus w-4 text-center text-xs"></i>Nouveau
                                        </a>
                                    </li>
                                </ul>
                            </details>
                        </li>
                    </ul>
                </nav>
                
                <!-- Sidebar Footer -->
                <div class="p-4 border-t border-base-300">
                    <div class="flex items-center gap-3 p-3 bg-base-200 rounded-xl">
                        <div class="avatar">
                            <div class="w-10 h-10 rounded-full bg-primary text-primary-content flex items-center justify-center font-bold">
                                ${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}
                            </div>
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="font-medium text-sm truncate">${sessionScope.username}</p>
                            <span class="badge badge-primary badge-sm">${sessionScope.role}</span>
                        </div>
                        <a href="${contextPath}/logout" class="btn btn-ghost btn-circle btn-sm text-error" title="Déconnexion">
                            <i class="fas fa-sign-out-alt"></i>
                        </a>
                    </div>
                </div>
            </aside>
        </div>
    </div>
    
    <script src="${contextPath}/js/main.js"></script>
</body>
</html>
