<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="common/header.jsp"/>

<style>
    body {
        background-color: #f8f9fc;
    }
    .main-container {
        max-width: 1200px;
        margin: 40px auto;
    }
    .card-stat {
        border: 1px solid #e3e6f0;
        border-radius: 1rem;
        background-color: #fff;
        box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        transition: transform 0.2s;
    }
    .card-stat:hover {
        transform: translateY(-3px);
    }
    .card-stat h6 {
        color: #6c757d;
        font-size: 14px;
        margin-bottom: 8px;
    }
    .card-stat h3 {
        font-weight: 700;
        color: #111827;
    }
    .chart-container {
        background: #fff;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    }
</style>

<div class="container main-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold text-primary">
            <i class="fa-solid fa-chart-line me-2"></i>
            Hiệu suất cửa hàng: 
            <span class="text-dark">${storeName}</span>
        </h4>

        <a href="store?action=list" class="btn btn-outline-primary">
            <i class="fa-solid fa-arrow-left-long me-2"></i> Quay lại danh sách
        </a>
    </div>

    <!-- ======================= THỐNG KÊ TỔNG QUAN ======================= -->
    <div class="row text-center g-4 mb-5">
        <!-- Tổng doanh thu -->
        <div class="col-md-3">
            <div class="p-4 card-stat">
                <h6>TỔNG DOANH THU</h6>
                <h3 class="text-success">
                    <fmt:formatNumber value="${performance.totalRevenue}" type="number" groupingUsed="true"/> đ
                </h3>
            </div>
        </div>

        <!-- Tổng đơn hàng -->
        <div class="col-md-3">
            <div class="p-4 card-stat">
                <h6>TỔNG ĐƠN HÀNG</h6>
                <h3>${performance.totalOrders}</h3>
            </div>
        </div>

        <!-- Sản phẩm bán ra -->
        <div class="col-md-3">
            <div class="p-4 card-stat">
                <h6>SẢN PHẨM BÁN RA</h6>
                <h3>${performance.totalProductsSold}</h3>
            </div>
        </div>

        <!-- Đánh giá trung bình -->
        <div class="col-md-3">
            <div class="p-4 card-stat">
                <h6>ĐÁNH GIÁ TRUNG BÌNH</h6>
                <h3 class="text-warning">
                    <i class="fa-solid fa-star me-1"></i>${performance.averageRating}
                </h3>
            </div>
        </div>
    </div>

    <!-- ======================= TOP SẢN PHẨM BÁN CHẠY ======================= -->
    <div class="chart-container">
        <h5 class="fw-bold text-primary mb-3">
            <i class="fa-solid fa-boxes-stacked me-2"></i>Top 5 sản phẩm bán chạy
        </h5>

        <canvas id="topProductsChart" height="120"></canvas>

        <c:if test="${empty topProducts}">
            <div class="alert alert-warning mt-3">
                <i class="fa-solid fa-circle-exclamation me-2"></i> Chưa có dữ liệu sản phẩm bán chạy!
            </div>
        </c:if>
    </div>
</div>

<!-- ======================= CHART.JS SCRIPT ======================= -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const products = [
            <c:forEach var="p" items="${topProducts}" varStatus="loop">
                "${p.productName}"<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const quantities = [
            <c:forEach var="p" items="${topProducts}" varStatus="loop">
                ${p.quantitySold}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
        ];

        const ctx = document.getElementById('topProductsChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: products,
                datasets: [{
                    label: 'Số lượng bán',
                    data: quantities,
                    backgroundColor: 'rgba(111, 66, 193, 0.7)', // tím nhạt
                    borderColor: '#6f42c1',
                    borderWidth: 1,
                    borderRadius: 6
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    });
</script>

<jsp:include page="common/footer.jsp"/>
