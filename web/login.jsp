<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Online Market</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/login.css">
    </head>
    <body>
        <!-- Back to Home -->
        <a href="${pageContext.request.contextPath}/home" class="back-home">
            <i class="fas fa-arrow-left me-2"></i>Về trang chủ
        </a>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="login-container">
                        <div class="row g-0">
                            <!-- Welcome Image -->
                            <div class="col-lg-5">
                                <div class="login-image">
                                    <div>
                                        <h3 class="fw-bold mb-3">Chào mừng trở lại!</h3>
                                        <p class="lead mb-4">Đăng nhập để tiếp tục trải nghiệm mua sắm và nhận những ưu đãi tuyệt vời.</p>
                                        <div class="benefits">
                                            <div class="mb-3">
                                                <i class="fas fa-shopping-bag fa-2x mb-2"></i>
                                                <p>Mua sắm dễ dàng</p>
                                            </div>
                                            <div class="mb-3">
                                                <i class="fas fa-heart fa-2x mb-2"></i>
                                                <p>Sản phẩm yêu thích</p>
                                            </div>
                                            <div class="mb-3">
                                                <i class="fas fa-history fa-2x mb-2"></i>
                                                <p>Lịch sử mua hàng</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Login Form -->
                            <div class="col-lg-7">
                                <div class="login-form">
                                    <div class="text-center mb-4">
                                        <h2 class="fw-bold text-primary">Đăng nhập</h2>
                                        <p class="text-muted">Nhập thông tin để đăng nhập vào tài khoản</p>
                                    </div>

                                    <!-- Error/Success Messages -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger" role="alert">
                                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>${success}
                                        </div>
                                    </c:if>

                                    <!-- Login Form -->
                                    <form action="${pageContext.request.contextPath}/login" method="POST" id="loginForm">
                                        <div class="form-floating mb-3">
                                            <input type="email" class="form-control" id="email" name="email" 
                                                   placeholder="name@example.com" required value="${param.email}">
                                            <label for="email">
                                                <i class="fas fa-envelope me-2"></i>Email
                                            </label>
                                            <div class="invalid-feedback" id="emailError"></div>
                                        </div>

                                        <div class="form-floating mb-3">
                                            <input type="password" class="form-control" id="password" name="password" 
                                                   placeholder="Password" required>
                                            <label for="password">
                                                <i class="fas fa-lock me-2"></i>Mật khẩu
                                            </label>
                                            <div class="invalid-feedback" id="passwordError"></div>
                                        </div>

                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                                    <label class="form-check-label" for="rememberMe">
                                                        Ghi nhớ đăng nhập
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <a href="${pageContext.request.contextPath}/forgot-password" 
                                                   class="text-decoration-none text-primary">Quên mật khẩu?</a>
                                            </div>
                                        </div>

                                        <button type="submit" class="btn btn-primary w-100 mb-3">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </button>
                                    </form>

                                    <!-- Social Login (Optional) -->
                                    <div class="text-center mb-4">
                                        <p class="text-muted">Hoặc đăng nhập với</p>
                                        <div class="d-flex justify-content-center gap-3">
                                            <a href="#" class="btn btn-outline-primary">
                                                <i class="fab fa-google me-2"></i>Google
                                            </a>
                                            <a href="#" class="btn btn-outline-primary">
                                                <i class="fab fa-facebook me-2"></i>Facebook
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Register Link -->
                                    <div class="text-center">
                                        <p class="mb-0">Chưa có tài khoản? 
                                            <a href="${pageContext.request.contextPath}/register" 
                                               class="text-decoration-none fw-bold">Đăng ký ngay</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script>
            // Form validation
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Clear previous errors
                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
                document.querySelectorAll('.invalid-feedback').forEach(el => el.textContent = '');

                // Validate email
                const email = document.getElementById('email').value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!email) {
                    showError('email', 'Vui lòng nhập email');
                    isValid = false;
                } else if (!emailRegex.test(email)) {
                    showError('email', 'Email không đúng định dạng');
                    isValid = false;
                }

                // Validate password
                const password = document.getElementById('password').value;
                if (!password) {
                    showError('password', 'Vui lòng nhập mật khẩu');
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
                }
            });

            function showError(fieldId, message) {
                const field = document.getElementById(fieldId);
                const errorDiv = document.getElementById(fieldId + 'Error');

                field.classList.add('is-invalid');
                errorDiv.textContent = message;
            }

            // Auto-hide alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        alert.style.opacity = '0';
                        setTimeout(function () {
                            alert.remove();
                        }, 300);
                    }, 5000);
                });
            });

            // Show password toggle (optional enhancement)
            function togglePasswordVisibility() {
                const passwordField = document.getElementById('password');
                const toggleButton = document.querySelector('.password-toggle');
                
                if (passwordField.type === 'password') {
                    passwordField.type = 'text';
                    toggleButton.innerHTML = '<i class="fas fa-eye-slash"></i>';
                } else {
                    passwordField.type = 'password';
                    toggleButton.innerHTML = '<i class="fas fa-eye"></i>';
                }
            }
        </script>
    </body>
</html>