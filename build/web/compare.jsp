<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>So sánh sản phẩm</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <style>
        .compare-table {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            background: white;
        }

        th {
            background: #f8f9fa;
            font-weight: 700;
            text-align: center;
        }

        td {
            text-align: center;
            padding: 12px;
            vertical-align: middle;
        }

        .highlight {
            background: #d1ffd6 !important;
            font-weight: bold;
            color: #1b7c26;
            border-radius: 6px;
        }

        .product-img {
            width: 120px;
            height: 120px;
            object-fit: contain;
        }

        .remove-btn {
            cursor: pointer;
            color: red;
            font-size: 14px;
            font-weight: bold;
        }

        .product-name {
            font-weight: 600;
            color: #333;
        }

    </style>
</head>
<body class="bg-light">

<div class="container py-4">

    <h2 class="mb-4 fw-bold text-primary">🔍 So sánh sản phẩm</h2>

    <c:if test="${empty products}">
        <div class="alert alert-warning text-center">Chưa chọn sản phẩm nào để so sánh</div>
        <a href="home" class="btn btn-primary">Quay lại trang chủ</a>
        return;
    </c:if>

    <div class="compare-table p-3">
        <table class="table table-bordered align-middle">

            <!-- Ảnh sản phẩm -->
            <tr>
                <th>Hình ảnh</th>
                <c:forEach var="p" items="${products}">
                    <td>
                        <img src="${p.imageUrl}" class="product-img" onerror="this.src='images/no-image.png'">
                    </td>
                </c:forEach>
            </tr>

            <!-- Tên -->
            <tr>
                <th>Tên sản phẩm</th>
                <c:forEach var="p" items="${products}">
                    <td class="product-name">${p.productName}</td>
                </c:forEach>
            </tr>

            <!-- Giá -->
            <tr>
                <th>Giá</th>
                <c:forEach var="p" items="${products}">
                    <td class="${p.price == minPrice ? 'highlight' : ''}">
                        ${p.price}₫
                    </td>
                </c:forEach>
            </tr>

            <!-- Tồn kho -->
            <tr>
                <th>Tồn kho</th>
                <c:forEach var="p" items="${products}">
                    <td class="${p.stock == maxStock ? 'highlight' : ''}">
                        ${p.stock}
                    </td>
                </c:forEach>
            </tr>

            <!-- Cửa hàng -->
            <tr>
                <th>Cửa hàng</th>
                <c:forEach var="p" items="${products}">
                    <td>${p.storeName}</td>
                </c:forEach>
            </tr>

            <!-- Danh mục -->
            <tr>
                <th>Danh mục</th>
                <c:forEach var="p" items="${products}">
                    <td>${p.categoryName}</td>
                </c:forEach>
            </tr>

            <!-- Thuộc tính -->
            <tr>
                <th>Thuộc tính</th>
                <c:forEach var="p" items="${products}">
                    <td>
                        <c:if test="${empty p.attributes}">
                            <span class="text-muted">Không có</span>
                        </c:if>

                        <c:forEach var="a" items="${p.attributes}">
                            <div>${a.attributeName}: <b>${a.value}</b></div>
                        </c:forEach>
                    </td>
                </c:forEach>
            </tr>

            <!-- Xóa khỏi danh sách -->
            <tr>
                <th>Xóa</th>
                <c:forEach var="p" items="${products}">
                    <td>
                        <form action="compare" method="post">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button class="btn btn-outline-danger btn-sm">Xóa</button>
                        </form>
                    </td>
                </c:forEach>
            </tr>

        </table>
    </div>

    <div class="mt-4">
        <a href="home" class="btn btn-secondary">&larr; Tiếp tục mua sắm</a>
    </div>
</div>

</body>
</html>
