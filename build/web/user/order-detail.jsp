<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${orderId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">

    <style>
        :root { --bs-primary: #6f42c1; }
        .btn-primary { background-color: var(--bs-primary); border-color: var(--bs-primary); }
        .btn-primary:hover { background-color: #5d37a8; border-color: #5d37a8; }
        .table-primary { --bs-table-bg: #ede3fa; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <h2 class="text-primary mb-4 border-bottom pb-2">
        <i class="fas fa-receipt"></i> Chi tiết đơn hàng #${orderId}
    </h2>

    <c:if test="${empty items}">
        <div class="alert alert-warning shadow-sm">Không có sản phẩm trong đơn hàng này.</div>
    </c:if>

    <c:if test="${not empty items}">
        <div class="table-responsive">
            <table class="table table-bordered table-hover bg-white shadow-sm">
                <thead class="table-primary text-center">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>${item.unitPrice}₫</td>
                            <td>${item.subtotal}₫</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <div class="text-end mt-3">
        <a href="order?action=list" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại đơn hàng
        </a>
    </div>
</div>

</body>
</html>
