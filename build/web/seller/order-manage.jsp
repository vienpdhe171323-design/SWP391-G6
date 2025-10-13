<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
    .modal-backdrop.show {
        opacity: 0.5;
    }
    .tracking-input-group {
        position: relative;
    }
    .tracking-input-group .form-control {
        padding-right: 40px;
    }
    .tracking-input-group .input-icon {
        position: absolute;
        right: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #6c757d;
    }
</style>

<main class="main-content" id="mainContent">
    <div class="container my-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">
                <i class="fas fa-shipping-fast text-primary"></i>
                Đơn hàng chờ tạo Shipment
            </h2>
            <span class="badge bg-info fs-6">
                <c:choose>
                    <c:when test="${not empty pagedOrders.items}">
                        ${pagedOrders.items.size()} đơn hàng
                    </c:when>
                    <c:otherwise>
                        0 đơn hàng
                    </c:otherwise>
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
                <form method="get" class="row g-3">
                    <div class="col-md-5">
                        <label class="form-label">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </label>
                        <input type="text" name="keywordorder" value="${keywordorder}" class="form-control"
                               placeholder="Nhập tên khách hàng hoặc mã đơn hàng...">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">
                            <i class="fas fa-list-ol"></i> Số lượng hiển thị
                        </label>
                        <select name="size" class="form-select" onchange="this.form.submit()">
                            <option value="5"  ${size==5  ? "selected" : ""}>5 đơn / trang</option>
                            <option value="10" ${size==10 ? "selected" : ""}>10 đơn / trang</option>
                            <option value="20" ${size==20 ? "selected" : ""}>20 đơn / trang</option>
                            <option value="50" ${size==50 ? "selected" : ""}>50 đơn / trang</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label d-none d-md-block">&nbsp;</label>
                        <div class="d-grid gap-2 d-md-flex">
                            <button class="btn btn-primary flex-fill" type="submit">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                            <a href="orders" class="btn btn-outline-secondary flex-fill">
                                <i class="fas fa-times"></i> Xóa bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Danh sách đơn hàng -->
        <c:choose>
            <c:when test="${empty pagedOrders.items}">
                <div class="card shadow-sm">
                    <div class="card-body text-center py-5">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">Không có đơn hàng nào</h5>
                        <p class="text-muted">Hiện tại không có đơn hàng nào đang chờ tạo shipment.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="o" items="${pagedOrders.items}">
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
                                    <span class="badge ${o.status=='Completed' ? 'bg-success' : 
                                          (o.status=='Pending' ? 'bg-warning text-dark' : 'bg-secondary')} px-3 py-2">
                                        ${o.status}
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
                                    <button type="button"
                                            class="btn btn-success btn-action"
                                            data-bs-toggle="modal"
                                            data-bs-target="#createShipmentModal${o.orderId}">
                                        <i class="fas fa-paper-plane"></i> Tạo Shipment
                                    </button>
                                    <button type="button" 
                                            class="btn btn-outline-info btn-action"
                                            data-bs-toggle="modal" 
                                            data-bs-target="#orderDetailModal${o.orderId}">
                                        <i class="fas fa-list-ul"></i> Xem chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal TẠO SHIPMENT -->
                    <div class="modal fade" id="createShipmentModal${o.orderId}" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <form method="post" action="${pageContext.request.contextPath}/seller/create-shipment" 
                                      onsubmit="return confirmShipment(event, '${o.orderId}')">
                                    <div class="modal-header bg-success text-white">
                                        <h5 class="modal-title">
                                            <i class="fas fa-shipping-fast"></i> 
                                            Tạo Shipment cho đơn #${o.orderId}
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" 
                                                data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>

                                    <div class="modal-body">
                                        <input type="hidden" name="orderId" value="${o.orderId}"/>

                                        <div class="alert alert-info">
                                            <i class="fas fa-info-circle"></i>
                                            <strong>Thông tin đơn hàng:</strong><br>
                                            Khách hàng: ${o.userName}<br>
                                            Tổng tiền: <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫"/>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-truck"></i> Đơn vị vận chuyển
                                                <span class="text-danger">*</span>
                                            </label>
                                            <select name="carrier" class="form-select form-select-lg" required>
                                                <option value="">-- Chọn đơn vị vận chuyển --</option>
                                                <option value="GHN">🚚 GHN (Giao Hàng Nhanh)</option>
                                                <option value="VNPost">📮 VNPost (Bưu điện Việt Nam)</option>
                                                <option value="GHTK">📦 GHTK (Giao Hàng Tiết Kiệm)</option>
                                                <option value="JT">⚡ J&T Express</option>
                                                <option value="Ninja">🥷 Ninja Van</option>
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">
                                                <i class="fas fa-barcode"></i> Mã Tracking
                                                <span class="text-danger">*</span>
                                            </label>
                                            <div class="tracking-input-group">
                                                <input type="text" 
                                                       class="form-control form-control-lg" 
                                                       name="trackingNumber" 
                                                       required
                                                       pattern="[A-Za-z0-9]+"
                                                       placeholder="Ví dụ: GHN123456789"
                                                       title="Mã tracking chỉ bao gồm chữ cái và số">
                                                <span class="input-icon">
                                                    <i class="fas fa-hashtag"></i>
                                                </span>
                                            </div>
                                            <div class="form-text">
                                                Nhập mã vận đơn từ đơn vị vận chuyển
                                            </div>
                                        </div>

                                        <div class="alert alert-warning mb-0">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            <strong>Lưu ý quan trọng:</strong>
                                            <ul class="mb-0 mt-2">
                                                <li>Trạng thái đơn hàng sẽ chuyển sang <strong>Confirmed</strong></li>
                                                <li>Đơn hàng sẽ không còn xuất hiện trong danh sách này</li>
                                                <li>Vui lòng kiểm tra kỹ thông tin trước khi xác nhận</li>
                                            </ul>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy bỏ
                                        </button>
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-check"></i> Xác nhận tạo Shipment
                                        </button>
                                    </div>
                                </form>
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
                                            <h6 class="card-title">
                                                <i class="fas fa-info-circle"></i> Thông tin đơn hàng
                                            </h6>
                                            <div class="row">
                                                <div class="col-6">
                                                    <p><strong>Khách hàng:</strong> ${o.userName}</p>
                                                    <p><strong>Ngày đặt:</strong> 
                                                        <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </p>
                                                </div>
                                                <div class="col-6">
                                                    <p><strong>Trạng thái:</strong> 
                                                        <span class="badge ${o.status=='Completed' ? 'bg-success' : 
                                                              (o.status=='Pending' ? 'bg-warning text-dark' : 'bg-secondary')}">
                                                            ${o.status}
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

                                    <h6>
                                        <i class="fas fa-box-open"></i> Danh sách sản phẩm
                                    </h6>

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
                                                                <td>
                                                                    <i class="fas fa-cube text-muted"></i>
                                                                    ${item.productName}
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="badge bg-secondary">${item.quantity}</span>
                                                                </td>
                                                                <td class="text-end">
                                                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                                                                </td>
                                                                <td class="text-end fw-bold">
                                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫"/>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                        <tr class="table-active">
                                                            <td colspan="3" class="text-end fw-bold">
                                                                <i class="fas fa-calculator"></i> Tổng cộng:
                                                            </td>
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

        <!-- Phân trang -->
        <c:if test="${not empty pagedOrders.items && pagedOrders.totalPages > 1}">
            <nav aria-label="Orders pagination" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${pagedOrders.page > 1}">
                        <li class="page-item">
                            <a class="page-link" 
                               href="orders?page=${pagedOrders.page - 1}&size=${size}&keywordorder=${keywordorder}">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${pagedOrders.totalPages}" var="i">
                        <c:if test="${i == 1 || i == pagedOrders.totalPages || 
                                      (i >= pagedOrders.page - 2 && i <= pagedOrders.page + 2)}">
                            <li class="page-item ${i==pagedOrders.page ? 'active' : ''}">
                                <a class="page-link"
                                   href="orders?page=${i}&size=${size}&keywordorder=${keywordorder}">
                                    ${i}
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${(i == 2 && pagedOrders.page > 4) || 
                                      (i == pagedOrders.totalPages - 1 && pagedOrders.page < pagedOrders.totalPages - 3)}">
                            <li class="page-item disabled">
                                <span class="page-link">...</span>
                            </li>
                        </c:if>
                    </c:forEach>

                    <c:if test="${pagedOrders.page < pagedOrders.totalPages}">
                        <li class="page-item">
                            <a class="page-link" 
                               href="orders?page=${pagedOrders.page + 1}&size=${size}&keywordorder=${keywordorder}">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>

    </div>
</main>

<script>
function confirmShipment(event, orderId) {
    const form = event.target;
    const carrier = form.querySelector('[name="carrier"]').value;
    const trackingNumber = form.querySelector('[name="trackingNumber"]').value;
    
    if (!carrier || !trackingNumber) {
        return true; // Let HTML5 validation handle it
    }
    
    const confirmed = confirm(
        `Xác nhận tạo Shipment?\n\n` +
        `Đơn hàng: #${orderId}\n` +
        `Đơn vị vận chuyển: ${carrier}\n` +
        `Mã tracking: ${trackingNumber}\n\n` +
        `Sau khi xác nhận, đơn hàng sẽ chuyển sang trạng thái Confirmed.`
    );
    
    if (confirmed) {
        // Optional: Show loading state
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        submitBtn.disabled = true;
    }
    
    return confirmed;
}

// Auto-dismiss alerts after 5 seconds
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