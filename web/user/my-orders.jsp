<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi - Online Market</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">

    <style>
        :root { --bs-primary: #6f42c1; }
        .text-primary { color: var(--bs-primary) !important; }
        .btn-primary { background-color: var(--bs-primary); border-color: var(--bs-primary); }
        .btn-primary:hover { background-color: #5d37a8; border-color: #5d37a8; }
        .table-primary { --bs-table-bg: #ede3fa; }
    </style>
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: var(--bs-primary);">
    <div class="container">
        <a class="navbar-brand fw-bold" href="home">🛒 Online Market</a>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="home">Trang chủ</a></li>
                <li class="nav-item"><a class="nav-link" href="cart.jsp">Giỏ hàng</a></li>
                <li class="nav-item"><a class="nav-link active" href="order?action=list">Đơn hàng của tôi</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5 mb-5">
    <h2 class="text-primary mb-4 border-bottom pb-2"><i class="fas fa-box"></i> Đơn hàng của tôi</h2>

    <c:if test="${empty orders}">
        <div class="alert alert-info shadow-sm">
            Bạn chưa có đơn hàng nào. <a href="home" class="alert-link">Tiếp tục mua sắm</a>.
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle bg-white shadow-sm">
                <thead class="table-primary text-center">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#${o.orderId}</td>
                            <td>${o.orderDate}</td>
                            <td class="text-end">${o.totalAmount}₫</td>
                            <td>
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${o.status == 'Completed'}">bg-success</c:when>
                                        <c:when test="${o.status == 'Pending'}">bg-warning text-dark</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                    ${o.status}
                                </span>
                            </td>
                            <td>
                                <form action="order" method="get" style="display:inline;">
                                    <input type="hidden" name="action" value="detail">
                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                    <button type="submit" class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-eye"></i> Xem
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <div class="text-end mt-3">
        <a href="home" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại trang chủ
        </a>
    </div>
</div>

</body>
</html>
