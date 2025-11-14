<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.List" %>
<%@ page import="entity.Order" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String keyword = (String) request.getAttribute("keyword");
    String from = (String) request.getAttribute("from");
    String to = (String) request.getAttribute("to");
    String sort = (String) request.getAttribute("sort");
    String status = (String) request.getAttribute("status");
    String ctx = request.getContextPath();

    // Chuyển dữ liệu sang JSTL để dễ dùng
    pageContext.setAttribute("orders", orders);
    pageContext.setAttribute("keyword", keyword);
    pageContext.setAttribute("from", from);
    pageContext.setAttribute("to", to);
    pageContext.setAttribute("sort", sort);
    pageContext.setAttribute("status", status);
    pageContext.setAttribute("ctx", ctx);
%>

<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

<style>
    .order-card {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        margin-bottom: 1rem;
        transition: box-shadow 0.2s;
    }
    .order-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .order-header {
        background: #f8f9fa;
        padding: 1rem;
        border-bottom: 1px solid #e0e0e0;
        border-radius: 8px 8px 0 0;
    }
    .order-body {
        padding: 1rem;
    }
    .info-label {
        font-size: 0.875rem;
        color: #6c757d;
        margin-bottom: 0.25rem;
    }
    .info-value {
        font-weight: 500;
        color: #212529;
    }
    .btn-action {
        min-width: 100px;
    }
    @media (max-width: 768px) {
        .order-info-col {
            margin-bottom: 1rem;
        }
        .btn-action {
            width: 100%;
            margin-bottom: 0.5rem;
        }
    }
</style>

<main class="main-content" id="mainContent">
    <div class="container my-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">
                <i class="fas fa-history text-primary"></i>
                Lịch sử đơn hàng
            </h2>
            <span class="badge bg-info fs-6">
                <c:choose>
                    <c:when test="${not empty orders}">${orders.size()} đơn hàng</c:when>
                    <c:otherwise>0 đơn hàng</c:otherwise>
                </c:choose>
            </span>
        </div>

        <!-- Flash message -->
        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-${sessionScope.msgType} alert-dismissible fade show" role="alert">
                <i class="fas fa-${sessionScope.msgType == 'success' ? 'check-circle' : 'exclamation-triangle'}"></i>
                ${sessionScope.msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="msg" scope="session"/>
            <c:remove var="msgType" scope="session"/>
        </c:if>

        <!-- Bộ lọc -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form method="get" action="${ctx}/seller/orders22" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label"><i class="fas fa-user"></i> Tên khách hàng</label>
                        <input type="text" name="keyword" value="${keyword}" class="form-control"
                               placeholder="Nhập tên khách hàng...">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="fas fa-calendar-alt"></i> Từ ngày</label>
                        <input type="date" name="from" value="${from}" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="far fa-calendar-alt"></i> Đến ngày</label>
                        <input type="date" name="to" value="${to}" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label"><i class="fas fa-filter"></i> Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">Tất cả</option>
                            <option value="Pending" ${status == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="Confirmed" ${status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="Shipping" ${status == 'Shipping' ? 'selected' : ''}>Đang giao</option>
                            <option value="Completed" ${status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="Cancelled" ${status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="fas fa-sort-amount-down"></i> Sắp xếp</label>
                        <select name="sort" class="form-select">
                            <option value="">Mặc định</option>
                            <option value="asc" ${sort == 'asc' ? 'selected' : ''}>Tổng tiền tăng dần</option>
                            <option value="desc" ${sort == 'desc' ? 'selected' : ''}>Tổng tiền giảm dần</option>
                        </select>
                    </div>
                    <div class="col-12 d-flex gap-2">
                        <button class="btn btn-primary flex-fill" type="submit">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                        <a href="${ctx}/seller/orders22" class="btn btn-outline-secondary flex-fill">
                            <i class="fas fa-sync"></i> Làm mới
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách đơn hàng -->
        <c:choose>
            <c:when test="${empty orders}">
                <div class="card shadow-sm">
                    <div class="card-body text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Không có đơn hàng nào</h5>
                        <p class="text-muted">Không tìm thấy đơn hàng phù hợp với bộ lọc.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="o" items="${orders}">
                    <div class="order-card">
                        <div class="order-header">
                            <div class="row align-items-center">
                                <div class="col-md-3 order-info-col">
                                    <div class="info-label">Mã đơn hàng</div>
                                    <div class="info-value">#${o.orderId}</div>
                                </div>
                                <div class="col-md-3 order-info-col">
                                    <div class="info-label">Khách hàng</div>
                                    <div class="info-value">
                                        <i class="fas fa-user"></i> ${o.userName}
                                    </div>
                                </div>
                                <div class="col-md-3 order-info-col">
                                    <div class="info-label">Ngày đặt hàng</div>
                                    <div class="info-value">
                                        <i class="far fa-calendar-alt"></i>
                                        <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                                <div class="col-md-3 order-info-col text-md-end">
                                    <span class="badge
                                        ${o.status == 'Pending' ? 'bg-warning text-dark' :
                                          o.status == 'Confirmed' ? 'bg-primary' :
                                          o.status == 'Shipping' ? 'bg-info' :
                                          o.status == 'Completed' ? 'bg-success' :
                                          'bg-danger'} px-3 py-2">
                                        <c:choose>
                                            <c:when test="${o.status == 'Pending'}">Chờ xử lý</c:when>
                                            <c:when test="${o.status == 'Confirmed'}">Đã xác nhận</c:when>
                                            <c:when test="${o.status == 'Shipping'}">Đang giao</c:when>
                                            <c:when test="${o.status == 'Completed'}">Hoàn thành</c:when>
                                            <c:when test="${o.status == 'Cancelled'}">Đã hủy</c:when>
                                            <c:otherwise>${o.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="order-body">
                            <div class="row align-items-center">
                                <div class="col-md-4">
                                    <div class="info-label">Tổng giá trị đơn hàng</div>
                                    <div class="info-value fs-5 text-success">
                                        <i class="fas fa-money-bill-wave"></i>
                                        <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                    </div>
                                </div>
                                <div class="col-md-8 text-md-end mt-3 mt-md-0">
                                    <a href="${ctx}/seller/orders22?action=detail&id=${o.orderId}"
                                       class="btn btn-outline-info btn-action"
                                       data-bs-toggle="modal"
                                       data-bs-target="#orderDetailModal${o.orderId}">
                                        <i class="fas fa-list-ul"></i> Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal CHI TIẾT ĐƠN HÀNG -->
                    <div class="modal fade" id="orderDetailModal${o.orderId}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                            <div class="modal-content">
                                <div class="modal-header bg-info text-white">
                                    <h5 class="modal-title">
                                        <i class="fas fa-receipt"></i>
                                        Chi tiết đơn hàng #${o.orderId}
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white"
                                            data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h6 class="card-title"><i class="fas fa-info-circle"></i> Thông tin đơn hàng</h6>
                                            <div class="row">
                                                <div class="col-6">
                                                    <p><strong>Khách hàng:</strong> ${o.userName}</p>
                                                    <p><strong>Ngày đặt:</strong>
                                                        <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </p>
                                                </div>
                                                <div class="col-6">
                                                    <p><strong>Trạng thái:</strong>
                                                        <span class="badge
                                                            ${o.status == 'Pending' ? 'bg-warning text-dark' :
                                                              o.status == 'Confirmed' ? 'bg-primary' :
                                                              o.status == 'Shipping' ? 'bg-info' :
                                                              o.status == 'Completed' ? 'bg-success' :
                                                              'bg-danger'}">
                                                            <c:choose>
                                                                <c:when test="${o.status == 'Pending'}">Chờ xử lý</c:when>
                                                                <c:when test="${o.status == 'Confirmed'}">Đã xác nhận</c:when>
                                                                <c:when test="${o.status == 'Shipping'}">Đang giao</c:when>
                                                                <c:when test="${o.status == 'Completed'}">Hoàn thành</c:when>
                                                                <c:when test="${o.status == 'Cancelled'}">Đã hủy</c:when>
                                                                <c:otherwise>${o.status}</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </p>
                                                    <p><strong>Tổng tiền:</strong>
                                                        <span class="text-success fw-bold">
                                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                                        </span>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <h6><i class="fas fa-box-open"></i> Danh sách sản phẩm</h6>
                                    <!-- Giả sử bạn có itemsMap như trang trước -->
                                    <c:set var="items" value="${itemsMap[o.orderId]}"/>
                                    <c:choose>
                                        <c:when test="${empty items}">
                                            <div class="alert alert-warning">
                                                <i class="fas fa-exclamation-circle"></i>
                                                Không có sản phẩm trong đơn này.
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead class="table-light">
                                                    <tr>
                                                        <th>Sản phẩm</th>
                                                        <th class="text-center" style="width:90px;">SL</th>
                                                        <th class="text-end" style="width:160px;">Đơn giá</th>
                                                        <th class="text-end" style="width:160px;">Tạm tính</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:forEach var="item" items="${items}">
                                                        <tr>
                                                            <td><i class="fas fa-cube text-muted"></i> ${item.productName}</td>
                                                            <td class="text-center"><span class="badge bg-secondary">${item.quantity}</span></td>
                                                            <td class="text-end"><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                            <td class="text-end fw-bold"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                    <tr class="table-active">
                                                        <td colspan="3" class="text-end fw-bold"><i class="fas fa-calculator"></i> Tổng cộng:</td>
                                                        <td class="text-end fw-bold text-success fs-5">
                                                            <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                                        </td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                        <i class="fas fa-times"></i> Đóng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <!-- Phân trang (nếu cần) -->
        <!-- Bạn có thể thêm phân trang giống trang trước nếu có pagedOrders -->
    </div>
</main>

<script>
    // Tự động đóng alert
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert:not(.alert-info):not(.alert-warning)');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });
</script>

<jsp:include page="common/footer.jsp"></jsp:include>