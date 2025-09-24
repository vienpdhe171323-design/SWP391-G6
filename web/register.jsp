<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký - Online Market</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/register.css">
    </head>
    <body>
        <!-- Back to Home -->
        <a href="${pageContext.request.contextPath}/home" class="back-home">
            <i class="fas fa-arrow-left me-2"></i>Về trang chủ
        </a>

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-11">
                    <div class="register-container">
                        <div class="row g-0">
                            <!-- Welcome Image -->
                            <div class="col-lg-5">
                                <div class="register-image">
                                    <div>
                                        <h3 class="fw-bold mb-3">Tham gia cùng chúng tôi!</h3>
                                        <p class="lead mb-4">Tạo tài khoản để trải nghiệm mua sắm tuyệt vời và nhận những ưu đãi đặc biệt.</p>
                                        <div class="benefits">
                                            <div class="mb-3">
                                                <i class="fas fa-gift fa-2x mb-2"></i>
                                                <p>Ưu đãi độc quyền</p>
                                            </div>
                                            <div class="mb-3">
                                                <i class="fas fa-star fa-2x mb-2"></i>
                                                <p>Tích điểm thưởng</p>
                                            </div>
                                            <div class="mb-3">
                                                <i class="fas fa-truck fa-2x mb-2"></i>
                                                <p>Miễn phí vận chuyển</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Register Form -->
                            <div class="col-lg-7">
                                <div class="register-form">
                                    <div class="text-center mb-4">
                                        <h2 class="fw-bold text-primary">Đăng ký tài khoản</h2>
                                        <p class="text-muted">Điền thông tin để tạo tài khoản mới</p>
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

                                    <!-- Register Form -->
                                    <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="text" class="form-control" id="firstName" name="firstName"
                                                           placeholder="Họ" required value="${form.firstName}">
                                                    <label for="firstName">
                                                        <i class="fas fa-user me-2"></i>Họ
                                                    </label>
                                                    <div class="invalid-feedback" id="firstNameError"></div>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="text" class="form-control" id="lastName" name="lastName" 
                                                           placeholder="Tên" required value="${form.lastName}">
                                                    <label for="lastName">
                                                        <i class="fas fa-user me-2"></i>Tên
                                                    </label>
                                                    <div class="invalid-feedback" id="lastNameError"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-floating mb-3 mt-3">
                                            <input type="email" class="form-control" id="email" name="email" 
                                                   placeholder="name@example.com" required value="${form.email}">
                                            <label for="email">
                                                <i class="fas fa-envelope me-2"></i>Email
                                            </label>
                                            <div class="invalid-feedback" id="emailError"></div>
                                        </div>

                                        <div class="row g-3">
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="password" class="form-control" id="password" name="password" 
                                                           placeholder="Password" required>
                                                    <label for="password">
                                                        <i class="fas fa-lock me-2"></i>Mật khẩu
                                                    </label>
                                                    <div class="password-strength">
                                                        <div class="password-strength-bar" id="strengthBar"></div>
                                                    </div>
                                                    <div class="invalid-feedback" id="passwordError"></div>
                                                    <small class="text-muted">Ít nhất 6 ký tự, bao gồm chữ và số</small>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-floating">
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                                           placeholder="Confirm Password" required>
                                                    <label for="confirmPassword">
                                                        <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu
                                                    </label>
                                                    <div class="invalid-feedback" id="confirmPasswordError"></div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-floating mb-3 mt-3">
                                            <textarea class="form-control" id="address" name="address" 
                                                      placeholder="Địa chỉ" style="height: 80px;">${form.address}</textarea>
                                            <label for="address">
                                                <i class="fas fa-map-marker-alt me-2"></i>Địa chỉ (tuỳ chọn)
                                            </label>
                                        </div>

                                        <div class="form-check mb-3">
                                            <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required>
                                            <label class="form-check-label" for="agreeTerms">
                                                Tôi đồng ý với 
                                                <a href="#" class="text-decoration-none">Điều khoản sử dụng</a> 
                                                và 
                                                <a href="#" class="text-decoration-none">Chính sách bảo mật</a>
                                            </label>
                                        </div>

                                        <div class="form-check mb-4">
                                            <input class="form-check-input" type="checkbox" id="newsletter" name="newsletter">
                                            <label class="form-check-label" for="newsletter">
                                                Nhận thông tin khuyến mãi và tin tức mới nhất qua email
                                            </label>
                                        </div>

                                        <button type="submit" class="btn btn-primary w-100 mb-3">
                                            <i class="fas fa-user-plus me-2"></i>Tạo tài khoản
                                        </button>
                                    </form>

                                    <!-- Login Link -->
                                    <div class="text-center mt-4">
                                        <p class="mb-0">Đã có tài khoản? 
                                            <a href="${pageContext.request.contextPath}/login" 
                                               class="text-decoration-none fw-bold">Đăng nhập ngay</a>
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
            // Password strength checker
            document.getElementById('password').addEventListener('input', function () {
                const password = this.value;
                const strengthBar = document.getElementById('strengthBar');

                let strength = 0;
                if (password.length >= 6)
                    strength++;
                if (password.match(/[a-z]/) && password.match(/[A-Z]/))
                    strength++;
                if (password.match(/[0-9]/))
                    strength++;
                if (password.match(/[^a-zA-Z0-9]/))
                    strength++;

                strengthBar.className = 'password-strength-bar';
                if (strength === 1)
                    strengthBar.classList.add('strength-weak');
                else if (strength === 2 || strength === 3)
                    strengthBar.classList.add('strength-medium');
                else if (strength === 4)
                    strengthBar.classList.add('strength-strong');
            });

            // Form validation
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Clear previous errors
                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
                document.querySelectorAll('.invalid-feedback').forEach(el => el.textContent = '');

                // Validate first name
                const firstName = document.getElementById('firstName').value.trim();
                if (!firstName) {
                    showError('firstName', 'Vui lòng nhập họ');
                    isValid = false;
                }

                // Validate last name
                const lastName = document.getElementById('lastName').value.trim();
                if (!lastName) {
                    showError('lastName', 'Vui lòng nhập tên');
                    isValid = false;
                }

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

                // Validate phone
                const phone = document.getElementById('phone').value.trim();
                const phoneRegex = /^[0-9]{10,11}$/;
                if (!phone) {
                    showError('phone', 'Vui lòng nhập số điện thoại');
                    isValid = false;
                } else if (!phoneRegex.test(phone)) {
                    showError('phone', 'Số điện thoại không đúng định dạng');
                    isValid = false;
                }

                // Validate password
                const password = document.getElementById('password').value;
                if (!password) {
                    showError('password', 'Vui lòng nhập mật khẩu');
                    isValid = false;
                } else if (password.length < 6) {
                    showError('password', 'Mật khẩu phải có ít nhất 6 ký tự');
                    isValid = false;
                }

                // Validate confirm password
                const confirmPassword = document.getElementById('confirmPassword').value;
                if (!confirmPassword) {
                    showError('confirmPassword', 'Vui lòng xác nhận mật khẩu');
                    isValid = false;
                } else if (password !== confirmPassword) {
                    showError('confirmPassword', 'Mật khẩu xác nhận không khớp');
                    isValid = false;
                }

                // Validate terms agreement
                const agreeTerms = document.getElementById('agreeTerms').checked;
                if (!agreeTerms) {
                    alert('Vui lòng đồng ý với điều khoản sử dụng!');
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
        </script>
    </body>
</html>