<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Mercato Inventaire</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="${contextPath}/css/custom.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-base-200 min-h-screen">
    <div class="drawer lg:drawer-open">
        <input id="my-drawer-2" type="checkbox" class="drawer-toggle" />
        
        <div class="drawer-content flex flex-col">
            <!-- Navbar -->
            <div class="navbar bg-base-100 shadow-lg sticky top-0 z-30">
                <div class="flex-none lg:hidden">
                    <label for="my-drawer-2" class="btn btn-square btn-ghost drawer-button">
                        <i class="fas fa-bars text-xl"></i>
                    </label>
                </div>
                <div class="flex-1">
                    <a href="${contextPath}/dashboard" class="btn btn-ghost text-xl">
                        <i class="fas fa-boxes mr-2"></i>
                        Mercato
                    </a>
                </div>
                <div class="flex-none gap-2">
                    <!-- Notification Bell -->
                    <div class="dropdown dropdown-end">
                        <button class="btn btn-ghost btn-circle">
                            <div class="indicator">
                                <i class="fas fa-bell text-xl"></i>
                                <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                    <span class="badge badge-sm badge-error indicator-item">${sessionScope.alertCount}</span>
                                </c:if>
                            </div>
                        </button>
                        <ul class="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-80 mt-4 z-50">
                            <li class="menu-title">Notifications</li>
                            <c:choose>
                                <c:when test="${empty sessionScope.notifications}">
                                    <li><a class="disabled">Aucune notification</a></li>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${sessionScope.notifications}" var="notif">
                                        <li><a href="${contextPath}/materiels/${notif.materielId}">
                                            <i class="fas fa-exclamation-triangle text-warning"></i>
                                            ${notif.message}
                                        </a></li>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="dropdown dropdown-end">
                        <button class="btn btn-ghost btn-circle avatar placeholder">
                            <div class="bg-primary text-primary-content rounded-full w-10">
                                <span class="text-lg">${sessionScope.username != null ? fn:toUpperCase(fn:substring(sessionScope.username, 0, 1)) : 'U'}</span>
                            </div>
                        </button>
                        <ul class="dropdown-content menu p-2 shadow bg-base-100 rounded-box w-52 mt-4 z-50">
                            <li class="menu-title">
                                <span class="text-sm font-bold">${sessionScope.username}</span>
                                <span class="text-xs text-gray-500">${sessionScope.role}</span>
                            </li>
                            <li><a href="${contextPath}/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                            <div class="divider my-1"></div>
                            <li><a href="${contextPath}/logout" class="text-error"><i class="fas fa-sign-out-alt"></i> Déconnexion</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Flash Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success mx-4 mt-4 shadow-lg">
                    <i class="fas fa-check-circle"></i>
                    <span>${sessionScope.successMessage}</span>
                    <button class="btn btn-sm btn-ghost" onclick="this.parentElement.remove()">×</button>
                </div>
                <% session.removeAttribute("successMessage"); %>
            </c:if>
            
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error mx-4 mt-4 shadow-lg">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${sessionScope.errorMessage}</span>
                    <button class="btn btn-sm btn-ghost" onclick="this.parentElement.remove()">×</button>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            </c:if>
            
            <!-- Main Content -->
            <main class="flex-1 p-4 lg:p-6">
                <jsp:include page="${contentPage}" />
            </main>
            
            <!-- Footer -->
            <footer class="footer footer-center p-4 bg-base-300 text-base-content mt-auto">
                <aside>
                    <p>&copy; 2025 Mercato - Système de Gestion d'Inventaire</p>
                    <p class="text-xs">M2 IRT AL - Jakarta EE 10</p>
                </aside>
            </footer>
        </div>
        
        <!-- Sidebar -->
        <div class="drawer-side z-40">
            <label for="my-drawer-2" class="drawer-overlay"></label>
            <aside class="w-72 bg-base-100 min-h-full shadow-xl">
                <div class="p-4 border-b">
                    <a href="${contextPath}/dashboard" class="btn btn-ghost text-xl w-full justify-start">
                        <i class="fas fa-boxes mr-2 text-primary"></i>
                        Mercato
                    </a>
                </div>
                
                <ul class="menu p-4 text-base-content">
                    <li class="menu-title">Principal</li>
                    <li>
                        <a href="${contextPath}/dashboard" class="${pageTitle == 'Dashboard' ? 'active' : ''}">
                            <i class="fas fa-tachometer-alt w-6"></i>
                            Dashboard
                        </a>
                    </li>
                    
                    <li class="menu-title mt-4">Inventaire</li>
                    <li>
                        <details ${pageTitle == 'Liste des Matériels' || pageTitle == 'Nouveau Matériel' || pageTitle == 'Détail Matériel' ? 'open' : ''}>
                            <summary>
                                <i class="fas fa-box w-6"></i>
                                Matériels
                            </summary>
                            <ul>
                                <li><a href="${contextPath}/materiels" class="${pageTitle == 'Liste des Matériels' ? 'active' : ''}">
                                    <i class="fas fa-list w-4"></i>Liste
                                </a></li>
                                <li><a href="${contextPath}/materiels/new" class="${pageTitle == 'Nouveau Matériel' ? 'active' : ''}">
                                    <i class="fas fa-plus w-4"></i>Nouveau
                                </a></li>
                            </ul>
                        </details>
                    </li>
                    <li>
                        <a href="${contextPath}/materiels/alertes" class="${pageTitle == 'Alertes' ? 'active' : ''}">
                            <i class="fas fa-exclamation-triangle w-6"></i>
                            Alertes
                            <c:if test="${not empty sessionScope.alertCount and sessionScope.alertCount > 0}">
                                <span class="badge badge-error badge-sm">${sessionScope.alertCount}</span>
                            </c:if>
                        </a>
                    </li>
                    
                    <li class="menu-title mt-4">Personnel</li>
                    <li>
                        <details ${pageTitle == 'Liste des Employés' || pageTitle == 'Nouvel Employé' ? 'open' : ''}>
                            <summary>
                                <i class="fas fa-users w-6"></i>
                                Employés
                            </summary>
                            <ul>
                                <li><a href="${contextPath}/employes" class="${pageTitle == 'Liste des Employés' ? 'active' : ''}">
                                    <i class="fas fa-list w-4"></i>Liste
                                </a></li>
                                <li><a href="${contextPath}/employes/new" class="${pageTitle == 'Nouvel Employé' ? 'active' : ''}">
                                    <i class="fas fa-plus w-4"></i>Nouveau
                                </a></li>
                            </ul>
                        </details>
                    </li>
                    
                    <li class="menu-title mt-4">Système</li>
                    <li>
                        <a href="${contextPath}/logout" class="text-error hover:bg-error hover:text-error-content">
                            <i class="fas fa-sign-out-alt w-6"></i>
                            Déconnexion
                        </a>
                    </li>
                </ul>
                
                <div class="p-4 mt-auto">
                    <div class="bg-base-200 rounded-lg p-3">
                        <p class="text-xs text-gray-500 mb-1">Connecté en tant que</p>
                        <p class="font-bold text-sm">${sessionScope.username}</p>
                        <span class="badge badge-primary badge-sm mt-1">${sessionScope.role}</span>
                    </div>
                </div>
            </aside>
        </div>
    </div>
    
    <script src="${contextPath}/js/main.js"></script>
</body>
</html>