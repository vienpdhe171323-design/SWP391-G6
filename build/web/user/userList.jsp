<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        /* ==================================== */
        /* GLOBAL STYLES (ĐỒNG BỘ VỚI DASHBOARD) */
        /* ==================================== */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        :root {
            --primary-color: #0d6efd; /* Bootstrap Primary */
            --secondary-dark: #1f2937; /* Màu nền header/footer (Dashboard) */
            --bg-light: #f3f4f6; /* Nền body nhẹ (Dashboard) */
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

        /* HEADER / NAVBAR (ĐỒNG BỘ) */
        .navbar {
            background: var(--secondary-dark); /* Màu tối cho header */
            color: var(--text-light);
            padding: 18px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            font-size: 24px;
            margin: 0;
            font-weight: 700;
        }

        .navbar a {
            color: var(--text-light);
            text-decoration: none;
            margin-left: 25px;
            font-weight: 500;
            padding: 5px 0;
            transition: color 0.3s ease;
        }

        .navbar a:hover {
            color: var(--primary-color); /* Sử dụng màu Bootstrap Primary */
            border-bottom: 2px solid var(--primary-color);
        }
        
        /* FOOTER (ĐỒNG BỘ) */
        .footer {
            margin-top: auto; /* Đẩy footer xuống cuối trang */
            background: var(--secondary-dark);
            color: var(--text-light);
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        /* ==================================== */
        /* USER MANAGEMENT STYLES */
        /* ==================================== */
        .main-content {
            flex-grow: 1;
            padding: 40px 20px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
        }

        .table-wrapper {
            background: #fff;
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: var(--card-shadow); 
        }

        .table-title h2 {
            font-weight: 700;
            color: var(--text-dark);
        }
        
        .search-filters {
            padding: 20px;
            background-color: #f8f9fa; 
            border-radius: 8px;
            margin-bottom: 25px;
            border: 1px solid #e5e7eb;
        }
        
        .btn-icon-text .fa-solid {
            margin-right: 8px;
        }

        .table > :not(caption) > * > * {
            padding: 12px 15px; 
        }
        .table-light th {
            background-color: #e9ecef !important;
            color: #495057;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
        }
        .table-hover tbody tr:hover {
            background-color: #eef4ff; 
        }
        
        .badge {
            font-size: 0.85em;
            font-weight: 700;
            padding: 0.5em 0.8em;
            min-width: 80px;
            display: inline-block;
        }
        
        .action-buttons a, .action-buttons button {
            transition: transform 0.2s ease;
        }
        .action-buttons a:hover, .action-buttons button:hover {
            transform: translateY(-2px);
        }

        .pagination .page-item .page-link {
            border-radius: 8px; 
            margin: 0 4px;
            transition: all 0.3s;
        }
        .pagination .page-item.active .page-link {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            box-shadow: 0 2px 5px rgba(13, 110, 253, 0.2);
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

    <div class="container main-content">
        <div class="table-wrapper">
            
            <div class="table-title d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fa-solid fa-users-gear me-2 text-primary"></i> Quản lý Người dùng</h2>
                <button class="btn btn-primary btn-icon-text" 
                        onclick="window.location.href='${pageContext.request.contextPath}/user?action=add'">
                    <i class="fa-solid fa-user-plus"></i> Thêm người dùng
                </button>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert"><i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}</div>
            </c:if>

            <div class="search-filters">
                <form action="${pageContext.request.contextPath}/user" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="action" value="list">
                    
                    <div class="col-lg-3 col-md-6">
                        <input type="text" class="form-control" name="searchFullName" value="${fn:escapeXml(searchFullName)}" placeholder="Tìm theo Tên đầy đủ...">
                    </div>
                    
                    <div class="col-lg-3 col-md-6">
                        <input type="text" class="form-control" name="searchEmail" value="${fn:escapeXml(searchEmail)}" placeholder="Tìm theo Email...">
                    </div>
                    
                    <div class="col-lg-2 col-md-4">
                        <select class="form-select" name="searchRole">
                            <option value="">Tất cả Vai trò</option>
                            <option value="Admin" ${"Admin" == searchRole ? "selected" : ""}>Admin</option>
                            <option value="Seller" ${"Seller" == searchRole ? "selected" : ""}>Seller</option>
                            <option value="Buyer" ${"Buyer" == searchRole ? "selected" : ""}>Buyer</option>
                        </select>
                    </div>
                    
                    <div class="col-lg-2 col-md-4">
                        <select class="form-select" name="searchStatus">
                            <option value="">Tất cả Trạng thái</option>
                            <option value="Active" ${"Active" == searchStatus ? "selected" : ""}>Hoạt động</option>
                            <option value="Deactive" ${"Deactive" == searchStatus ? "selected" : ""}>Vô hiệu hóa</option>
                        </select>
                    </div>
                    
                    <div class="col-lg-2 col-md-4">
                        <button type="submit" class="btn btn-primary w-100 btn-icon-text">
                            <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Tên đầy đủ</th>
                            <th>Vai trò</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td>${user.id}</td>
                                <td>${user.email}</td>
                                <td>${user.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'Admin'}"><span class="badge bg-danger">ADMIN</span></c:when>
                                        <c:when test="${user.role == 'Seller'}"><span class="badge bg-warning text-dark">SELLER</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">BUYER</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge ${user.status == 'Active' ? 'bg-success' : 'bg-secondary'}">
                                        ${user.status == 'Active' ? 'Hoạt động' : 'Vô hiệu'}
                                    </span>
                                </td>
                                <td>${user.createdAt}</td>
                                <td class="text-center action-buttons">
                                    <a href="${pageContext.request.contextPath}/user?action=edit&id=${user.id}"
                                        class="btn btn-sm btn-outline-warning" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    
                                    <c:choose>
                                        <c:when test="${user.status == 'Active'}">
                                            <a href="${pageContext.request.contextPath}/user?action=deactive&id=${user.id}"
                                               class="btn btn-sm btn-outline-secondary" title="Vô hiệu hóa"
                                               onclick="return confirm('Bạn có chắc muốn VÔ HIỆU HÓA người dùng này không?')">
                                               <i class="fa-solid fa-lock"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/user?action=active&id=${user.id}"
                                               class="btn btn-sm btn-outline-success" title="Kích hoạt"
                                               onclick="return confirm('Bạn có chắc muốn KÍCH HOẠT người dùng này không?')">
                                               <i class="fa-solid fa-lock-open"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <a href="${pageContext.request.contextPath}/user?action=delete&id=${user.id}"
                                       class="btn btn-sm btn-outline-danger" title="Xóa"
                                       onclick="return confirm('Bạn có chắc muốn XÓA người dùng này không?')">
                                       <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mt-4">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/user?page=${currentPage-1}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">
                                    <i class="fa-solid fa-angle-left"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/user?page=${i}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/user?page=${currentPage+1}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">
                                    <i class="fa-solid fa-angle-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <div class="footer">
        © 2025 Online Market Admin | Được phát triển bởi Your Team
    </div>
</body>
</html>