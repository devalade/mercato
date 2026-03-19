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
            background-color: #6366f1;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }
        
        /* Simple decorative shapes - solid colors */
        .shape {
            position: absolute;
            opacity: 0.1;
        }
        
        .shape-1 {
            width: 300px;
            height: 300px;
            background: white;
            border-radius: 50%;
            top: -100px;
            right: -100px;
        }
        
        .shape-2 {
            width: 200px;
            height: 200px;
            background: white;
            border-radius: 50%;
            bottom: -50px;
            left: -50px;
        }
        
        /* Card entrance animation */
        .login-card {
            animation: cardEntrance 0.6s ease-out;
        }
        
        @keyframes cardEntrance {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Logo styling - solid color */
        .logo-container {
            background-color: rgba(255, 255, 255, 0.2);
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        /* Input focus */
        .input-glow:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.2);
        }
    </style>
</head>
<body class="login-bg">
    <!-- Background shapes -->
    <div class="shape shape-1"></div>
    <div class="shape shape-2"></div>
    
    <div class="min-h-screen flex items-center justify-center p-4 relative z-10">
        <div class="w-full max-w-md">
            <!-- Logo Section -->
            <div class="text-center mb-8">
                <div class="logo-container inline-flex items-center justify-center w-20 h-20 bg-white/20 backdrop-blur rounded-2xl mb-4 shadow-xl border border-white/30">
                    <i class="fas fa-boxes text-4xl text-white"></i>
                </div>
                <h1 class="text-4xl font-bold text-white mb-2 tracking-tight">Mercato</h1>
                <p class="text-white/80 text-lg">Système de Gestion d'Inventaire</p>
            </div>
            
            <!-- Login Card -->
            <div class="card bg-base-100 shadow-2xl login-card border-0">
                <div class="card-body p-8">
                    <div class="text-center mb-6">
                        <h2 class="text-2xl font-bold text-gray-800">Connexion</h2>
                        <p class="text-sm text-gray-500 mt-1">Accédez à votre tableau de bord</p>
                    </div>
                    
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error mb-6 animate-fade-in">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <!-- Success Message -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success mb-6 animate-fade-in">
                            <i class="fas fa-check-circle"></i>
                            <span>${success}</span>
                        </div>
                    </c:if>
                    
                    <!-- Login Form -->
                    <form action="${contextPath}/login" method="post" class="space-y-5" id="loginForm">
                        <div class="form-control">
                            <label class="label">
                                <span class="label-text font-medium">Nom d'utilisateur</span>
                            </label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">
                                    <i class="fas fa-user"></i>
                                </span>
                                <input type="text" name="username" placeholder="Entrez votre nom d'utilisateur" 
                                       class="input input-bordered w-full pl-10 input-glow transition-all" 
                                       required autofocus autocomplete="username" />
                            </div>
                        </div>
                        
                        <div class="form-control">
                            <label class="label">
                                <span class="label-text font-medium">Mot de passe</span>
                            </label>
                            <div class="relative">
                                <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">
                                    <i class="fas fa-lock"></i>
                                </span>
                                <input type="password" name="password" placeholder="Entrez votre mot de passe" 
                                       class="input input-bordered w-full pl-10 input-glow transition-all" 
                                       required autocomplete="current-password" />
                                <button type="button" class="absolute inset-y-0 right-0 pr-3 flex items-center text-gray-400 hover:text-gray-600 transition-colors"
                                        onclick="togglePassword(this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-full btn-lg shadow-lg hover:shadow-xl transition-all btn-shine" id="loginBtn">
                            <i class="fas fa-sign-in-alt mr-2"></i>
                            Se connecter
                        </button>
                    </form>
                    

                </div>
            </div>
            
            <!-- Footer -->
            <div class="text-center mt-8 text-white/60 text-sm">
                <p class="mb-1">M2 IRT AL - Jakarta EE 10</p>
                <p>&copy; 2026 Mercato - Tous droits réservés</p>
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        function togglePassword(btn) {
            const input = btn.parentElement.querySelector('input');
            const icon = btn.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Form submission with loading state
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const btn = document.getElementById('loginBtn');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Connexion en cours...';
        });
        
        // Add ripple effect on button click
        document.querySelectorAll('.btn').forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.classList.add('ripple');
                
                this.appendChild(ripple);
                
                setTimeout(() => ripple.remove(), 600);
            });
        });
    </script>
    
    <style>
        /* Ripple effect */
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.4);
            transform: scale(0);
            animation: rippleEffect 0.6s ease-out;
            pointer-events: none;
        }
        
        @keyframes rippleEffect {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
    </style>
</body>
</html>
