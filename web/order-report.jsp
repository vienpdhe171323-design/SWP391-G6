<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo lịch sử đơn hàng</title>
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
        .search-card, .table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin-bottom: 1.5rem;
        }
        .sort-btn {
            border-radius: 8px;
            font-size: 0.875rem;
        }
        .table thead {
            background: #eef2ff;
            font-weight: 600;
        }
        .badge {
            padding: 0.4em 0.8em;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.75rem;
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
        <a href="${pageContext.request.contextPath}/admin/manager-warehouse" class="sidebar-item">
            <i class="fa-solid fa-warehouse"></i> <span>Quản lý kho</span>
        </a>
        <a href="${pageContext.request.contextPath}/order-report" class="sidebar-item active">
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
        <h2 class="page-title"><i class="fas fa-history me-2"></i>Báo cáo lịch sử đơn hàng</h2>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary btn-sm" onclick="window.print()">
                <i class="fas fa-print me-1"></i>In
            </button>
            <button class="theme-toggle" onclick="toggleTheme()">
                <i class="fas fa-moon"></i>
            </button>
        </div>
    </div>

    <!-- Search & Filter -->
    <div class="search-card">
        <form method="get" action="${pageContext.request.contextPath}/order-report" class="row g-3">
            <div class="col-md-3">
                <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Tìm theo tên người dùng...">
            </div>
            <div class="col-md-2">
                <select name="status" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Shipped" ${status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                    <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="col-md-2">
                <input type="date" name="fromDate" value="${fromDate}" class="form-control">
            </div>
            <div class="col-md-2">
                <input type="date" name="toDate" value="${toDate}" class="form-control">
            </div>
            <div class="col-md-3 d-grid">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search me-1"></i>Tìm kiếm
                </button>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-responsive">
            <table class="table table-bordered align-middle mb-0">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Người dùng</th>
                    <th>Trạng thái</th>
                    <th>Ngày đặt hàng</th>
                    <th class="text-center">Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>#${o.orderId}</td>
                        <td>${o.userName}</td>
                        <td>
                            <span class="badge
                                ${o.status == 'Completed' ? 'bg-success' :
                                  o.status == 'Pending' ? 'bg-warning text-dark' :
                                  o.status == 'Cancelled' ? 'bg-danger' :
                                  o.status == 'Shipped' ? 'bg-info' : 'bg-secondary'}">
                                ${o.status}
                            </span>
                        </td>
                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td class="text-center">
                            <button class="btn btn-info btn-sm" data-bs-toggle="modal" data-bs-target="#orderDetailModal${o.orderId}">
                                <i class="fas fa-eye"></i>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">
                            <i class="fas fa-box-open fa-2x mb-2"></i><br>
                            Không có đơn hàng nào phù hợp.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <nav class="mt-3">
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- MODALS -->
    <c:forEach var="o" items="${orders}">
        <div class="modal fade" id="orderDetailModal${o.orderId}" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="fas fa-receipt me-2"></i>Chi tiết đơn hàng #${o.orderId}
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <h6 class="text-muted mb-3">Thông tin đơn hàng</h6>
                        <ul class="list-unstyled mb-4">
                            <li><strong>Người dùng:</strong> ${o.userName}</li>
                            <li><strong>Trạng thái:</strong>
                                <span class="badge ${o.status == 'Completed' ? 'bg-success' : o.status == 'Pending' ? 'bg-warning text-dark' : o.status == 'Cancelled' ? 'bg-danger' : o.status == 'Shipped' ? 'bg-info' : 'bg-secondary'}">${o.status}</span>
                            </li>
                            <li><strong>Ngày đặt:</strong> <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></li>
                            <li><strong>Tổng tiền:</strong> <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="$"/></li>
                        </ul>
                        <hr>
                        <h6 class="text-muted mb-3">Sản phẩm</h6>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered">
                                <thead>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Đơn giá</th>
                                    <th>Thành tiền</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${orderItemsMap[o.orderId]}">
                                    <tr>
                                        <td>${item.productName}</td>
                                        <td>${item.quantity}</td>
                                        <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$"/></td>
                                        <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

 
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Dark Mode
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