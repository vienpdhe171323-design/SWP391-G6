<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
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

        /* Metric Cards */
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

        .metric-link {
            margin-top: 1rem;
            font-size: 0.875rem;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .metric-link:hover {
            text-decoration: underline;
        }

        /* Chart Cards */
        .chart-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .chart-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 1.5rem;
            box-shadow: var(--shadow);
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

        canvas {
            max-height: 300px;
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
            .chart-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .metric-grid {
                grid-template-columns: 1fr;
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
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-item active">
                <i class="fa-solid fa-gauge-high"></i> <span>Tổng quan</span>
            </a>
            <a href="${pageContext.request.contextPath}/user" class="sidebar-item">
                <i class="fa-solid fa-users"></i> <span>Người dùng</span>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="sidebar-item">
                <i class="fa-solid fa-boxes-stacked"></i> <span>Sản phẩm</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manager-warehouse" class="sidebar-item">
                <i class="fa-solid fa-boxes-stacked"></i> <span>Quản lý kho</span>
            </a>
            <a href="${pageContext.request.contextPath}/order-report" class="sidebar-item">
                <i class="fa-solid fa-receipt"></i> <span>Đơn hàng</span>
            </a>
                      <a href="${pageContext.request.contextPath}/admin/stock-report" class="sidebar-item">
                <i class="fa-solid fa-receipt"></i> <span>Báo cáo tồn kho</span>
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
            <h2 class="page-title">Bảng điều khiển</h2>
            <button class="theme-toggle" onclick="toggleTheme()">
                <i class="fas fa-moon"></i>
            </button>
        </div>

        <!-- Metric Cards -->
        <div class="metric-grid">
            <div class="metric-card" style="border-left-color: #3b82f6;">
                <div class="metric-icon" style="background: #dbeafe; color: #1d4ed8;">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div class="metric-value">${totalUsers}</div>
                <div class="metric-label">Tổng người dùng</div>
                <a href="${pageContext.request.contextPath}/user" class="metric-link">Xem chi tiết</a>
            </div>

            <div class="metric-card" style="border-left-color: #f97316;">
                <div class="metric-icon" style="background: #fed7aa; color: #ea580c;">
                    <i class="fa-solid fa-box-open"></i>
                </div>
                <div class="metric-value">${totalProducts}</div>
                <div class="metric-label">Tổng sản phẩm</div>
                <a href="${pageContext.request.contextPath}/product" class="metric-link">Xem chi tiết</a>
            </div>

            <div class="metric-card" style="border-left-color: #8b5cf6;">
                <div class="metric-icon" style="background: #e9d5ff; color: #7c3aed;">
                    <i class="fa-solid fa-store"></i>
                </div>
                <div class="metric-value">${totalStores}</div>
                <div class="metric-label">Tổng cửa hàng</div>
                <a href="${pageContext.request.contextPath}/store" class="metric-link">Xem chi tiết</a>
            </div>

            <div class="metric-card" style="border-left-color: #10b981;">
                <div class="metric-icon" style="background: #d1fae5; color: #059669;">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <div class="metric-value">${totalOrders}</div>
                <div class="metric-label">Tổng đơn hàng</div>
                <a href="${pageContext.request.contextPath}/order-report" class="metric-link">Xem chi tiết</a>
            </div>

            <div class="metric-card" style="border-left-color: #ef4444;">
                <div class="metric-icon" style="background: #fee2e2; color: #dc2626;">
                    <i class="fa-solid fa-wallet"></i>
                </div>
                <div class="metric-value">$${totalRevenue}</div>
                <div class="metric-label">Tổng doanh thu</div>
                <a href="${pageContext.request.contextPath}/admin/revenue-report" class="metric-link">Xem báo cáo</a>
            </div>
        </div>


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
            initCharts();
        });

        function initCharts() {
            const ctx1 = document.getElementById('revenueChart').getContext('2d');
            new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: ['Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6', 'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'],
                    datasets: [{
                        label: 'Doanh thu ($)',
                        data: [12000, 19000, 15000, 25000, 22000, 30000, 28000, 35000, 32000, 38000, 40000, 45000],
                        borderColor: '#4f46e5',
                        backgroundColor: 'rgba(79, 70, 229, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });

            const ctx2 = document.getElementById('topProductsChart').getContext('2d');
            new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: ['iPhone 15', 'MacBook Pro', 'AirPods', 'Samsung S24', 'Tai nghe Sony'],
                    datasets: [{
                        label: 'Số lượng bán',
                        data: [450, 380, 320, 290, 250],
                        backgroundColor: ['#3b82f6', '#f97316', '#8b5cf6', '#10b981', '#ef4444']
                    }]
                },
                options: { responsive: true, plugins: { legend: { display: false } } }
            });

            const ctx3 = document.getElementById('orderStatusChart').getContext('2d');
            new Chart(ctx3, {
                type: 'doughnut',
                data: {
                    labels: ['Đã giao', 'Đang xử lý', 'Đã hủy', 'Hoàn tiền'],
                    datasets: [{
                        data: [650, 280, 70, 40],
                        backgroundColor: ['#10b981', '#f59e0b', '#ef4444', '#6b7280']
                    }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });

            const ctx4 = document.getElementById('userRoleChart').getContext('2d');
            new Chart(ctx4, {
                type: 'pie',
                data: {
                    labels: ['User', 'Seller', 'Admin'],
                    datasets: [{
                        data: [850, 120, 5],
                        backgroundColor: ['#3b82f6', '#8b5cf6', '#ef4444']
                    }]
                },
                options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
            });
        }
    </script>
</body>
</html>