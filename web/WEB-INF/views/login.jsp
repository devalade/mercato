<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - Mercato Inventaire</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.10/dist/full.min.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        .login-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <div class="login-bg">
        <div class="login-card w-full max-w-md p-8">
            <div class="text-center mb-8">
                <div class="inline-flex items-center justify-center w-20 h-20 bg-primary rounded-full mb-4 shadow-lg">
                    <i class="fas fa-boxes text-4xl text-primary-content"></i>
                </div>
                <h1 class="text-3xl font-bold text-gray-800 mb-2">Mercato</h1>
                <p class="text-gray-600">Système de Gestion d'Inventaire</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error mb-6 shadow-lg">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>
            
            <form action="${contextPath}/login" method="post" class="space-y-6">
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Nom d'utilisateur</span>
                    </label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">
                            <i class="fas fa-user"></i>
                        </span>
                        <input type="text" name="username" placeholder="Entrez votre nom d'utilisateur" 
                               class="input input-bordered w-full pl-10" required autofocus />
                    </div>
                </div>
                
                <div class="form-control">
                    <label class="label">
                        <span class="label-text font-semibold">Mot de passe</span>
                    </label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">
                            <i class="fas fa-lock"></i>
                        </span>
                        <input type="password" name="password" placeholder="Entrez votre mot de passe" 
                               class="input input-bordered w-full pl-10" required />
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary w-full btn-lg shadow-lg hover:shadow-xl transition-all">
                    <i class="fas fa-sign-in-alt mr-2"></i>
                    Se connecter
                </button>
            </form>
            
            <div class="divider my-6">Informations</div>
            
            <div class="bg-base-200 rounded-lg p-4 text-sm">
                <p class="mb-2"><i class="fas fa-info-circle text-info mr-2"></i><strong>Identifiants par défaut:</strong></p>
                <p class="text-gray-600">Utilisateur: <code class="bg-base-300 px-2 py-1 rounded">gestionnaire</code></p>
                <p class="text-gray-600">Mot de passe: <code class="bg-base-300 px-2 py-1 rounded">password123</code></p>
            </div>
            
            <div class="text-center mt-6 text-xs text-gray-500">
                <p>M2 IRT AL - Jakarta EE 10</p>
                <p>&copy; 2025 Mercato</p>
            </div>
        </div>
    </div>
</body>
</html>