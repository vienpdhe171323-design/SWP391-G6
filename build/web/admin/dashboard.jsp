<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: #f5f6fa;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background: linear-gradient(90deg, #273c75, #192a56);
            color: white;
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            font-size: 22px;
            margin: 0;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: 500;
        }

        .dashboard-container {
            display: flex;
            justify-content: center;
            gap: 25px;
            flex-wrap: wrap;
            margin: 40px 0;
        }

        .card {
            background-color: #fff;
            width: 240px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 25px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card .icon {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .card .value {
            font-size: 28px;
            color: #2f3640;
            margin-bottom: 8px;
        }

        .card .label {
            color: #718093;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .footer {
            background: #273c75;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 13px;
        }

        /* icon colors */
        .users { color: #00a8ff; }
        .products { color: #9c88ff; }
        .orders { color: #4cd137; }
        .revenue { color: #e1b12c; }
    </style>
</head>
<body>

    <!-- Header -->
    <div class="navbar">
        <h1>🛒 Admin Dashboard</h1>
        <div>
            <a href="#">Users</a>
            <a href="#">Products</a>
            <a href="#">Orders</a>
            <a href="#">Logout</a>
        </div>
    </div>

    <!-- Dashboard cards -->
    <div class="dashboard-container">
        <div class="card">
            <div class="icon users">👥</div>
            <div class="value">${totalUsers}</div>
            <div class="label">Users</div>
        </div>

        <div class="card">
            <div class="icon products">📦</div>
            <div class="value">${totalProducts}</div>
            <div class="label">Products</div>
        </div>

        <div class="card">
            <div class="icon orders">🧾</div>
            <div class="value">${totalOrders}</div>
            <div class="label">Orders</div>
        </div>

        <div class="card">
            <div class="icon revenue">💰</div>
            <div class="value">$${totalRevenue}</div>
            <div class="label">Revenue</div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        © 2025 Online Market Admin | Developed by Your Team
    </div>

</body>
</html>
