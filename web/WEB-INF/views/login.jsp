<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Mercato</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .login-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
    </style>
</head>
<body class="login-bg">
    <div class="min-h-screen flex items-center justify-center p-4">
        <div class="w-full max-w-md">
            <!-- Logo Section -->
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-white/20 backdrop-blur rounded-2xl mb-4 shadow-xl">
                    <i class="fas fa-boxes text-4xl text-white"></i>
                </div>
                <h1 class="text-3xl font-bold text-white mb-2">Mercato</h1>
                <p class="text-white/80">Système de Gestion d'Inventaire</p>
            </div>
            
            <!-- Login Card -->
            <div class="card bg-base-100 shadow-2xl">
                <div class="card-body p-8">
                    <h2 class="text-xl font-bold text-center mb-6">Connexion</h2>
                    
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error mb-6">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <!-- Login Form -->
                    <form action="${contextPath}/login" method="post" class="space-y-5">
                        <div class="form-control">
                            <label class="label">
                                <span class="label-text font-medium">Nom d'utilisateur</span>
                            </label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                    <i class="fas fa-user"></i>
                                </span>
                                <input type="text" name="username" placeholder="Entrez votre nom d'utilisateur" 
                                       class="input input-bordered w-full pl-10 focus:input-primary" required autofocus />
                            </div>
                        </div>
                        
                        <div class="form-control">
                            <label class="label">
                                <span class="label-text font-medium">Mot de passe</span>
                            </label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-base-content/40">
                                    <i class="fas fa-lock"></i>
                                </span>
                                <input type="password" name="password" placeholder="Entrez votre mot de passe" 
                                       class="input input-bordered w-full pl-10 focus:input-primary" required />
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-full btn-lg shadow-lg hover:shadow-xl transition-shadow">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Se connecter
                        </button>
                    </form>
                    
                    <div class="divider text-sm text-base-content/50">Informations</div>
                    
                    <!-- Default Credentials -->
                    <div class="bg-base-200 rounded-lg p-4 text-sm">
                        <p class="mb-2 flex items-center gap-2">
                            <i class="fas fa-info-circle text-info"></i>
                            <strong>Identifiants par défaut:</strong>
                        </p>
                        <div class="space-y-1 text-base-content/70">
                            <p>Utilisateur: <code class="bg-base-300 px-2 py-0.5 rounded text-xs">gestionnaire</code></p>
                            <p>Mot de passe: <code class="bg-base-300 px-2 py-0.5 rounded text-xs">password123</code></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            <div class="text-center mt-8 text-white/60 text-sm">
                <p>M2 IRT AL - Jakarta EE 10</p>
                <p>&copy; 2025 Mercato</p>
            </div>
        </div>
    </div>
</body>
</html>
