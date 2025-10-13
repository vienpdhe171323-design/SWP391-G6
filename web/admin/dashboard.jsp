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
            color: var(--primary-dark);
            border-bottom: 2px solid var(--primary-dark);
        }
        
        /* MAIN CONTENT */
        .main-content {
            flex-grow: 1;
            padding: 40px 20px;
        }
        
        .dashboard-container {
            max-width: 1200px; /* Giới hạn chiều rộng cho màn hình lớn */
            margin: 0 auto;
            display: flex;
            justify-content: space-between; /* Tối ưu hóa khoảng cách */
            gap: 30px;
            flex-wrap: wrap;
        }

        /* METRIC CARDS */
        .card {
            background-color: #fff;
            flex: 1; /* Cho phép thẻ co giãn */
            min-width: 250px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            padding: 30px;
            text-align: left;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            border-left: 5px solid; /* Đường viền màu nổi bật */
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
        .card.users { border-left-color: #3b82f6; }
        .card.products { border-left-color: #f97316; }
        .card.orders { border-left-color: #10b981; }
        .card.revenue { border-left-color: #ef4444; }

        .card.users .icon { color: #3b82f6; background-color: #eff6ff; }
        .card.products .icon { color: #f97316; background-color: #fff7ed; }
        .card.orders .icon { color: #10b981; background-color: #ecfdf5; }
        .card.revenue .icon { color: #ef4444; background-color: #fef2f2; }

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
        <div class="dashboard-container">
            <div class="card users">
                <div class="header-group">
                    <div class="label">Tổng người dùng</div>
                    <div class="icon"><i class="fa-solid fa-users"></i></div>
                </div>
                <div class="value">${totalUsers}</div>
            </div>

            <div class="card products">
                <div class="header-group">
                    <div class="label">Tổng sản phẩm</div>
                    <div class="icon"><i class="fa-solid fa-box-open"></i></div>
                </div>
                <div class="value">${totalProducts}</div>
            </div>

            <div class="card orders">
                <div class="header-group">
                    <div class="label">Tổng đơn hàng</div>
                    <div class="icon"><i class="fa-solid fa-cart-shopping"></i></div>
                </div>
                <div class="value">${totalOrders}</div>
            </div>

            <div class="card revenue">
                <div class="header-group">
                    <div class="label">Tổng doanh thu</div>
                    <div class="icon"><i class="fa-solid fa-wallet"></i></div>
                </div>
                <div class="value">${totalRevenue}</div>
            </div>
        </div>
    </div>

    <div class="footer">
        © 2025 Online Market Admin | Được phát triển bởi Your Team
    </div>

</body>
</html>