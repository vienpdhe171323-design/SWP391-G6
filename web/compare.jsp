<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>So sánh sản phẩm - Online Market</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        :root {
            --primary: #6f42c1;
            --success: #1b7c26;
            --light: #f8f9fa;
            --radius: 12px;
            --shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        body {
            background: linear-gradient(to bottom, #f5f3ff, #ffffff);
            min-height: 100vh;
        }
        .compare-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .compare-card {
            background: white;
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            border: none;
        }
        .card-header {
            background: linear-gradient(135deg, var(--primary), #5a32a3);
            color: white;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.3rem;
        }
        .compare-table th {
            background: var(--light);
            font-weight: 700;
            text-align: center;
            vertical-align: middle;
            width: 180px;
            white-space: nowrap;
        }
        .compare-table td {
            text-align: center;
            vertical-align: middle;
            padding: 14px 12px;
            min-height: 60px;
        }
        .product-col {
            width: calc((100% - 180px) / 3);
            max-width: 300px;
        }
        .product-img {
            width: 120px;
            height: 120px;
            object-fit: contain;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            transition: transform 0.3s ease;
        }
        .product-img:hover {
            transform: scale(1.05);
        }
        .product-name {
            font-weight: 600;
            color: #333;
            font-size: 1.1rem;
            margin: 0.5rem 0;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .highlight {
            background: #d1ffd6 !important;
            font-weight: bold;
            color: var(--success);
            border-radius: 6px;
            padding: 4px 8px;
        }
        .attr-name {
            font-weight: 600;
            color: #555;
        }
        .no-data {
            color: #999;
            font-style: italic;
        }
        .remove-form {
            display: inline;
        }
        .btn-remove {
            font-size: 0.875rem;
            padding: 0.35rem 0.75rem;
        }
        .back-btn {
            border-radius: 50px;
            padding: 0.65rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        @media (max-width: 768px) {
            .compare-table th, .compare-table td {
                font-size: 0.875rem;
                padding: 8px 6px;
            }
            .product-img {
                width: 80px;
                height: 80px;
            }
            .product-name {
                font-size: 0.95rem;
            }
        }
    </style>
</head>
<body>
<div class="compare-container">
    <div class="card compare-card">
        <div class="card-header d-flex align-items-center">
            <i class="fas fa-balance-scale me-2"></i>
            So sánh sản phẩm
        </div>

        <!-- ========== TRƯỜNG HỢP KHÔNG CÓ SẢN PHẨM ========== -->
        <c:if test="${empty products}">
            <div class="card-body text-center py-5">
                <i class="fas fa-search fa-3x text-muted mb-3"></i>
                <p class="text-muted mb-4">Chưa chọn sản phẩm nào để so sánh</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary back-btn">
                    <i class="fas fa-home me-1"></i> Quay lại trang chủ
                </a>
            </div>
        </c:if>

        <!-- ========== TRƯỜNG HỢP CÓ SẢN PHẨM ========== -->
        <c:if test="${not empty products}">
            <div class="table-responsive p-3">
                <table class="table table-bordered compare-table align-middle">
                    <!-- Ảnh sản phẩm -->
                    <tr>
                        <th>Hình ảnh</th>
                        <c:forEach var="p" items="${products}">
                            <td class="product-col">
                                <img src="${p.imageUrl}"
                                     class="product-img"
                                     alt="${p.productName}"
                                     onerror="this.src='${pageContext.request.contextPath}/images/no-image.png'">
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Tên sản phẩm -->
                    <tr>
                        <th>Tên sản phẩm</th>
                        <c:forEach var="p" items="${products}">
                            <td class="product-col">
                                <div class="product-name">${p.productName}</div>
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Giá -->
                    <tr>
                        <th>Giá</th>
                        <c:forEach var="p" items="${products}">
                            <td class="${p.price.intValue() == minPrice ? 'highlight' : ''}">
                                <strong><fmt:formatNumber value="${p.price}" type="currency" currencySymbol=""/>₫</strong>
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Tồn kho -->
                    <tr>
                        <th>Tồn kho</th>
                        <c:forEach var="p" items="${products}">
                            <td class="${p.stock == maxStock ? 'highlight' : ''}">
                                ${p.stock} sản phẩm
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Cửa hàng -->
                    <tr>
                        <th>Cửa hàng</th>
                        <c:forEach var="p" items="${products}">
                            <td>
                                <i class="fas fa-store-alt text-primary me-1"></i>
                                ${p.storeName}
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Danh mục -->
                    <tr>
                        <th>Danh mục</th>
                        <c:forEach var="p" items="${products}">
                            <td>
                                <span class="badge bg-light text-dark">${p.categoryName}</span>
                            </td>
                        </c:forEach>
                    </tr>

                    <!-- Thuộc tính (theo từng dòng) -->
                    <c:if test="${not empty allAttributeNames}">
                        <c:forEach var="attrName" items="${allAttributeNames}">
                            <c:set var="hasAnyValue" value="false"/>
                            <c:forEach var="p" items="${products}">
                                <c:forEach var="a" items="${p.attributes}">
                                    <c:if test="${a.attributeName == attrName && not empty a.value}">
                                        <c:set var="hasAnyValue" value="true"/>
                                    </c:if>
                                </c:forEach>
                            </c:forEach>

                            <c:if test="${hasAnyValue}">
                                <tr>
                                    <th class="attr-name">${attrName}</th>
                                    <c:forEach var="p" items="${products}">
                                        <td>
                                            <c:set var="found" value="false"/>
                                            <c:forEach var="a" items="${p.attributes}">
                                                <c:if test="${a.attributeName == attrName}">
                                                    <strong>${a.value}</strong>
                                                    <c:set var="found" value="true"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${!found}">
                                                <span class="no-data">—</span>
                                            </c:if>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <!-- Nếu không có thuộc tính -->
                    <c:if test="${empty allAttributeNames}">
                        <tr>
                            <th>Thuộc tính</th>
                            <c:forEach var="p" items="${products}">
                                <td class="no-data">Không có</td>
                            </c:forEach>
                        </tr>
                    </c:if>

                    <!-- Xóa sản phẩm -->
                    <tr>
                        <th>Xóa</th>
                        <c:forEach var="p" items="${products}">
                            <td>
                                <form action="${pageContext.request.contextPath}/compare" method="post" class="remove-form">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm btn-remove">
                                        <i class="fas fa-times"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </c:forEach>
                    </tr>
                </table>
            </div>

            <!-- Nút quay lại -->
            <div class="card-footer bg-transparent text-center py-4">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary back-btn">
                    <i class="fas fa-arrow-left me-1"></i> Tiếp tục mua sắm
                </a>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>