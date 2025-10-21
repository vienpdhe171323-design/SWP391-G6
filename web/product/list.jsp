<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sản phẩm - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <style>
        :root {
            --primary-dark: #1e3a8a;
            --secondary-dark: #1f2937;
            --bg-light: #f3f4f6;
            --text-light: #e5e7eb;
            --text-dark: #1f2937;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* HEADER */
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

        /* TABLE STYLES */
        .table td, .table th {
            vertical-align: middle;
        }
        .table thead {
            background-color: var(--primary-dark);
            color: #fff;
        }
        .table-hover tbody tr:hover {
            background-color: #f9fafb;
        }
        .product-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        /* BUTTONS */
        .btn-primary-custom {
            background-color: var(--primary-dark);
            border: none;
        }
        .btn-primary-custom:hover {
            background-color: #334155;
        }

        /* FOOTER */
        .footer {
            background: var(--secondary-dark);
            color: var(--text-light);
            text-align: center;
            padding: 15px;
            font-size: 14px;
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

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="container-fluid">
            <h2 class="text-center mb-4 fw-bold text-primary-dark">📦 Danh sách sản phẩm</h2>

            <div class="text-end mb-3">
                <a href="product?action=add" class="btn btn-success">
                    <i class="fa-solid fa-plus"></i> Thêm sản phẩm mới
                </a>
            </div>

            <!-- Product Table -->
            <div class="table-responsive shadow-sm">
                <table class="table table-bordered table-hover bg-white">
                    <thead class="text-center">
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Cửa hàng</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Trạng thái</th>
                            <th width="180">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td class="text-center">${p.id}</td>
                                <td class="text-center">
                                    <img src="${pageContext.request.contextPath}/${p.imageUrl.replace('img','images')}" 
                                         alt="${p.productName}" class="product-img"
                                         onerror="this.src='${pageContext.request.contextPath}/images/no-image.png';">
                                </td>
                                <td>${p.productName}</td>
                                <td>${p.storeName}</td>
                                <td>${p.categoryName}</td>
                                <td>${p.price}</td>
                                <td>${p.stock}</td>
                                <td>${p.status}</td>
                                <td class="text-center">
                                    <a href="product?action=detail&id=${p.id}" class="btn btn-sm btn-info">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="product?action=edit&id=${p.id}" class="btn btn-sm btn-warning">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="product?action=delete&id=${p.id}" class="btn btn-sm btn-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <nav aria-label="Phân trang" class="mt-4 d-flex justify-content-center">
                <ul class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == pageIndex ? 'active' : ''}">
                            <a class="page-link" href="product?action=list&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </div>
    </div>

    <!-- FOOTER -->
    <div class="footer">
        © 2025 Online Market Admin | Được phát triển bởi Your Team
    </div>

</body>
</html>
