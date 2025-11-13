<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${store.storeName} - Online Market</title>
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

            /* Navbar - Giống home.jsp */
            .navbar {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark)) !important;
                box-shadow: var(--shadow);
                padding: 0.75rem 0;
            }
            .navbar-brand {
                font-weight: 700;
                font-size: 1.5rem;
            }
            .nav-link {
                font-weight: 500;
                transition: var(--transition);
            }
            .nav-link:hover, .nav-link.active {
                color: #fff !important;
                font-weight: 600;
            }
            .badge-cart {
                font-size: 0.7rem;
                vertical-align: top;
                margin-left: 4px;
            }

            /* Store Header */
            .store-header {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
                border-radius: var(--radius);
                padding: 2rem;
                margin-bottom: 2rem;
                box-shadow: var(--shadow);
                text-align: center;
            }
            .store-header h1 {
                font-weight: 700;
                margin-bottom: 0.5rem;
                font-size: 2.2rem;
            }
            .store-info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-top: 1rem;
            }
            .info-item {
                display: flex;
                align-items: center;
                background: rgba(255,255,255,0.15);
                padding: 0.75rem 1rem;
                border-radius: 8px;
                font-size: 0.95rem;
            }
            .info-item i {
                margin-right: 0.75rem;
                font-size: 1.1rem;
            }

            /* Product Card - HOÀN TOÀN GIỐNG home.jsp */
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
                font-size: 1.05rem;
            }
            .product-price {
                font-size: 1.25rem;
                font-weight: 700;
                color: #d32f2f;
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

            /* No products */
            .no-products {
                text-align: center;
                padding: 3rem;
                color: #8b7bb5;
                font-style: italic;
            }
            .no-products i {
                font-size: 3rem;
                margin-bottom: 1rem;
                color: #d3cce3;
            }

            /* Footer */
            .footer {
                background: #1a1a2e;
                color: #ccc;
                margin-top: 3rem;
            }
            .footer a {
                color: #aaa;
                text-decoration: none;
            }
            .footer a:hover {
                color: var(--primary);
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">

        <!-- Navbar - Giống home.jsp -->
        <nav class="navbar navbar-expand-lg navbar-dark shadow">
            <div class="container">
                <a class="navbar-brand" href="home">Online Market</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                        </li>
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-user-circle me-1"></i>
                                        Chào, <strong>${sessionScope.user.fullName != null ? sessionScope.user.fullName : sessionScope.user.username}</strong>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="profile">Hồ sơ</a></li>
                                        <li><a class="dropdown-item" href="order">Lịch sử mua</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/logout" method="post" class="d-inline">
                                                <button type="submit" class="dropdown-item text-danger">Đăng xuất</button>
                                            </form>
                                        </li>
                                    </ul>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="nav-item">
<a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                        <li class="nav-item">
                            <a class="nav-link position-relative" href="cart.jsp">
                                Giỏ hàng
                                <c:if test="${sessionScope.cart != null && sessionScope.cart.totalQuantity > 0}">
                                    <span class="badge bg-danger badge-cart">${sessionScope.cart.totalQuantity}</span>
                                </c:if>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Store Header -->
        <div class="container mt-4">
            <div class="store-header">
                <h1><i class="fas fa-store me-2"></i> ${store.storeName}</h1>
                <p class="mb-0 opacity-90">Quản lý bán hàng chuyên nghiệp</p>
                <div class="store-info-grid mt-3">
                    <div class="info-item">
                        <i class="fas fa-user"></i>
                        <div>
                            <strong>Chủ shop:</strong> ${store.ownerName}
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-calendar-alt"></i>
                        <div>
                            <strong>Thành lập:</strong> ${store.createdAt}
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-circle ${store.status == 'Hoạt động' ? 'text-success' : 'text-warning'}"></i>
                        <div>
                            <strong>Trạng thái:</strong>
                            <span class="badge bg-${store.status == 'Hoạt động' ? 'success' : 'warning'}">${store.status}</span>
                        </div>
                    </div>
                    <div class="info-item">
                        <i class="fas fa-box"></i>
                        <div>
                            <strong>Sản phẩm:</strong> ${products.size()} sản phẩm
                        </div>
                    </div>
                </div>
            </div>

            <!-- Product Grid - GIỐNG HỆT home.jsp -->
            <h3 class="mb-4"><i class="fas fa-th-large text-primary"></i> Sản phẩm của cửa hàng</h3>

            <c:choose>
                <c:when test="${not empty products}">
                    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                        <c:forEach var="p" items="${products}">
                            <div class="col">
                                <div class="product-card">
                                    <img src="${p.imageUrl}" class="product-img w-100" alt="${p.productName}"
                                         onerror="this.src='https://via.placeholder.com/300x200?text=No+Image'">
                                    <div class="product-body">
                                        <h6 class="product-name">${p.productName}</h6>
                                        <div class="product-price">${p.price}₫</div>
                                        <div class="d-flex gap-2 mt-3">
                                            <a href="${pageContext.request.contextPath}/product?action=detail&id=${p.id}" 
                                               class="btn btn-view flex-fill">
                                                Xem
                                            </a>

<form action="${pageContext.request.contextPath}/cart" method="post" class="flex-fill">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="productId" value="${p.id}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn btn-add-cart w-100">
                                                    Thêm
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <i class="fas fa-inbox"></i>
                        <p>Cửa hàng chưa có sản phẩm nào.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Footer -->
        <footer class="footer py-5 mt-5">
            <div class="container text-center">
                <p class="mb-0">© 2025 Online Market. All rights reserved.</p>
            </div>
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>