<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:url var="logoutUrl" value="/logout"/>

<aside class="sidebar shadow-sm" id="sidebar">
    <div class="sidebar-header p-4 border-bottom">
        <div class="d-flex align-items-center gap-3">
            <div class="logo-icon bg-primary text-white rounded-circle d-flex align-items-center justify-content-center"
                 style="width: 40px; height: 40px; font-weight: bold;">
                S
            </div>
            <div>
                <h5 class="mb-0 fw-bold text-dark">Seller Panel</h5>
                <small class="text-muted">Quản lý cửa hàng</small>
            </div>
        </div>
    </div>

    <nav class="sidebar-menu mt-3">
        <!-- Dashboard -->
        <a href="${pageContext.request.contextPath}/seller/dashboard"
           class="menu-item d-flex align-items-center gap-3 px-4 py-3 ${uri.contains('dashboard') ? 'active' : ''}">
            <div class="menu-icon">
                <i class="fas fa-tachometer-alt"></i>
            </div>
            <span class="menu-text">Bảng điều khiển</span>
        </a>

        <!-- Đơn hàng chờ ship -->
        <a href="${pageContext.request.contextPath}/seller/orders"
           class="menu-item d-flex align-items-center gap-3 px-4 py-3 ${uri.contains('orders') && !uri.contains('orders22') ? 'active' : ''}">
            <div class="menu-icon">
                <i class="fas fa-shipping-fast"></i>
            </div>
            <span class="menu-text">Tạo vận đơn</span>
            <c:if test="${sessionScope.pendingShipmentCount > 0}">
                <span class="badge bg-danger ms-auto rounded-pill">${sessionScope.pendingShipmentCount}</span>
            </c:if>
        </a>

        <!-- Tổng đơn hàng -->
        <a href="${pageContext.request.contextPath}/seller/orders22"
           class="menu-item d-flex align-items-center gap-3 px-4 py-3 ${uri.contains('orders22') ? 'active' : ''}">
            <div class="menu-icon">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <span class="menu-text">Tất cả đơn hàng</span>
        </a>



        <!-- Divider -->
        <hr class="mx-4 my-2 text-secondary">

        <!-- Đăng xuất -->
        <a href="${logoutUrl}"
           class="menu-item d-flex align-items-center gap-3 px-4 py-3 text-danger">
            <div class="menu-icon">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <span class="menu-text">Đăng xuất</span>
        </a>
    </nav>

    <!-- Toggle Button (Mobile) -->
    <button class="sidebar-toggle btn btn-link text-muted position-absolute top-0 end-0 mt-3 me-3 d-md-none"
            onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
</aside>

<style>
    .sidebar {
        width: 260px;
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        background: white;
        z-index: 1000;
        transition: all 0.3s ease;
        overflow-y: auto;
        border-right: 1px solid #e0e0e0;
    }

    .sidebar.collapsed {
        transform: translateX(-100%);
    }

    .sidebar.show {
        transform: translateX(0);
    }

    .sidebar-header {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .logo-icon {
        font-size: 1.1rem;
    }

    .menu-item {
        color: #495057;
        text-decoration: none;
        border-left: 3px solid transparent;
        transition: all 0.2s;
        position: relative;
    }

    .menu-item:hover {
        background: #f8f9fa;
        color: #0d6efd;
        border-left-color: #0d6efd;
    }

    .menu-item.active {
        background: #e7f1ff;
        color: #0d6efd;
        font-weight: 600;
        border-left-color: #0d6efd;
    }

    .menu-item.active .menu-icon i {
        color: #0d6efd;
    }

    .menu-icon {
        width: 36px;
        height: 36px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f1f3f5;
        font-size: 1.1rem;
        color: #6c757d;
        transition: all 0.2s;
    }

    .menu-item:hover .menu-icon,
    .menu-item.active .menu-icon {
        background: #0d6efd;
        color: white;
    }

    .menu-text {
        font-size: 0.95rem;
        font-weight: 500;
    }

    .sidebar-toggle {
        z-index: 1001;
        background: rgba(255,255,255,0.9);
        backdrop-filter: blur(4px);
        border-radius: 50%;
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    /* Main content điều chỉnh khi sidebar collapsed */
    #mainContent {
        margin-left: 260px;
        transition: margin-left 0.3s ease;
    }

    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
        }
        .sidebar.show {
            transform: translateX(0);
        }
        #mainContent {
            margin-left: 0 !important;
        }
        .sidebar-toggle {
            display: flex !important;
        }
    }

    @media (min-width: 769px) {
        .sidebar-toggle {
            display: none;
        }
    }
</style>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        sidebar.classList.toggle('collapsed');
        sidebar.classList.toggle('show');
        mainContent.classList.toggle('expanded');
    }

    // Tự động ẩn sidebar trên mobile khi resize
    window.addEventListener('resize', function () {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');
        if (window.innerWidth > 768) {
            sidebar.classList.remove('show', 'collapsed');
            mainContent.classList.remove('expanded');
        } else {
            sidebar.classList.add('collapsed');
            mainContent.classList.add('expanded');
        }
    });

    // Đóng sidebar khi click ngoài (mobile)
    document.addEventListener('click', function(e) {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.querySelector('.sidebar-toggle');
        if (window.innerWidth <= 768 && 
            !sidebar.contains(e.target) && 
            !toggleBtn.contains(e.target)) {
            sidebar.classList.remove('show');
            sidebar.classList.add('collapsed');
        }
    });
</script>