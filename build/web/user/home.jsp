<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ - Cửa hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary: #6f42c1;
            --primary-light: #d8c9f2;
            --primary-dark: #5a32a3;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-800: #343a40;
            --shadow-sm: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            --shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            --radius: 12px;
            --transition: all 0.3s ease;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(to bottom, #f5f3ff, #ffffff);
            min-height: 100vh;
        }

        /* Navbar */
        .navbar {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark)) !important;
            box-shadow: var(--shadow);
            padding: 0.75rem 0;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            letter-spacing: 0.5px;
        }

        .nav-link {
            font-weight: 500;
            transition: var(--transition);
            position: relative;
        }

        .nav-link:hover {
            color: #fff !important;
        }

        .nav-link.active {
            font-weight: 600;
            color: #fff !important;
        }

        .badge-cart {
            font-size: 0.7rem;
            vertical-align: top;
            margin-left: 4px;
        }

        /* Search Bar */
        .search-container {
            max-width: 500px;
            margin: 0 auto 2rem;
        }

        .search-input {
            border: 2px solid transparent;
            border-radius: 50px 0 0 50px;
            padding: 0.75rem 1.25rem;
            font-size: 1rem;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

        .search-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(111, 66, 193, 0.25);
        }

        .search-btn {
            border-radius: 0 50px 50px 0;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            box-shadow: var(--shadow-sm);
        }

        /* Sidebar */
        .sidebar-card {
            border: none;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            background: #fff;
        }

        .sidebar-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 1rem 1.25rem;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .list-group-item {
            border: none;
            padding: 0.75rem 1.25rem;
            transition: var(--transition);
        }

        .list-group-item:hover {
            background-color: var(--primary-light);
            color: var(--primary-dark);
        }

        .category-link {
            display: flex;
            align-items: center;
            color: var(--gray-800);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .category-link i {
            width: 20px;
            font-size: 0.9rem;
            margin-right: 8px;
        }

        .category-link.active,
        .category-link:hover {
            color: var(--primary);
            font-weight: 600;
        }

        /* Product Card */
        .product-card {
            border: none;
            border-radius: var(--radius);
            overflow: hidden;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
            background: #fff;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow);
        }

        .product-img {
            height: 200px;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .product-card:hover .product-img {
            transform: scale(1.05);
        }

        .product-body {
            padding: 1.25rem;
        }

        .product-name {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #d32f2f;
        }

        .store-name {
            font-size: 0.875rem;
            color: #666;
            margin-bottom: 0.75rem;
        }

        .btn-view {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border: 1px solid var(--primary);
            color: var(--primary);
            border-radius: 8px;
            transition: var(--transition);
        }

        .btn-view:hover {
            background-color: var(--primary);
            color: white;
        }

        .btn-add-cart {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 8px;
            transition: var(--transition);
        }

        .btn-add-cart:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
        }

        /* Store Highlight */
        .store-highlight {
            background: linear-gradient(135deg, #fff8e1, #fff3e0);
            border-left: 4px solid #ffb300;
        }

        .store-highlight .list-group-item {
            background: transparent;
            border-bottom: 1px dashed #ddd;
        }

        /* Pagination */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 4px;
            color: var(--primary);
            font-weight: 500;
            border: 1px solid #ddd;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            color: white;
        }

        /* Footer */
        .footer {
            background: #1a1a2e;
            color: #ccc;
            margin-top: auto;
        }

        .footer h5 {
            color: #fff;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer a {
            color: #aaa;
            text-decoration: none;
            transition: var(--transition);
            font-size: 0.9rem;
        }

        .footer a:hover {
            color: var(--primary);
        }

        .footer .form-control {
            border-radius: 50px;
            padding: 0.75rem 1rem;
            font-size: 0.9rem;
        }

        .footer .btn {
            border-radius: 50px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
        }

        .footer-divider {
            border-top: 1px solid #333;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow">
        <div class="container">
            <a class="navbar-brand" href="home">🛒 Online Market</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link active" href="home">Trang chủ</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Đăng nhập</a></li>
                    <li class="nav-item"><a class="nav-link" href="order">Lịch sử mua</a></li>
                    <li class="nav-item"><a class="nav-link" href="profile">Hồ sơ</a></li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">
                            <i class="fas fa-shopping-cart"></i> Giỏ hàng
                            <c:if test="${sessionScope.cart != null}">
                                <span class="badge bg-danger badge-cart">${sessionScope.cart.totalQuantity}</span>
                            </c:if>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Flash Messages -->
    <div class="container mt-4">
        <c:if test="${sessionScope.flash_success != null}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm">
                ${sessionScope.flash_success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flash_success" scope="session"/>
        </c:if>
        <c:if test="${sessionScope.flash_error != null}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm">
                ${sessionScope.flash_error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="flash_error" scope="session"/>
        </c:if>
    </div>

    <!-- Main Content -->
    <div class="container mt-4 flex-grow-1">
        <h1 class="text-center mb-4 text-primary fw-bold" style="font-size: 2.2rem;">
            Sản phẩm nổi bật
        </h1>

        <!-- Search Bar -->
        <form action="home" method="get" class="search-container">
            <div class="input-group">
                <input type="text" name="keyword" value="${param.keyword}" class="form-control search-input" placeholder="🔍 Tìm kiếm sản phẩm...">
                <button class="btn btn-primary search-btn" type="submit">
                    <i class="fas fa-search"></i>
                </button>
            </div>
        </form>

        <div class="row g-4">
            <!-- Sidebar -->
            <div class="col-lg-3">
                <!-- Categories -->
                <div class="sidebar-card mb-4">
                    <div class="sidebar-header">
                        <i class="fas fa-list me-2"></i> Danh mục
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <a href="home" class="category-link ${selectedCategoryId == null ? 'active' : ''}">
                                <i class="fas fa-grip-horizontal"></i> Tất cả
                            </a>
                        </li>
                        <c:forEach var="cat" items="${categories}">
                            <li class="list-group-item">
                                <a href="home?categoryId=${cat.categoryId}" class="category-link ${cat.categoryId == selectedCategoryId ? 'active' : ''}">
                                    <i class="fas fa-tag"></i> ${cat.categoryName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>

                <!-- Top Stores -->
                <div class="sidebar-card store-highlight">
                    <div class="sidebar-header" style="background: #ffb300; color: #333;">
                        <i class="fas fa-store me-2"></i> Cửa hàng nổi bật
                    </div>
                    <ul class="list-group list-group-flush">
                        <c:forEach var="s" items="${topStores}">
                            <li class="list-group-item d-flex justify-content-between align-items-center small">
                                <span>${s.storeName}</span>
                                <span class="text-muted">${s.createdAt}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                    <c:forEach var="p" items="${products}">
                        <div class="col">
                            <div class="product-card">
                                <img src="${p.imageUrl}" class="product-img w-100" alt="${p.productName}">
                                <div class="product-body">
                                    <h6 class="product-name">${p.productName}</h6>
                                    <div class="store-name">
                                        <i class="fas fa-store-alt"></i> ${p.storeName}
                                    </div>
                                    <div class="product-price">${p.price}₫</div>
                                    <div class="d-flex gap-2 mt-3">
                                        <a href="product?action=detail&id=${p.id}" class="btn btn-view flex-fill">
                                            Xem
                                        </a>
                                        <form action="cart" method="post" style="display: inline;" class="flex-fill">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-add-cart w-100">
                                                <i class="fas fa-cart-plus"></i> Thêm
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <nav class="mt-5">
                    <ul class="pagination justify-content-center">
                        <c:choose>
                            <c:when test="${pageIndex > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="home?page=${pageIndex - 1}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>">« Trước</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">« Trước</span></li>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == pageIndex ? 'active' : ''}">
                                <a class="page-link" href="home?page=${i}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>">${i}</a>
                            </li>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${pageIndex < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="home?page=${pageIndex + 1}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>">Sau »</a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled"><span class="page-link">Sau »</span></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer py-5">
        <div class="container">
            <div class="row g-4 footer-divider pb-4">
                <div class="col-lg-4">
                    <h5>🛒 Online Market</h5>
                    <p class="small">Nền tảng thương mại điện tử hàng đầu, mang đến trải nghiệm mua sắm tiện lợi và an toàn.</p>
                    <div class="d-flex gap-3">
                        <a href="#" class="text-white"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="col-6 col-md-3 col-lg-2">
                    <h5>Liên kết</h5>
                    <ul class="list-unstyled small">
                        <li><a href="#">Trang chủ</a></li>
                        <li><a href="#">Sản phẩm</a></li>
                        <li><a href="#">Khuyến mãi</a></li>
                        <li><a href="#">Liên hệ</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 col-lg-2">
                    <h5>Hỗ trợ</h5>
                    <ul class="list-unstyled small">
                        <li><a href="#">Trợ giúp</a></li>
                        <li><a href="#">Vận chuyển</a></li>
                        <li><a href="#">Đổi trả</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h5>Nhận tin ưu đãi</h5>
                    <form class="d-flex">
                        <input type="email" class="form-control me-2" placeholder="Email của bạn">
                        <button class="btn btn-primary" type="submit">Đăng ký</button>
                    </form>
                </div>
            </div>
            <div class="text-center small pt-3 footer-divider">
                © 2025 Online Market. All rights reserved.
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>