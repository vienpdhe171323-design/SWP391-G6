<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quên mật khẩu - Online Market</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="assets/css/login.css">
</head>
<body>
  <a href="${pageContext.request.contextPath}/home" class="back-home">
    <i class="fas fa-arrow-left me-2"></i>Về trang chủ
  </a>

  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-10">
        <div class="login-container">
          <div class="row g-0">
            <div class="col-lg-5">
              <div class="login-image">
                <div>
                  <h3 class="fw-bold mb-3">Quên mật khẩu?</h3>
                  <p class="lead mb-4">Nhập email để nhận link đặt lại mật khẩu.</p>
                </div>
              </div>
            </div>

            <div class="col-lg-7">
              <div class="login-form">
                <div class="text-center mb-4">
                  <h2 class="fw-bold text-primary">Quên mật khẩu</h2>
                  <p class="text-muted">Chúng tôi sẽ gửi link đặt lại mật khẩu vào email của bạn</p>
                </div>

                <c:if test="${not empty error}">
                  <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                  <div class="alert alert-success">${success}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/forgot-password" method="POST" id="forgotForm">
                  <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="Email" required value="${form.email}">
                    <label for="email"><i class="fas fa-envelope me-2"></i>Email</label>
                  </div>
                  <button type="submit" class="btn btn-primary w-100"><i class="fas fa-paper-plane me-2"></i>Gửi link</button>
                </form>

                <div class="text-center mt-3">
                  <a href="${pageContext.request.contextPath}/login" class="text-decoration-none"><i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập</a>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
