<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Người dùng: ${user.email}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        /* ==================================== */
        /* GLOBAL STYLES (ĐỒNG BỘ VỚI DASHBOARD) */
        /* ==================================== */
        :root {
            --primary-color: #0d6efd;
            --secondary-dark: #1f2937; /* Màu nền header/footer */
            --bg-light: #f3f4f6;
            --text-light: #e5e7eb;
            --text-dark: #1f2937;
            --card-shadow: 0 5px 20px rgba(0,0,0,0.08);
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* HEADER / NAVBAR */
        .navbar {
            background: var(--secondary-dark);
            color: var(--text-light);
            padding: 18px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 {
            font-size: 24px; margin: 0; font-weight: 700;
        }
        .navbar a {
            color: var(--text-light); text-decoration: none; margin-left: 25px;
            font-weight: 500; padding: 5px 0; transition: color 0.3s ease;
        }
        .navbar a:hover {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
        }
        
        /* FOOTER */
        .footer {
            margin-top: auto;
            background: var(--secondary-dark);
            color: var(--text-light);
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        /* ==================================== */
        /* FORM CONTAINER STYLES */
        /* ==================================== */
        .main-content {
            flex-grow: 1;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }
        
        .form-container {
            width: 100%;
            max-width: 600px;
            background: #fff;
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: var(--card-shadow); 
        }

        .form-header {
            margin-bottom: 30px;
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 15px;
        }
        .form-header h2 {
            font-weight: 700;
            color: #ffc107; /* Màu vàng của cảnh báo/chỉnh sửa */
        }
        
        /* Tinh chỉnh Form control */
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .form-control[readonly] {
            background-color: #e9ecef;
        }

        /* Nút Actions */
        .form-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #f0f2f5; 
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .form-actions .btn {
            min-width: 120px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    
    <div class="navbar">
        <h1><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển Admin</h1>
        <div>
            <a href="#"><i class="fa-solid fa-users"></i> Người dùng</a>
            <a href="#"><i class="fa-solid fa-boxes-stacked"></i> Sản phẩm</a>
            <a href="#"><i class="fa-solid fa-receipt"></i> Đơn hàng</a>
            <a href="#"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </div>
    </div>

    <div class="main-content">
        <div class="form-container">
            
            <div class="form-header">
                <h2><i class="fa-solid fa-user-pen me-2"></i> Chỉnh sửa Người dùng</h2>
            </div>
            
            <form id="userEditForm" action="${pageContext.request.contextPath}/user" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${user.id}">

                <div class="mb-3">
                    <label for="email" class="form-label"><i class="fa-solid fa-at"></i> Email (không thể thay đổi)</label>
                    <input type="email" class="form-control" id="email" name="email" 
                            value="${user.email}" readonly>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label"><i class="fa-solid fa-lock"></i> Password</label>
                    <input type="password" class="form-control" id="password" name="password"
                            placeholder="Để trống nếu không muốn đổi mật khẩu">
                    <small class="form-text text-muted">Mật khẩu mới phải có ít nhất 6 ký tự (nếu thay đổi).</small>
                </div>

                <div class="mb-3">
                    <label for="fullName" class="form-label"><i class="fa-solid fa-user-tag"></i> Full Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" 
                            value="${user.fullName}" required>
                    <div class="invalid-feedback">Vui lòng nhập tên đầy đủ.</div>
                </div>

                <div class="mb-3">
                    <label for="role" class="form-label"><i class="fa-solid fa-shield-halved"></i> Role <span class="text-danger">*</span></label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="Admin" ${user.role == 'Admin' ? 'selected' : ''}>Admin</option>
                        <option value="Seller" ${user.role == 'Seller' ? 'selected' : ''}>Seller</option>
                        <option value="Buyer" ${user.role == 'Buyer' ? 'selected' : ''}>Buyer</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label"><i class="fa-solid fa-toggle-on"></i> Status <span class="text-danger">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Deactive" ${user.status == 'Deactive' ? 'selected' : ''}>Deactive</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </button>
                    <button type="submit" class="btn btn-success">
                        <i class="fa-solid fa-cloud-arrow-up"></i> Cập nhật
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Kích hoạt tính năng validation của Bootstrap
        (function () {
          'use strict'
          var form = document.getElementById('userEditForm')
          form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
              event.preventDefault()
              event.stopPropagation()
            }
            form.classList.add('was-validated')
          }, false)
        })()
    </script>
    
    <div class="footer">
        © 2025 Online Market Admin | Được phát triển bởi Your Team
    </div>
</body>
</html>