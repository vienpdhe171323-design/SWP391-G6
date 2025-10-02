<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="common/header.jsp"></jsp:include>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order History Report</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        body {
            background-color: #f8f9fa;
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
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
    </style>
</head>
<body class="container py-5">

    <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0 text-primary">
                <i class="fas fa-history me-2"></i>Order History Report
            </h2>
            <button class="btn btn-outline-primary" onclick="window.print()">
                <i class="fas fa-print me-1"></i> Print Report
            </button>
        </div>

        <form method="get" action="order-report" class="row g-3 mb-4 p-3 border rounded-3 bg-light">
            <div class="col-md-3">
                <label class="form-label visually-hidden">User Name</label>
                <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Search by User Name...">
            </div>
            <div class="col-md-2">
                <label class="form-label visually-hidden">Status</label>
                <select name="status" class="form-select">
                    <option value="">All Status</option>
                    <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Shipped" ${status == 'Shipped' ? 'selected' : ''}>Shipped</option>
                    <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label visually-hidden">From Date</label>
                <input type="date" name="fromDate" value="${fromDate}" class="form-control">
            </div>
            <div class="col-md-2">
                <label class="form-label visually-hidden">To Date</label>
                <input type="date" name="toDate" value="${toDate}" class="form-control">
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-search me-1"></i> Search
                </button>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover table-bordered table-striped align-middle">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Status</th>
                    <!--<th>Total Amount</th>-->
                    <th>Order Date</th>
                    <th>Actions</th>
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
                        <td>
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
                            <i class="fas fa-box-open me-2"></i>No orders found matching your criteria.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

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

    <c:forEach var="o" items="${orders}">
        <div class="modal fade" id="orderDetailModal${o.orderId}" tabindex="-1" aria-labelledby="orderDetailModalLabel${o.orderId}" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="orderDetailModalLabel${o.orderId}">
                            <i class="fas fa-receipt me-2"></i>Order #${o.orderId} Details
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <h6 class="text-muted mb-3">Order Information</h6>
                        <ul class="list-unstyled">
                            <li><strong>User:</strong> ${o.userName}</li>
                            <li><strong>Status:</strong> <span class="badge ${o.status == 'Completed' ? 'bg-success' : o.status == 'Pending' ? 'bg-warning text-dark' : o.status == 'Cancelled' ? 'bg-danger' : o.status == 'Shipped' ? 'bg-info' : 'bg-secondary'}">${o.status}</span></li>
                            <li><strong>Order Date:</strong> <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></li>
                            <li><strong>Total Amount:</strong> <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="$"/></li>
                        </ul>
                        <hr/>
                        <h6 class="text-muted mb-3">Products</h6>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered">
                                <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Unit Price</th>
                                    <th>Subtotal</th>
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
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <jsp:include page="common/footer.jsp"></jsp:include>
</body>
</html>