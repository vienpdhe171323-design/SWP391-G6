<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Online Market</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #667eea;
                --secondary-color: #764ba2;
                --accent-color: #f093fb;
                --text-dark: #2d3748;
                --text-light: #718096;
                --white: #ffffff;
                --light-bg: #f7fafc;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--light-bg);
            }

            /* Header Styles */
            .main-header {
                background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
                box-shadow: 0 4px 20px rgba(102, 126, 234, 0.15);
                position: sticky;
                top: 0;
                z-index: 1050;
                transition: all 0.3s ease;
            }

            .main-header.scrolled {
                box-shadow: 0 2px 15px rgba(102, 126, 234, 0.2);
                backdrop-filter: blur(10px);
            }

            /* Top Bar */
            .top-bar {
                background: rgba(0, 0, 0, 0.1);
                padding: 0.5rem 0;
                font-size: 0.85rem;
                color: rgba(255, 255, 255, 0.9);
            }

            .top-bar a {
                color: rgba(255, 255, 255, 0.9);
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .top-bar a:hover {
                color: var(--white);
            }

            /* Main Navigation */
            .navbar-custom {
                padding: 1rem 0;
                background: transparent !important;
            }

            .navbar-brand {
                font-weight: 800;
                font-size: 1.8rem;
                color: var(--white) !important;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease;
            }

            .navbar-brand:hover {
                transform: scale(1.05);
                color: var(--white) !important;
            }

            .navbar-brand i {
                background: rgba(255, 255, 255, 0.2);
                padding: 0.5rem;
                border-radius: 12px;
                margin-right: 0.75rem;
            }

            /* Search Box */
            .search-container {
                position: relative;
                max-width: 500px;
                flex: 1;
                margin: 0 2rem;
            }

            .search-form {
                position: relative;
            }

            .search-input {
                width: 100%;
                padding: 0.875rem 1.25rem 0.875rem 3rem;
                border: none;
                border-radius: 25px;
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                font-size: 0.95rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }

            .search-input:focus {
                outline: none;
                background: var(--white);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
            }

            .search-input::placeholder {
                color: var(--text-light);
            }

            .search-icon {
                position: absolute;
                left: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-light);
                font-size: 1rem;
                z-index: 2;
            }

            .search-btn {
                position: absolute;
                right: 0.25rem;
                top: 50%;
                transform: translateY(-50%);
                background: var(--primary-color);
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                color: var(--white);
                transition: all 0.3s ease;
            }

            .search-btn:hover {
                background: var(--secondary-color);
                transform: translateY(-50%) scale(1.05);
            }

            /* User Actions */
            .user-actions {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            /* Cart Button */
            .cart-btn {
                position: relative;
                background: rgba(255, 255, 255, 0.15);
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: var(--white);
                padding: 0.75rem;
                border-radius: 12px;
                font-size: 1.1rem;
                transition: all 0.3s ease;
                text-decoration: none;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 50px;
                height: 50px;
            }

            .cart-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                border-color: rgba(255, 255, 255, 0.5);
                color: var(--white);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            .cart-badge {
                position: absolute;
                top: -8px;
                right: -8px;
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: var(--white);
                border-radius: 50%;
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
                font-weight: 600;
                min-width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(238, 90, 36, 0.3);
                animation: pulse 2s infinite;
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
                100% {
                    transform: scale(1);
                }
            }

            /* User Menu */
            .user-menu {
                position: relative;
            }

            .user-btn {
                background: rgba(255, 255, 255, 0.15);
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: var(--white);
                padding: 0.75rem 1.25rem;
                border-radius: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .user-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                border-color: rgba(255, 255, 255, 0.5);
                color: var(--white);
                transform: translateY(-2px);
            }

            .user-btn i {
                font-size: 1rem;
            }

            /* Auth Buttons */
            .auth-buttons {
                display: flex;
                gap: 0.75rem;
            }

            .btn-outline-light-custom {
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: var(--white);
                padding: 0.75rem 1.25rem;
                border-radius: 12px;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-outline-light-custom:hover {
                background: rgba(255, 255, 255, 0.15);
                border-color: rgba(255, 255, 255, 0.5);
                color: var(--white);
                transform: translateY(-2px);
            }

            .btn-light-custom {
                background: var(--white);
                color: var(--primary-color);
                border: 2px solid var(--white);
                padding: 0.75rem 1.25rem;
                border-radius: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-light-custom:hover {
                background: var(--light-bg);
                color: var(--secondary-color);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            }

            /* Dropdown Menu */
            .dropdown-menu-custom {
                background: var(--white);
                border: none;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                padding: 0.5rem 0;
                margin-top: 0.5rem;
            }

            .dropdown-item-custom {
                padding: 0.75rem 1.25rem;
                color: var(--text-dark);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .dropdown-item-custom:hover {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: var(--white);
                transform: translateX(5px);
            }

            .dropdown-item-custom i {
                width: 20px;
                text-align: center;
            }

            .dropdown-divider {
                margin: 0.5rem 1rem;
                border-color: #e2e8f0;
            }

            /* Categories Navigation */
            .categories-nav {
                background: var(--white);
                border-bottom: 1px solid #e2e8f0;
                padding: 0.75rem 0;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }

            .nav-link-custom {
                color: var(--text-dark);
                padding: 0.75rem 1.25rem;
                border-radius: 10px;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                position: relative;
                overflow: hidden;
            }

            .nav-link-custom:hover {
                color: var(--primary-color);
                background: rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .nav-link-custom.active {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: var(--white);
                font-weight: 600;
            }

            .nav-link-custom i {
                margin-right: 0.5rem;
                transition: transform 0.3s ease;
            }

            .nav-link-custom:hover i {
                transform: scale(1.1);
            }

            /* Mobile Responsive */
            @media (max-width: 768px) {
                .search-container {
                    margin: 1rem 0;
                    order: 3;
                    flex-basis: 100%;
                }

                .user-actions {
                    gap: 0.5rem;
                }

                .auth-buttons {
                    gap: 0.5rem;
                }

                .btn-outline-light-custom,
                .btn-light-custom {
                    padding: 0.5rem 1rem;
                    font-size: 0.9rem;
                }

                .categories-nav .nav-link-custom {
                    padding: 0.5rem 0.75rem;
                    font-size: 0.9rem;
                }

                .top-bar {
                    text-align: center;
                }
            }

            /* Mobile Toggle */
            .navbar-toggler {
                border: none;
                padding: 0.5rem;
                color: var(--white);
                font-size: 1.5rem;
            }

            .navbar-toggler:focus {
                box-shadow: none;
            }

            /* Smooth Scroll */
            html {
                scroll-behavior: smooth;
            }
        </style>
    </head>
    <body>
       

        <!-- Main Header -->
        <header class="main-header">
            <nav class="navbar navbar-expand-lg navbar-custom">
                <div class="container">
                    <!-- Logo -->
                    <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-shopping-bag"></i>Online Market
                    </a>

                    <!-- Mobile Toggle -->
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                        <i class="fas fa-bars"></i>
                    </button>

                    <div class="collapse navbar-collapse" id="navbarContent">
                        <!-- Search Box -->
                        <div class="search-container">
                            <form action="${pageContext.request.contextPath}/home" method="GET" class="search-form">
                                <i class="fas fa-search search-icon"></i>
                                <input class="search-input" type="search" name="keyword" 
                                       placeholder="Tìm kiếm sản phẩm, thương hiệu..." value="${param.keyword}">
                                <button class="search-btn" type="submit">
                                    <i class="fas fa-arrow-right"></i>
                                </button>
                            </form>
                        </div>

                        <!-- User Actions -->
                        <div class="user-actions">
                            <!-- Cart -->
                            <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge">
                                    <c:choose>
                                        <c:when test="${sessionScope.cartCount != null}">
                                            ${sessionScope.cartCount}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>

                            <!-- User Menu -->
                            <div class="dropdown user-menu">
                                <c:choose>
                                    <c:when test="${sessionScope.user != null}">
                                        <button class="user-btn dropdown-toggle" type="button" 
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-user"></i>
                                            <span class="d-none d-md-inline">${sessionScope.user.fullName}</span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom">
                                            <li><a class="dropdown-item dropdown-item-custom" 
                                                   href="${pageContext.request.contextPath}/profile">
                                                    <i class="fas fa-user-circle"></i>Thông tin cá nhân</a></li>
                                            <li><a class="dropdown-item dropdown-item-custom" 
                                                   href="${pageContext.request.contextPath}/orders">
                                                    <i class="fas fa-shopping-bag"></i>Đơn hàng của tôi</a></li>
                                            <li><a class="dropdown-item dropdown-item-custom" 
                                                   href="${pageContext.request.contextPath}/wishlist">
                                                    <i class="fas fa-heart"></i>Sản phẩm yêu thích</a></li>
                                            <li><a class="dropdown-item dropdown-item-custom" 
                                                   href="${pageContext.request.contextPath}/notifications">
                                                    <i class="fas fa-bell"></i>Thông báo</a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item dropdown-item-custom" 
                                                   href="${pageContext.request.contextPath}/logout">
                                                    <i class="fas fa-sign-out-alt"></i>Đăng xuất</a></li>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="auth-buttons">
                                            <a href="${pageContext.request.contextPath}/login" class="btn-outline-light-custom">
                                                <i class="fas fa-sign-in-alt"></i>
                                                <span class="d-none d-md-inline">Đăng nhập</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/register" class="btn-light-custom">
                                                <i class="fas fa-user-plus"></i>
                                                <span class="d-none d-md-inline">Đăng ký</span>
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </header>

        <!-- Categories Navigation -->
        <nav class="categories-nav">
            <div class="container">
                <div class="d-flex flex-wrap justify-content-center justify-content-md-start gap-2">
                    <a class="nav-link-custom ${empty param.category ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i>Tất cả sản phẩm
                    </a>
                    <a class="nav-link-custom ${param.category == 'electronics' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=electronics">
                        <i class="fas fa-laptop"></i>Điện tử
                    </a>
                    <a class="nav-link-custom ${param.category == 'clothing' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=clothing">
                        <i class="fas fa-tshirt"></i>Thời trang
                    </a>
                    <a class="nav-link-custom ${param.category == 'books' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=books">
                        <i class="fas fa-book"></i>Sách
                    </a>
                    <a class="nav-link-custom ${param.category == 'home' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=home">
                        <i class="fas fa-couch"></i>Gia dụng
                    </a>
                    <a class="nav-link-custom ${param.category == 'sports' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=sports">
                        <i class="fas fa-dumbbell"></i>Thể thao
                    </a>
                    <a class="nav-link-custom ${param.category == 'beauty' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/home?category=beauty">
                        <i class="fas fa-spa"></i>Làm đẹp
                    </a>
                </div>
            </div>
        </nav>

        <!-- Main Hero & Content CSS -->
        <style>
            /* Additional styles for main content */
            .hero-section {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 60px 0;
                margin-top: 0;
            }

            /* Product Cards */
            .product-card {
                border: none;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                transition: all 0.4s ease;
                height: 100%;
                border-radius: 15px;
                overflow: hidden;
                background: var(--white);
            }

            .product-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 35px rgba(102, 126, 234, 0.15);
            }

            .product-img {
                height: 200px;
                object-fit: cover;
                width: 100%;
                transition: transform 0.4s ease;
            }

            .product-card:hover .product-img {
                transform: scale(1.05);
            }

            .price-original {
                text-decoration: line-through;
                color: var(--text-light);
                font-size: 0.9em;
            }

            .price-current {
                color: #e53e3e;
                font-weight: bold;
                font-size: 1.2em;
            }

            .discount-badge {
                position: absolute;
                top: 15px;
                right: 15px;
                background: linear-gradient(135deg, #ff6b6b, #ee5a24);
                color: white;
                padding: 8px 12px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: 600;
                z-index: 2;
                box-shadow: 0 2px 8px rgba(238, 90, 36, 0.3);
            }

            /* Filter Sidebar */
            .filter-sidebar {
                background: var(--white);
                padding: 2rem;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
                position: sticky;
                top: calc(180px + 2rem); /* Header height + margin */
                max-height: calc(100vh - 200px);
                overflow-y: auto;
            }

            .filter-sidebar h5 {
                color: var(--text-dark);
                font-weight: 700;
                margin-bottom: 1.5rem;
                padding-bottom: 0.75rem;
                border-bottom: 2px solid #e2e8f0;
            }

            .filter-sidebar h6 {
                color: var(--text-dark);
                font-weight: 600;
                margin-bottom: 1rem;
            }

            .form-check {
                margin-bottom: 0.75rem;
            }

            .form-check-label {
                color: var(--text-dark);
                font-weight: 500;
                cursor: pointer;
                transition: color 0.3s ease;
            }

            .form-check-input:checked ~ .form-check-label {
                color: var(--primary-color);
            }

            .form-check-input {
                border: 2px solid #e2e8f0;
                transition: all 0.3s ease;
            }

            .form-check-input:checked {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            /* Pagination */
            .pagination-custom .page-link {
                border-radius: 50%;
                margin: 0 0.25rem;
                width: 45px;
                height: 45px;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 2px solid #e2e8f0;
                color: var(--text-dark);
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .pagination-custom .page-link:hover {
                background: var(--primary-color);
                border-color: var(--primary-color);
                color: var(--white);
                transform: translateY(-2px);
            }

            .pagination-custom .page-item.active .page-link {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                border-color: var(--primary-color);
            }

            /* Sort & Filter Controls */
            .form-select {
                border: 2px solid #e2e8f0;
                border-radius: 10px;
                padding: 0.75rem;
                font-weight: 500;
                color: var(--text-dark);
                transition: all 0.3s ease;
            }

            .form-select:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            /* Content spacing */
            .main-content-wrapper {
                padding-top: 2rem;
                min-height: 100vh;
            }

            /* Button styles for filters */
            .btn-outline-secondary {
                border: 2px solid #e2e8f0;
                color: var(--text-dark);
                font-weight: 500;
                border-radius: 10px;
                padding: 0.75rem 1.25rem;
                transition: all 0.3s ease;
            }

            .btn-outline-secondary:hover {
                background: var(--primary-color);
                border-color: var(--primary-color);
                color: var(--white);
            }

            /* Mobile adjustments */
            @media (max-width: 768px) {
                .filter-sidebar {
                    position: static;
                    margin-bottom: 2rem;
                }
            }

            /* Custom scrollbar for sidebar */
            .filter-sidebar::-webkit-scrollbar {
                width: 6px;
            }

            .filter-sidebar::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 10px;
            }

            .filter-sidebar::-webkit-scrollbar-thumb {
                background: var(--primary-color);
                border-radius: 10px;
            }

            .filter-sidebar::-webkit-scrollbar-thumb:hover {
                background: var(--secondary-color);
            }
        </style>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>

        <!-- Header Scroll Effect -->
        <script>
            // Header scroll effect
            window.addEventListener('scroll', function () {
                const header = document.querySelector('.main-header');
                if (window.scrollY > 100) {
                    header.classList.add('scrolled');
                } else {
                    header.classList.remove('scrolled');
                }
            });

            // Search form enhancement
            document.querySelector('.search-input').addEventListener('focus', function () {
                this.parentElement.style.transform = 'scale(1.02)';
            });

            document.querySelector('.search-input').addEventListener('blur', function () {
                this.parentElement.style.transform = 'scale(1)';
            });


        </script>
