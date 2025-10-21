<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo cáo lịch sử đơn hàng - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <style>
            :root {
                --primary-dark: #1e3a8a;
                --secondary-dark: #1f2937;
                --bg-light: #f3f4f6;
                --text-light: #e5e7eb;
                --text-dark: #1f2937;
            }

            body {
                font-family: 'Inter', 'Segoe UI', Tahoma, sans-serif;
                background-color: var(--bg-light);
                color: var(--text-dark);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* HEADER */
            .navbar {
                background: var(--secondary-dark);
                color: var(--text-light);
                padding: 18px 50px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .navbar h1 {
                font-size: 24px;
                margin: 0;
                font-weight: 700;
            }
            .navbar a {
                color: var(--text-light);
                text-decoration: none;
                margin-left: 25px;
                font-weight: 500;
                transition: color 0.3s ease;
            }
            .navbar a:hover {
                color: var(--primary-dark);
                border-bottom: 2px solid var(--primary-dark);
            }

            /* MAIN CONTENT */
            .main-content {
                flex-grow: 1;
                padding: 40px 20px;
            }

            .card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
            }
            .table-hover tbody tr:hover {
                background-color: #e9ecef;
            }
            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f2f2f2;
            }
            .badge {
                padding: 0.5em 0.8em;
                border-radius: 10px;
                font-weight: 600;
            }
            .pagination .page-item .page-link {
                border-radius: 0.5rem;
                margin: 0 0.25rem;
            }
            .pagination .page-item.active .page-link {
                background-color: var(--primary-dark);
                border-color: var(--primary-dark);
            }

            /* FOOTER */
            .footer {
                background: var(--secondary-dark);
                color: var(--text-light);
                text-align: center;
                padding: 15px;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <div class="navbar">
            <h1><i class="fa-solid fa-gauge-high"></i> Bảng điều khiển Admin</h1>
            <div>
                <a href="user"><i class="fa-solid fa-users"></i> Người dùng</a>
                <a href="product"><i class="fa-solid fa-boxes-stacked"></i> Sản phẩm</a>
                <a href="order-report"><i class="fa-solid fa-receipt"></i> Đơn hàng</a>
                <a href="#"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN CONTENT -->
        <div class="main-content container">
            <div class="card p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-0 text-primary">
                        <i class="fas fa-history me-2"></i> Báo cáo lịch sử đơn hàng
                    </h2>
                    <button class="btn btn-outline-primary" onclick="window.print()">
                        <i class="fas fa-print me-1"></i> In báo cáo
                    </button>

                    <button onclick="window.history.back()" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Quay lại
                    </button>
                </div>



                <!-- Search form -->
                <form method="get" action="order-report" class="row g-3 mb-4 p-3 border rounded-3 bg-light">
                    <div class="col-md-3">
                        <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Tìm theo tên người dùng...">
                    </div>
                    <div class="col-md-2">
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                            <option value="Shipped" ${status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                            <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="fromDate" value="${fromDate}" class="form-control" placeholder="Từ ngày">
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="toDate" value="${toDate}" class="form-control" placeholder="Đến ngày">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-1"></i> Tìm kiếm
                        </button>
                    </div>
                </form>



                <!-- Table -->
                <div class="table-responsive">
                    <table class="table table-hover table-bordered table-striped align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Người dùng</th>
                                <th>Trạng thái</th>
                                <th>Ngày đặt hàng</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td><span class="text-muted">#</span>${o.orderId}</td>
                                    <td>${o.userName}</td>
                                    <td>
                                        <span class="badge
                                              ${o.status == 'Completed' ? 'bg-success' :
                                                o.status == 'Pending' ? 'bg-warning text-dark' :
                                                o.status == 'Cancelled' ? 'bg-danger' :
                                                o.status == 'Shipped' ? 'bg-info' : 'bg-secondary'}">
                                                  ${o.status}
                                              </span>
                                        </td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="text-center">
                                            <button class="btn btn-info btn-sm"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#orderDetailModal${o.orderId}">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty orders}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted py-4">
                                            <i class="fas fa-box-open me-2"></i>Không có đơn hàng nào phù hợp.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Order Pagination" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="order-report?page=${currentPage - 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link"
                                       href="order-report?page=${i}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="order-report?page=${currentPage + 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keyword=${keyword}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>

            <!-- MODALS -->
            <c:forEach var="o" items="${orders}">
                <div class="modal fade" id="orderDetailModal${o.orderId}" tabindex="-1" aria-labelledby="orderDetailModalLabel${o.orderId}" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title" id="orderDetailModalLabel${o.orderId}">
                                    <i class="fas fa-receipt me-2"></i>Chi tiết đơn hàng #${o.orderId}
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <h6 class="text-muted mb-3">Thông tin đơn hàng</h6>
                                <ul class="list-unstyled">
                                    <li><strong>Người dùng:</strong> ${o.userName}</li>
                                    <li><strong>Trạng thái:</strong> 
                                        <span class="badge ${o.status == 'Completed' ? 'bg-success' : o.status == 'Pending' ? 'bg-warning text-dark' : o.status == 'Cancelled' ? 'bg-danger' : o.status == 'Shipped' ? 'bg-info' : 'bg-secondary'}">${o.status}</span>
                                    </li>
                                    <li><strong>Ngày đặt hàng:</strong> <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></li>
                                    <li><strong>Tổng tiền:</strong> <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="$"/></li>
                                </ul>
                                <hr/>
                                <h6 class="text-muted mb-3">Sản phẩm</h6>
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered">
                                        <thead>
                                            <tr>
                                                <th>Tên sản phẩm</th>
                                                <th>Số lượng</th>
                                                <th>Đơn giá</th>
                                                <th>Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${orderItemsMap[o.orderId]}">
                                                <tr>
                                                    <td>${item.productName}</td>
                                                    <td>${item.quantity}</td>
                                                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$"/></td>
                                                    <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- FOOTER -->
            <div class="footer">
                © 2025 Online Market Admin | Được phát triển bởi Your Team
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>
    </html>
