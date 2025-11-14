<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.SellerDashboardInfo" %>
<%@ page import="java.util.Map" %>
<%
    SellerDashboardInfo info = (SellerDashboardInfo) request.getAttribute("dashboard");
    Map<String, Integer> topSelling = (Map<String, Integer>) request.getAttribute("topSelling");

    pageContext.setAttribute("info", info);
    pageContext.setAttribute("topSelling", topSelling);
%>

<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

<style>
    .stat-card {
        border-radius: 16px;
        padding: 1.75rem;
        box-shadow: 0 6px 16px rgba(0,0,0,0.08);
        background: white;
        transition: transform 0.2s, box-shadow 0.2s;
        height: 100%;
    }
    .stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 24px rgba(0,0,0,0.12);
    }
    .stat-icon {
        width: 50px;
        height: 50px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        color: white;
        margin-bottom: 1rem;
    }
    .stat-value {
        font-size: 2rem;
        font-weight: 700;
        color: #212529;
    }
    .stat-label {
        font-size: 0.95rem;
        color: #6c757d;
        font-weight: 500;
    }
    .top-product-item {
        padding: 0.75rem 0;
        border-bottom: 1px dashed #e9ecef;
    }
    .top-product-item:last-child {
        border-bottom: none;
    }
    .quick-action-btn {
        padding: 0.75rem;
        font-weight: 500;
        border-radius: 10px;
        text-align: left;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        transition: all 0.2s;
    }
    .quick-action-btn:hover {
        transform: translateX(4px);
    }
    @media (max-width: 768px) {
        .stat-value { font-size: 1.5rem; }
        .stat-icon { width: 40px; height: 40px; font-size: 1.2rem; }
    }
</style>

<main class="main-content" id="mainContent">
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-5">
            <h2 class="mb-0 d-flex align-items-center gap-2">
                <i class="fas fa-tachometer-alt text-primary"></i>
                Bảng điều khiển
            </h2>
            <small class="text-muted">
                Cập nhật: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/>
            </small>
        </div>

        <!-- ===== ROW 1: Thống kê tổng quan ===== -->
        <div class="row g-4 mb-5">
            <!-- Tổng sản phẩm -->
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <div class="stat-icon bg-primary">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="stat-value">${info.totalProducts}</div>
                    <div class="stat-label">Tổng sản phẩm</div>
                </div>
            </div>

            <!-- Hết hàng -->
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <div class="stat-icon bg-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="stat-value">${info.lowStockProducts}</div>
                    <div class="stat-label">Cảnh báo hết hàng</div>
                </div>
            </div>

            <!-- Tổng đơn hàng -->
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <div class="stat-icon bg-info">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="stat-value">${info.totalOrders}</div>
                    <div class="stat-label">Tổng đơn hàng</div>
                </div>
            </div>

            <!-- Doanh thu -->
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <div class="stat-icon bg-success">
                        <i class="fas fa-money-bill-wave"></i>
                    </div>
                    <div class="stat-value text-success">
                        <fmt:formatNumber value="${info.totalRevenue}" type="currency" currencySymbol="₫"/>
                    </div>
                    <div class="stat-label">Tổng doanh thu</div>
                </div>
            </div>
        </div>

        <!-- ===== ROW 2: Top sản phẩm + Hành động nhanh ===== -->
        <div class="row g-4">
            <!-- Top sản phẩm bán chạy -->
            <div class="col-lg-8">
                <div class="card shadow-sm" style="border-radius: 16px;">
                    <div class="card-body">
                        <h5 class="card-title mb-4 d-flex align-items-center gap-2">
                            <i class="fas fa-fire text-danger"></i>
                            Top sản phẩm bán chạy
                        </h5>

                        <c:choose>
                            <c:when test="${empty topSelling}">
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-line fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">Chưa có doanh số nào.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="list-group list-group-flush">
                                    <c:forEach var="entry" items="${topSelling}">
                                        <div class="list-group-item top-product-item d-flex justify-content-between align-items-center px-0">
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="bg-light rounded-circle d-flex align-items-center justify-content-center"
                                                     style="width: 40px; height: 40px;">
                                                    <i class="fas fa-cube text-primary"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">${entry.key}</div>
                                                </div>
                                            </div>
                                            <span class="badge bg-success fs-6 px-3 py-2">
                                                ${entry.value} đã bán
                                            </span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Hành động nhanh -->
            <div class="col-lg-4">
                <div class="card shadow-sm h-100" style="border-radius: 16px;">
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title mb-4 d-flex align-items-center gap-2">
                            <i class="fas fa-bolt text-warning"></i>
                            Hành động nhanh
                        </h5>
                        <div class="d-grid gap-3 flex-grow-1">
                            <a href="${pageContext.request.contextPath}/seller/orders"
                               class="btn btn-primary quick-action-btn">
                                <i class="fas fa-shipping-fast"></i>
                                Quản lý vận chuyển
                            </a>
                            <a href="${pageContext.request.contextPath}/seller/orders22"
                               class="btn btn-outline-primary quick-action-btn">
                                <i class="fas fa-list-ul"></i>
                                Quản lý đơn hàng
                            </a>
                            <a href="${pageContext.request.contextPath}/seller/products"
                               class="btn btn-outline-success quick-action-btn">
                                <i class="fas fa-plus-circle"></i>
                                Thêm sản phẩm mới
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="common/footer.jsp"></jsp:include>