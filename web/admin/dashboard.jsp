<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"> 

        <style>
            /* ==================================== */
            /* BASE & LAYOUT */
            /* ==================================== */
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            :root {
                --primary-dark: #1e3a8a; /* Xanh đậm chính */
                --secondary-dark: #1f2937; /* Màu nền header/footer */
                --bg-light: #f3f4f6; /* Nền body nhẹ */
                --text-light: #e5e7eb;
                --text-dark: #1f2937;
                --card-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
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
                color: var(--primary-dark);
                border-bottom: 2px solid var(--primary-dark);
            }

            /* MAIN CONTENT */
            .main-content {
                flex-grow: 1;
                padding: 40px 20px;
            }

            .dashboard-container {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                gap: 30px;
                flex-wrap: wrap;
            }

            /* METRIC CARDS */
            .card {
                background-color: #fff;
                flex: 1;
                min-width: 250px;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                padding: 30px;
                text-align: left;
                transition: all 0.3s ease;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                border-left: 5px solid;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: var(--card-shadow);
            }

            .card .header-group {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
            }

            .card .icon {
                font-size: 28px;
                padding: 10px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.1);
            }

            .card .value {
                font-size: 36px;
                font-weight: 700;
                color: var(--text-dark);
                line-height: 1;
            }

            .card .label {
                color: #6b7280;
                font-size: 14px;
                text-transform: uppercase;
                font-weight: 500;
                letter-spacing: 0.5px;
                margin-top: 5px;
            }

            /* Màu sắc cho từng thẻ */
            .card.users {
                border-left-color: #3b82f6;
            }
            .card.products {
                border-left-color: #f97316;
            }
            .card.stores {
                border-left-color: #8b5cf6;
            } /* 💜 mới thêm */
            .card.orders {
                border-left-color: #10b981;
            }
            .card.revenue {
                border-left-color: #ef4444;
            }

            .card.users .icon {
                color: #3b82f6;
                background-color: #eff6ff;
            }
            .card.products .icon {
                color: #f97316;
                background-color: #fff7ed;
            }
            .card.stores .icon {
                color: #8b5cf6;
                background-color: #f3e8ff;
            } /* 💜 mới thêm */
            .card.orders .icon {
                color: #10b981;
                background-color: #ecfdf5;
            }
            .card.revenue .icon {
                color: #ef4444;
                background-color: #fef2f2;
            }

            /* FOOTER */
            .footer {
                background: var(--secondary-dark);
                color: var(--text-light);
                text-align: center;
                padding: 15px;
                font-size: 14px;
            }

            /* Hiển thị số tiền USD theo định dạng tiền tệ */
            .card.revenue .value:before {
                content: '$';
                margin-right: 2px;
                font-weight: 600;
            }

            /* Link “Xem chi tiết” */
            .btn-link {
                display: inline-block;
                margin-top: 12px;
                color: var(--primary-dark);
                font-weight: 600;
                text-decoration: none;
                transition: color 0.3s ease;
                font-size: 14px;
            }

            .btn-link:hover {
                color: #2563eb;
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <div class="navbar">
            <h1><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển Admin</h1>
            <div>
                <a href="user"><i class="fa-solid fa-users"></i> Người dùng</a>
                <a href="product"><i class="fa-solid fa-boxes-stacked"></i> Sản phẩm</a>
                <a href="order-report"><i class="fa-solid fa-receipt"></i> Đơn hàng</a>
                <a href="#"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
        <div class="main-content">
            <div class="dashboard-container">

                <!-- Tổng người dùng -->
                <div class="card users">
                    <div class="header-group">
                        <div class="label">Tổng người dùng</div>
                        <div class="icon"><i class="fa-solid fa-users"></i></div>
                    </div>
                    <div class="value">${totalUsers}</div>
                    <a href="${pageContext.request.contextPath}/user" class="btn-link">👥 Xem chi tiết người dùng</a>

                </div>

                <!-- Tổng sản phẩm -->
                <div class="card products">
                    <div class="header-group">
                        <div class="label">Tổng sản phẩm</div>
                        <div class="icon"><i class="fa-solid fa-box-open"></i></div>
                    </div>
                    <div class="value">${totalProducts}</div>
                    <a href="${pageContext.request.contextPath}/product" class="btn-link">📦 Xem chi tiết sản phẩm</a>
                </div>

                <!-- 💜 Tổng cửa hàng (mới thêm) -->
                <div class="card stores">
                    <div class="header-group">
                        <div class="label">Tổng cửa hàng</div>
                        <div class="icon"><i class="fa-solid fa-store"></i></div>
                    </div>
                    <div class="value">${totalStores}</div>
                    <a href="${pageContext.request.contextPath}/store" class="btn-link">🏪 Xem chi tiết cửa hàng</a>
                </div>

                <!-- Tổng đơn hàng -->
                <div class="card orders">
                    <div class="header-group">
                        <div class="label">Tổng đơn hàng</div>
                        <div class="icon"><i class="fa-solid fa-cart-shopping"></i></div>
                    </div>
                    <div class="value">${totalOrders}</div>
                    <a href="${pageContext.request.contextPath}/order-report" class="btn-link">🧾 Xem chi tiết đơn hàng</a>
                </div>

                <!-- Tổng doanh thu -->
                <div class="card revenue">
                    <div class="header-group">
                        <div class="label">Tổng doanh thu</div>
                        <div class="icon"><i class="fa-solid fa-wallet"></i></div>
                    </div>
                    <div class="value">${totalRevenue}</div>
                    <a href="${pageContext.request.contextPath}/admin/revenue-report" class="btn-link">💰 Xem báo cáo doanh thu</a>

                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <div class="footer">
            © 2025 Online Market Admin | Được phát triển bởi Your Team
        </div>

    </body>
</html>
