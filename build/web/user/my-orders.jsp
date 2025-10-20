<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Đơn hàng của tôi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --bs-primary: #6f42c1;
            }
            .bg-primary {
                background-color: var(--bs-primary) !important;
            }
            .text-primary {
                color: var(--bs-primary) !important;
            }
            .btn-primary {
                background-color: var(--bs-primary);
                border-color: var(--bs-primary);
            }
            .btn-primary:hover {
                background-color: #5d37a8;
                border-color: #5d37a8;
            }
            .table-primary {
                --bs-table-bg: #e5d7f6;
            }
        </style>
    </head>
    <body class="bg-light">

        <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
            <div class="container">
                <a class="navbar-brand fw-bold" href="home">🛒 Online Market</a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="home">Trang chủ</a></li>
                        <li class="nav-item"><a class="nav-link" href="cart.jsp">Giỏ hàng</a></li>
                        <li class="nav-item"><a class="nav-link active" href="order?action=list">Đơn hàng của tôi</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container mt-5 mb-5">
            <h2 class="text-primary mb-4 border-bottom pb-2">
                <i class="fas fa-box"></i> Đơn hàng của tôi
            </h2>

            <!-- Form lọc theo khoảng ngày -->
            <form action="order" method="get" class="row g-3 mb-4">
                <input type="hidden" name="action" value="list">
                <div class="col-md-4">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" name="fromDate" value="${param.fromDate}" class="form-control">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" name="toDate" value="${param.toDate}" class="form-control">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </div>
            </form>

            <!-- Form lọc theo khoảng giá tiền -->
            <form action="order" method="get" class="row g-3 mb-4">
                <input type="hidden" name="action" value="filterPrice">
                <div class="col-md-4">
                    <label class="form-label">Giá từ</label>
                    <input type="number" name="minPrice" value="${param.minPrice}" class="form-control" placeholder="Nhập giá thấp nhất">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Giá đến</label>
                    <input type="number" name="maxPrice" value="${param.maxPrice}" class="form-control" placeholder="Nhập giá cao nhất">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search-dollar"></i> Lọc theo giá
                    </button>
                </div>
            </form>


            <c:if test="${empty orders}">
                <div class="alert alert-info shadow-sm">
                    Bạn chưa có đơn hàng nào trong khoảng thời gian này. <a href="home" class="alert-link">Tiếp tục mua sắm</a>.
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
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>#${order.orderId}</td>
                                    <td>${order.orderDate}</td>
                                    <td class="text-end">${order.totalAmount}₫</td>
                                    <td>
                                        <span class="badge bg-success">${order.status}</span>
                                    </td>
                                    <td>
                                        <a href="order?action=detail&orderId=${order.orderId}" class="btn btn-sm btn-outline-primary">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
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
