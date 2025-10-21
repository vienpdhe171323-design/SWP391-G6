<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Báo cáo doanh thu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* ==================== BASE ==================== */
        * { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary-dark: #1e3a8a;
            --secondary-dark: #1f2937;
            --bg-light: #f3f4f6;
            --text-light: #e5e7eb;
            --text-dark: #1f2937;
        }
        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
            background: var(--bg-light);
            color: var(--text-dark);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        /* ==================== NAVBAR ==================== */
        .navbar {
            background: var(--secondary-dark);
            color: var(--text-light);
            padding: 18px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 {
            font-size: 24px;
            font-weight: 700;
        }
        .navbar a {
            color: var(--text-light);
            text-decoration: none;
            margin-left: 25px;
            font-weight: 500;
            transition: 0.3s;
        }
        .navbar a:hover {
            color: var(--primary-dark);
            border-bottom: 2px solid var(--primary-dark);
        }

        /* ==================== MAIN ==================== */
        .container {
            flex: 1;
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        h2 {
            color: var(--primary-dark);
            margin-bottom: 20px;
            text-align: center;
        }

        /* Form lọc ngày */
        .filter {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
        }

        input[type="date"] {
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            background: #5a67d8;
            color: white;
            padding: 8px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        button:hover { background: #434190; }

        /* Bảng hiển thị */
        .revenue-section {
            display: flex;
            gap: 30px;
            justify-content: space-between;
            flex-wrap: wrap;
        }

        .card {
            flex: 1;
            background: #fafafa;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 3px 6px rgba(0,0,0,0.05);
            min-width: 350px;
        }

        .card h3 {
            color: #2563eb;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 8px 12px;
            border-bottom: 1px solid #ddd;
        }

        th {
            text-align: left;
            color: #374151;
        }

        td {
            color: #111827;
        }

        .total {
            text-align: center;
            font-size: 18px;
            margin: 20px 0;
            color: #059669;
            font-weight: bold;
        }

        /* Biểu đồ */
        .chart-container {
            background: #fff;
            margin-top: 40px;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }

        /* Footer */
        .footer {
            background: var(--secondary-dark);
            color: var(--text-light);
            text-align: center;
            padding: 15px;
            font-size: 14px;
        }

        a.back {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #2563eb;
        }

        a.back:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <!-- HEADER -->
    <div class="navbar">
        <h1><i class="fa-solid fa-chart-line"></i> Báo cáo doanh thu</h1>
        
        <div>
            <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge"></i> Dashboard</a>
            <a href="${pageContext.request.contextPath}/user"><i class="fa-solid fa-users"></i> Người dùng</a>
            <a href="${pageContext.request.contextPath}/product"><i class="fa-solid fa-box"></i> Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/order-report"><i class="fa-solid fa-file-invoice"></i> Đơn hàng</a>
            <a href="#"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="container">
        <h2><i class="fa-solid fa-coins"></i> Báo cáo doanh thu</h2>
        
        <button onclick="window.history.back()" class="btn-back">
    <i class="fa-solid fa-arrow-left"></i> Quay lại
</button>

        <form class="filter" method="get" action="${pageContext.request.contextPath}/admin/revenue-report">
            <label>Từ ngày:</label>
            <input type="date" name="fromDate" value="${fromDate}">
            <label>Đến ngày:</label>
            <input type="date" name="toDate" value="${toDate}">
            <button type="submit"><i class="fa-solid fa-filter"></i> Lọc</button>
        </form>

        <div class="total">
            Tổng doanh thu hệ thống: 
            <span>${totalSystemRevenue} VND</span>
        </div>

        <div class="revenue-section">
            <div class="card">
                <h3>Doanh thu theo cửa hàng</h3>
                <table>
                    <tr><th>Cửa hàng</th><th>Doanh thu (VND)</th></tr>
                    <c:forEach var="entry" items="${revenueByStore}">
                        <tr>
                            <td>${entry.key}</td>
                            <td>${entry.value}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <div class="card">
                <h3>Doanh thu theo tháng</h3>
                <table>
                    <tr><th>Tháng</th><th>Doanh thu (VND)</th></tr>
                    <c:forEach var="entry" items="${revenueByMonth}">
                        <tr>
                            <td>${entry.key}</td>
                            <td>${entry.value}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>

        <!-- BIỂU ĐỒ DOANH THU THEO THÁNG -->
        <div class="chart-container">
            <h3 style="text-align:center; color:#1e3a8a;">📊 Biểu đồ doanh thu theo tháng</h3>
            <canvas id="revenueChart" height="100"></canvas>
        </div>

        <div style="text-align:center;">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back">
                <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
            </a>
        </div>
    </div>

    <!-- FOOTER -->
    <div class="footer">
        © 2025 Online Market Admin | Được phát triển bởi Your Team
    </div>

    <!-- SCRIPT TẠO BIỂU ĐỒ -->
    <script>
        const labels = [
            <c:forEach var="entry" items="${revenueByMonth}" varStatus="loop">
                "${entry.key}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];
        const data = [
            <c:forEach var="entry" items="${revenueByMonth}" varStatus="loop">
                ${entry.value}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const ctx = document.getElementById('revenueChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: data,
                    backgroundColor: '#3b82f6',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: ctx => ctx.formattedValue + " VND"
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { color: '#374151' }
                    },
                    x: {
                        ticks: { color: '#374151' }
                    }
                }
            }
        });
    </script>
</body>
</html>
