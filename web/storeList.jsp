<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Cửa hàng</title>
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
        * { font-family: 'Inter', sans-serif; }
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
        .sidebar-menu { padding: 1rem 0; }
        .sidebar-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            color: #cbd5e1;
            text-decoration: none;
            transition: var(--transition);
            font-weight: 500;
        }
        .sidebar-item i { width: 20px; margin-right: 12px; font-size: 1.1rem; }
        .sidebar-item:hover, .sidebar-item.active {
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
        /* Cards */
        .table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }
        .table thead {
            background: #eef2ff;
            font-weight: 600;
        }
        .status-badge {
            font-weight: 600;
            border-radius: 20px;
            padding: 5px 12px;
            font-size: 0.8rem;
        }
        .status-active {
            color: #0f5132;
            background-color: #d1e7dd;
        }
        .status-suspended {
            color: #842029;
            background-color: #f8d7da;
        }
        .action-buttons a {
            margin: 0 4px;
            transition: transform 0.2s ease;
        }
        .action-buttons a:hover {
            transform: translateY(-2px);
        }
        /* Footer */
        .footer {
            text-align: center;
            padding: 1.5rem;
            color: var(--text-light);
            font-size: 0.875rem;
            margin-top: 3rem;
            border-top: 1px solid var(--border);
        }
        /* Responsive */
        @media (max-width: 992px) {
            .sidebar { width: 80px; padding: 1rem 0; }
            .sidebar-header h1, .sidebar-item span { display: none; }
            .sidebar-item { justify-content: center; }
            .main-content { margin-left: 80px; }
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
        <a href="${pageContext.request.contextPath}/user" class="sidebar-item">
            <i class="fa-solid fa-users"></i> <span>Người dùng</span>
        </a>
        <a href="${pageContext.request.contextPath}/product" class="sidebar-item">
            <i class="fa-solid fa-boxes-stacked"></i> <span>Sản phẩm</span>
        </a>
        <a href="${pageContext.request.contextPath}/store" class="sidebar-item active">
            <i class="fa-solid fa-store"></i> <span>Cửa hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manager-warehouse" class="sidebar-item">
            <i class="fa-solid fa-warehouse"></i> <span>Quản lý kho</span>
        </a>
        <a href="${pageContext.request.contextPath}/order-report" class="sidebar-item">
            <i class="fa-solid fa-receipt"></i> <span>Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/stock-report" class="sidebar-item">
            <i class="fa-solid fa-chart-column"></i> <span>Báo cáo tồn kho</span>
        </a>
        <form action="${pageContext.request.contextPath}/logout" method="post" class="sidebar-item" style="padding:0;margin:0;">
            <button type="submit" style="all:unset;width:100%;text-align:left;padding:0.75rem 1.5rem;color:#cbd5e1;cursor:pointer;">
                <i class="fa-solid fa-right-from-bracket"></i> <span>Đăng xuất</span>
            </button>
        </form>
    </div>
</div>

<!-- Main Content -->
<div class="main-content">
    <div class="page-header">
        <h2 class="page-title"><i class="fa-solid fa-store me-2"></i>Danh sách Cửa hàng</h2>
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="fas fa-moon"></i>
        </button>
    </div>

    <!-- Alert Messages -->
    <c:if test="${not empty message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-check-circle me-2"></i> ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Table Card -->
    <div class="table-card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <form action="store" method="get" class="d-flex align-items-center">
                <input type="hidden" name="action" value="search"/>
                <select name="keyword" class="form-select form-select-sm me-2" onchange="this.form.submit()">
                    <option value="">-- Lọc theo Tên cửa hàng --</option>
                    <c:forEach var="s" items="${stores}">
                        <option value="${fn:escapeXml(s.storeName)}"
                                ${fn:escapeXml(param.keyword) eq fn:escapeXml(s.storeName) ? 'selected' : ''}>
                            ${s.storeName}
                        </option>
                    </c:forEach>
                </select>
            </form>

            <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#createStoreModal">
                    <i class="fa-solid fa-square-plus me-1"></i>Tạo cửa hàng mới
                </button>
            </c:if>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên cửa hàng</th>
                    <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                        <th>Chủ cửa hàng</th>
                    </c:if>
                    <th>Ngày tạo</th>
                    <th>Trạng thái</th>
                    <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                        <th class="text-center">Hành động</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="s" items="${stores}">
                    <tr>
                        <td>${s.storeId}</td>
                        <td><i class="fa-solid fa-shop me-2 text-primary"></i> ${s.storeName}</td>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <td>${s.ownerName}</td>
                        </c:if>
                        <td>${s.createdAt}</td>
                        <td>
                            <c:choose>
                                <c:when test="${s.status eq 'Active'}">
                                    <span class="status-badge status-active">Đang hoạt động</span>
                                </c:when>
                                <c:when test="${s.status eq 'Suspended'}">
                                    <span class="status-badge status-suspended">Đã tạm ngưng</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">${s.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
                            <td class="text-center action-buttons">
                                <a class="btn btn-sm btn-outline-warning" href="store?action=edit&id=${s.storeId}" title="Chỉnh sửa">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </a>
                                <a class="btn btn-sm btn-outline-danger"
                                   href="store?action=delete&id=${s.storeId}" title="Xóa"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa cửa hàng [${s.storeName}]?');">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                                <c:choose>
                                    <c:when test="${s.status eq 'Active'}">
                                        <a class="btn btn-sm btn-outline-secondary"
                                           href="store?action=suspend&id=${s.storeId}"
                                           onclick="return confirm('Tạm ngưng cửa hàng [${s.storeName}]?');"
                                           title="Tạm ngưng">
                                            <i class="fa-solid fa-pause-circle"></i>
                                        </a>
                                    </c:when>
                                    <c:when test="${s.status eq 'Suspended'}">
                                        <a class="btn btn-sm btn-outline-success"
                                           href="store?action=activate&id=${s.storeId}"
                                           onclick="return confirm('Kích hoạt lại cửa hàng [${s.storeName}]?');"
                                           title="Kích hoạt lại">
                                            <i class="fa-solid fa-play-circle"></i>
                                        </a>
                                    </c:when>
                                </c:choose>
                                <a class="btn btn-sm btn-outline-info"
                                   href="store-report?action=view&storeId=${s.storeId}&storeName=${fn:escapeXml(s.storeName)}"
                                   title="Xem báo cáo">
                                    <i class="fa-solid fa-chart-line"></i>
                                </a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-3">
                <ul class="pagination justify-content-center mb-0">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="store?action=list&page=${i}&keyword=${fn:escapeXml(param.keyword)}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:if>
    </div>

    <!-- MODAL: Tạo cửa hàng mới -->
    <c:if test="${fn:toLowerCase(sessionScope.user.role) eq 'admin'}">
        <div class="modal fade" id="createStoreModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title">
                            <i class="fa-solid fa-square-plus me-2"></i>Tạo cửa hàng mới
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="store" method="post" class="needs-validation" novalidate>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="create"/>
                            <div class="mb-3">
                                <label class="form-label">Tên cửa hàng <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="storeName" required>
                                <div class="invalid-feedback">Vui lòng nhập tên cửa hàng.</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Chọn người bán <span class="text-danger">*</span></label>
                                <select class="form-select" name="userId" required>
                                    <option value="" disabled selected>-- Chọn người bán --</option>
                                    <c:forEach var="u" items="${sellers}">
                                        <option value="${u.id}">${u.fullName} (${u.email})</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn người bán.</div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">
                                <i class="fa-solid fa-save me-1"></i>Tạo
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:if>


</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Dark Mode Toggle
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

    // Form Validation
    (function () {
        'use strict'
        var forms = document.querySelectorAll('.needs-validation')
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })();
</script>
</body>
</html>