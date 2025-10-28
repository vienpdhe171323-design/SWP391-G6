<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #4f46e5;
            --primary-dark: #4338ca;
            --sidebar-bg: #1e293b;
            --sidebar-hover: #334155;
            --card-bg: #ffffff;
            --text: #1e293b;
            --text-light: #64748b;
            --border: #e2e8f0;
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --radius: 12px;
            --transition: all 0.3s ease;
        }

        [data-theme="dark"] {
            --card-bg: #1e293b;
            --text: #f1f5f9;
            --text-light: #94a3b8;
            --border: #334155;
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: #f8fafc;
            color: var(--text);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            color: white;
            padding: 1.5rem 0;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 0 1.5rem 1.5rem;
            border-bottom: 1px solid #334155;
        }

        .sidebar-header h1 {
            font-size: 1.5rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .sidebar-menu {
            padding: 1rem 0;
        }

        .sidebar-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            color: #cbd5e1;
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
        }

        .sidebar-item i {
            width: 20px;
            margin-right: 12px;
            font-size: 1.1rem;
        }

        .sidebar-item:hover,
        .sidebar-item.active {
            background: var(--sidebar-hover);
            color: white;
        }

        .sidebar-item.active {
            border-left: 4px solid var(--primary);
            padding-left: 1.3rem;
        }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 2rem;
            transition: var(--transition);
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }

        .theme-toggle {
            background: none;
            border: 1px solid var(--border);
            color: var(--text-light);
            padding: 0.5rem;
            border-radius: 8px;
            cursor: pointer;
            transition: var(--transition);
        }

        .theme-toggle:hover {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        /* Search & Filter */
        .filter-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-size: 0.875rem;
            color: var(--text-light);
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        /* Table */
        .table-container {
            background: var(--card-bg);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .table thead {
            background: var(--primary);
            color: white;
        }

        .table thead th {
            font-weight: 600;
            border: none;
            padding: 1rem;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: var(--border);
            font-size: 0.95rem;
        }

        .table tbody tr:hover {
            background-color: rgba(79, 70, 229, 0.05);
        }

        .badge {
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .badge-admin { background: #fecaca; color: #991b1b; }
        .badge-seller { background: #fde68a; color: #92400e; }
        .badge-buyer { background: #bfdbfe; color: #1e40af; }
        .badge-active { background: #dcfce7; color: #166534; }
        .badge-inactive { background: #fee2e2; color: #991b1b; }

        .action-btn {
            padding: 0.4rem 0.7rem;
            font-size: 0.85rem;
            border-radius: 6px;
            margin: 0 2px;
            transition: var(--transition);
        }

        .btn-edit { background: #fef3c7; color: #92400e; border: none; }
        .btn-edit:hover { background: #fde68a; }

        .btn-deactive { background: #e5e7eb; color: #4b5563; border: none; }
        .btn-deactive:hover { background: #d1d5db; }

        .btn-active { background: #d1fae5; color: #065f46; border: none; }
        .btn-active:hover { background: #a7f3d0; }

        .btn-delete { background: #fee2e2; color: #991b1b; border: none; }
        .btn-delete:hover { background: #fecaca; }

        /* Pagination */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 3px;
            color: var(--primary);
            border: 1px solid var(--border);
            padding: 0.5rem 0.85rem;
            font-weight: 500;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                padding: 1rem 0;
            }
            .sidebar-header h1, .sidebar-item span {
                display: none;
            }
            .sidebar-item {
                justify-content: center;
            }
            .main-content {
                margin-left: 80px;
            }
        }

        @media (max-width: 768px) {
            .filter-row {
                grid-template-columns: 1fr;
            }
            .page-header {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h1>Admin</h1>
        </div>
        <div class="sidebar-menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-item">
                <i class="fa-solid fa-gauge-high"></i> <span>Tổng quan</span>
            </a>
            <a href="${pageContext.request.contextPath}/user" class="sidebar-item active">
                <i class="fa-solid fa-users"></i> <span>Người dùng</span>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="sidebar-item">
                <i class="fa-solid fa-boxes-stacked"></i> <span>Sản phẩm</span>
            </a>
            <a href="${pageContext.request.contextPath}/order-report" class="sidebar-item">
                <i class="fa-solid fa-receipt"></i> <span>Đơn hàng</span>
            </a>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="sidebar-item" style="padding: 0; margin: 0;">
                <button type="submit" style="all: unset; width: 100%; text-align: left; padding: 0.75rem 1.5rem; color: #cbd5e1; cursor: pointer;">
                    <i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span>
                </button>
            </form>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="page-header">
            <h2 class="page-title">Quản lý Người dùng</h2>
            <div class="d-flex gap-2">
                <button class="theme-toggle" onclick="toggleTheme()">
                    <i class="fas fa-moon"></i>
                </button>
                <a href="${pageContext.request.contextPath}/user?action=add" class="btn btn-primary">
                    <i class="fa-solid fa-user-plus"></i> Thêm người dùng
                </a>
            </div>
        </div>

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Search & Filter -->
        <div class="filter-card">
            <form action="${pageContext.request.contextPath}/user" method="get" class="filter-row">
                <input type="hidden" name="action" value="list">
                <div class="filter-group">
                    <label>Tên đầy đủ</label>
                    <input type="text" name="searchFullName" value="${fn:escapeXml(searchFullName)}" class="form-control" placeholder="Nhập tên...">
                </div>
                <div class="filter-group">
                    <label>Email</label>
                    <input type="text" name="searchEmail" value="${fn:escapeXml(searchEmail)}" class="form-control" placeholder="Nhập email...">
                </div>
                <div class="filter-group">
                    <label>Vai trò</label>
                    <select name="searchRole" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="Admin" ${"Admin" == searchRole ? "selected" : ""}>Admin</option>
                        <option value="Seller" ${"Seller" == searchRole ? "selected" : ""}>Seller</option>
                        <option value="Buyer" ${"Buyer" == searchRole ? "selected" : ""}>Buyer</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Trạng thái</label>
                    <select name="searchStatus" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="Active" ${"Active" == searchStatus ? "selected" : ""}>Hoạt động</option>
                        <option value="Deactive" ${"Deactive" == searchStatus ? "selected" : ""}>Vô hiệu</option>
                    </select>
                </div>
                <div class="filter-group">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fa-solid fa-magnifying-glass"></i> Tìm kiếm
                    </button>
                </div>
            </form>
        </div>

        <!-- User Table -->
        <div class="table-container">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
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
                                <td class="fw-medium">${user.id}</td>
                                <td>${user.email}</td>
                                <td class="fw-semibold">${user.fullName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'Admin'}">
                                            <span class="badge badge-admin">ADMIN</span>
                                        </c:when>
                                        <c:when test="${user.role == 'Seller'}">
                                            <span class="badge badge-seller">SELLER</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-buyer">BUYER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge ${user.status == 'Active' ? 'badge-active' : 'badge-inactive'}">
                                        ${user.status == 'Active' ? 'Hoạt động' : 'Vô hiệu'}
                                    </span>
                                </td>
                                <td>${user.createdAt}</td>
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/user?action=edit&id=${user.id}"
                                       class="btn action-btn btn-edit" title="Sửa">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>

                                    <c:choose>
                                        <c:when test="${user.status == 'Active'}">
                                            <a href="${pageContext.request.contextPath}/user?action=deactive&id=${user.id}"
                                               class="btn action-btn btn-deactive" title="Vô hiệu hóa"
                                               onclick="return confirm('Vô hiệu hóa người dùng này?')">
                                                <i class="fa-solid fa-lock"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/user?action=active&id=${user.id}"
                                               class="btn action-btn btn-active" title="Kích hoạt"
                                               onclick="return confirm('Kích hoạt người dùng này?')">
                                                <i class="fa-solid fa-lock-open"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="${pageContext.request.contextPath}/user?action=delete&id=${user.id}"
                                       class="btn action-btn btn-delete" title="Xóa"
                                       onclick="return confirm('XÓA người dùng này?')">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4 d-flex justify-content-center">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/user?page=${currentPage-1}&searchFullName=${fn:escapeXml(searchFullName)}&searchEmail=${fn:escapeXml(searchEmail)}&searchRole=${fn:escapeXml(searchRole)}&searchStatus=${fn:escapeXml(searchStatus)}">
                                Trước
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
                                Sau
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dark mode
        function toggleTheme() {
            const body = document.body;
            const current = body.getAttribute('data-theme');
            const newTheme = current === 'dark' ? 'light' : 'dark';
            body.setAttribute('data-theme', newTheme);
            localStorage.setItem('admin-theme', newTheme);
        }

        window.addEventListener('DOMContentLoaded', () => {
            const saved = localStorage.getItem('admin-theme');
            if (saved) document.body.setAttribute('data-theme', saved);
            else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
                document.body.setAttribute('data-theme', 'dark');
            }
        });
    </script>
</body>
</html>