<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${store.storeName} - Online Market</title>

    <!-- CSS -->
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
        * { font-family: 'Inter', sans-serif; }

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
        .navbar-brand { font-weight: 700; font-size: 1.5rem; }
        .nav-link { font-weight: 500; transition: var(--transition); }
        .nav-link:hover, .nav-link.active { color: #fff !important; font-weight: 600; }
        .badge-cart { font-size: 0.7rem; vertical-align: top; margin-left: 4px; }

        /* Store Header */
        .store-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-radius: var(--radius);
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
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
        }

        /* Product Card */
        .product-card {
            border: none;
            border-radius: var(--radius);
            background: #fff;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow);
        }
        .product-img {
            height: 200px;
            object-fit: cover;
        }
        .btn-add-cart {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border: none;
            color: white;
        }

        .no-products {
            text-align: center;
            padding: 3rem;
            color: #8b7bb5;
        }

        .footer {
            background: #1a1a2e;
            color: #ccc;
            margin-top: 3rem;
        }
    </style>
</head>

<body class="d-flex flex-column min-vh-100">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark shadow">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">Online Market</a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div id="navbarNav" class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center">

                <!-- Home -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                </li>

                <!-- User -->
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-1"></i>
                                Chào, <strong>${sessionScope.user.fullName}</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/order">Lịch sử mua</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <form action="${pageContext.request.contextPath}/logout" method="post">
                                        <button class="dropdown-item text-danger">Đăng xuất</button>
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

                <!-- Cart -->
                <li class="nav-item">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart.jsp">
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
        <p>Quản lý bán hàng chuyên nghiệp</p>

        <div class="store-info-grid">
            <div class="info-item"><i class="fas fa-user"></i> Chủ shop: ${store.ownerName}</div>
            <div class="info-item"><i class="fas fa-calendar-alt"></i> Thành lập: ${store.createdAt}</div>
            <div class="info-item">
                <i class="fas fa-circle ${store.status == 'Hoạt động' ? 'text-success' : 'text-warning'}"></i>
                Trạng thái:
                <span class="badge bg-${store.status == 'Hoạt động' ? 'success' : 'warning'}">${store.status}</span>
            </div>
            <div class="info-item"><i class="fas fa-box"></i> Sản phẩm: ${products.size()}</div>
        </div>

        <!-- FOLLOW BUTTON -->
        <c:if test="${sessionScope.user != null}">
            <div class="mt-3">
                <c:choose>
                    <c:when test="${isFollowing}">
                        <a href="${pageContext.request.contextPath}/follow-store?action=unfollow&storeId=${store.storeId}"
                           class="btn btn-danger px-4">
                            <i class="fas fa-heart-broken me-2"></i> Bỏ theo dõi
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/follow-store?action=follow&storeId=${store.storeId}"
                           class="btn btn-primary px-4">
                            <i class="fas fa-heart me-2"></i> Theo dõi cửa hàng
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </div>

    <!-- Products -->
    <h3 class="mb-4"><i class="fas fa-th-large text-primary"></i> Sản phẩm của cửa hàng</h3>

    <c:choose>
        <c:when test="${not empty products}">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <c:forEach var="p" items="${products}">
                    <div class="col">
                        <div class="product-card">
                            <img src="${p.imageUrl}" class="product-img w-100"
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
                                        <button class="btn btn-add-cart w-100">Thêm</button>
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
<footer class="footer py-5">
    <div class="container text-center">
        © 2025 Online Market. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
