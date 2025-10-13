<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Người dùng mới</title>
    
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
            justify-content: center; /* Căn giữa form */
        }
        
        .form-container {
            width: 100%;
            max-width: 600px; /* Độ rộng tối ưu cho form */
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
            color: var(--primary-color);
        }
        
        /* Tinh chỉnh Form control */
        .form-label {
            font-weight: 600;
            color: #495057;
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
                <h2><i class="fa-solid fa-user-plus me-2"></i> Thêm Người dùng mới</h2>
            </div>
            
            <form id="userForm" action="${pageContext.request.contextPath}/user" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" id="email" name="email" required>
                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password <span class="text-danger">*</span></label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <div class="invalid-feedback">Vui lòng nhập mật khẩu.</div>
                </div>

                <div class="mb-3">
                    <label for="fullName" class="form-label">Full Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                    <div class="invalid-feedback">Vui lòng nhập tên đầy đủ.</div>
                </div>

                <div class="mb-3">
                    <label for="role" class="form-label">Role <span class="text-danger">*</span></label>
                    <select class="form-select" id="role" name="role" required>
                        <option value="" disabled selected>Select Role</option>
                        <option value="Admin">Admin</option>
                        <option value="Seller">Seller</option>
                        <option value="Buyer">Buyer</option>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn một vai trò.</div>
                </div>

                <div class="mb-3">
                    <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="Active">Active</option>
                        <option value="Deactive">Deactive</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> Thêm người dùng
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
          var form = document.getElementById('userForm')
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