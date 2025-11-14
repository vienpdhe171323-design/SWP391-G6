<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo tồn kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        .metric-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .metric-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            border-left: 5px solid;
            transition: var(--transition);
        }
        .metric-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }
        .metric-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }
        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text);
            margin: 0.5rem 0;
        }
        .metric-label {
            font-size: 0.875rem;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Search & Filter */
        .search-card {
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

        /* Table */
        .table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        .table thead {
            background: #eef2ff;
            font-weight: 600;
        }

        /* Chart */
        .chart-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
            margin-top: 1.5rem;
        }
        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 8px;
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
        @media (max-width: 768px) {
            .metric-grid { grid-template-columns: 1fr; }
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
        <a href="${pageContext.request.contextPath}/order-report" class="sidebar-item">
            <i class="fa-solid fa-receipt"></i> <span>Đơn hàng</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/stock-report" class="sidebar-item active">
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
        <h2 class="page-title"><i class="fa-solid fa-warehouse me-2"></i>Báo cáo tồn kho</h2>
        <button class="theme-toggle" onclick="toggleTheme()">
            <i class="fas fa-moon"></i>
        </button>
    </div>

    <!-- Metric Cards -->
    <div class="metric-grid">
        <div class="metric-card" style="border-left-color: #8b5cf6;">
            <div class="metric-icon" style="background: #e9d5ff; color: #7c3aed;">
                <i class="fa-solid fa-boxes-stacked"></i>
            </div>
            <div class="metric-value">${totalProductsInStock}</div>
            <div class="metric-label">Sản phẩm có sẵn</div>
        </div>
        <div class="metric-card" style="border-left-color: #ef4444;">
            <div class="metric-icon" style="background: #fee2e2; color: #dc2626;">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <div class="metric-value">${lowStockCount}</div>
            <div class="metric-label">Sắp hết hàng (< 10)</div>
        </div>
    </div>

    <!-- Search & Filter -->
    <div class="search-card">
        <form action="" method="get">
            <div class="row g-3">
                <div class="col-md-4">
                    <input type="text" class="form-control" name="search" placeholder="Tìm sản phẩm..." value="${search}">
                </div>
                <div class="col-md-3">
                    <select name="storeId" class="form-select">
                        <option value="">-- Cửa hàng --</option>
                        <c:forEach var="s" items="${stores}">
                            <option value="${s.storeId}" ${storeId == s.storeId ? 'selected' : ''}>${s.storeName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="categoryId" class="form-select">
                        <option value="">-- Danh mục --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-grid">
                    <button class="btn btn-primary"><i class="fa fa-filter me-1"></i>Lọc</button>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <a href="?search=${search}&storeId=${storeId}&categoryId=${categoryId}&sort=asc"
                   class="btn btn-outline-secondary sort-btn ${sort=='asc' ? 'active' : ''}">
                    <i class="fa-solid fa-arrow-up-short-wide"></i> Tồn kho tăng
                </a>
                <a href="?search=${search}&storeId=${storeId}&categoryId=${categoryId}&sort=desc"
                   class="btn btn-outline-secondary sort-btn ${sort=='desc' ? 'active' : ''}">
                    <i class="fa-solid fa-arrow-down-wide-short"></i> Tồn kho giảm
                </a>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-responsive">
            <table class="table table-bordered align-middle mb-0">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Sản phẩm</th>
                    <th>Cửa hàng</th>
                    <th>Danh mục</th>
                    <th class="text-center">Tồn kho</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${empty stockReport}">
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">
                            <i class="fa-solid fa-box-open fa-2x mb-2"></i><br>
                            Không có dữ liệu tồn kho
                        </td>
                    </tr>
                </c:if>
                <c:forEach var="p" items="${stockReport}" varStatus="loop">
                    <tr>
                        <td>${(pageIndex - 1) * 10 + loop.index + 1}</td>
                        <td>${p.productName}</td>
                        <td>${p.storeName}</td>
                        <td>${p.categoryName}</td>
                        <td class="text-center fw-bold ${p.currentStock < 10 ? 'text-danger' : 'text-success'}">
                            ${p.currentStock}
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <nav class="mt-3">
            <ul class="pagination justify-content-center mb-0">
                <c:if test="${pageIndex > 1}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${pageIndex-1}&search=${search}&storeId=${storeId}&categoryId=${categoryId}&sort=${sort}">Trước</a>
                    </li>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == pageIndex ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&search=${search}&storeId=${storeId}&categoryId=${categoryId}&sort=${sort}">${i}</a>
                    </li>
                </c:forEach>
                <c:if test="${pageIndex < totalPages}">
                    <li class="page-item">
                        <a class="page-link" href="?page=${pageIndex+1}&search=${search}&storeId=${storeId}&categoryId=${categoryId}&sort=${sort}">Sau</a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </div>

    <!-- Chart -->
    <div class="chart-card">
        <h3 class="chart-title"><i class="fa-solid fa-chart-bar"></i>Biểu đồ tồn kho theo sản phẩm</h3>
        <canvas id="stockChart"></canvas>
    </div>


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
        initChart();
    });

    function initChart() {
        const ctx = document.getElementById('stockChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [
                    <c:forEach var="p" items="${stockReport}">
                        "${p.productName}",
                    </c:forEach>
                ],
                datasets: [{
                    label: 'Tồn kho',
                    data: [
                        <c:forEach var="p" items="${stockReport}">
                            ${p.currentStock},
                        </c:forEach>
                    ],
                    backgroundColor: '#6a11cb',
                    borderRadius: 6,
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    x: { beginAtZero: true, ticks: { stepSize: 10 } }
                }
            }
        });
    }
</script>
</body>
</html>