<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<jsp:include page="common/header.jsp"/>

<div class="container my-5">
    <h2 class="mb-4"><i class="fas fa-clock-rotate-left"></i> Lịch sử đơn hàng</h2>

    <!-- Bộ lọc -->
    <form method="get" class="row g-3 mb-4">
        <div class="col-md-3">
            <input type="text" name="keywordorder" value="${keywordorder}" class="form-control" placeholder="Tên khách hàng...">
        </div>
        <div class="col-md-2">
            <select name="status" class="form-select">
                <option value="">Tất cả trạng thái</option>
                <option value="Pending"   ${status=="Pending"?"selected":""}>Chờ xử lý</option>
                <option value="Completed" ${status=="Completed"?"selected":""}>Hoàn thành</option>
                <option value="Cancelled" ${status=="Cancelled"?"selected":""}>Đã hủy</option>
            </select>
        </div>
        <div class="col-md-2">
            <input type="date" name="fromDate" value="${fromDate}" class="form-control">
        </div>
        <div class="col-md-2">
            <input type="date" name="toDate" value="${toDate}" class="form-control">
        </div>
        <div class="col-md-3">
            <button class="btn btn-primary"><i class="fas fa-filter"></i> Lọc</button>
            <a href="order-history" class="btn btn-outline-secondary">Xóa</a>
        </div>
    </form>

    <!-- Bảng đơn hàng -->
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-light">
                <tr>
                    <th>Mã đơn</th>
                    <th>Khách hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pagedOrders.items}">
                        <tr><td colspan="6" class="text-center text-muted py-4">Không có đơn hàng</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="o" items="${pagedOrders.items}">
                            <tr>
                                <td>#${o.orderId}</td>
                                <td>${o.userName}</td>
                                <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="đ"/></td>
                                <td>
                                    <span class="badge ${o.status=='Completed'?'bg-success': o.status=='Pending'?'bg-warning text-dark':'bg-danger'}">
                                        ${o.status}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary"
                                            data-bs-toggle="modal"
                                            data-bs-target="#orderModal${o.orderId}">
                                        Xem chi tiết
                                    </button>
                                    <a href="javascript:void(0)" 
                                       class="btn btn-outline-info btn-sm btn-track" 
                                       data-order-id="${o.orderId}">
                                        <i class="fas fa-truck"></i> Theo dõi đơn
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <!-- Modals đặt sau bảng -->
    <c:forEach var="o" items="${pagedOrders.items}">
        <div class="modal fade" id="orderModal${o.orderId}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi tiết đơn hàng #${o.orderId}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <c:set var="items" value="${itemsMap[o.orderId]}"/>
                        <c:choose>
                            <c:when test="${empty items}">
                                <div class="text-center text-muted py-3">Không có sản phẩm trong đơn này.</div>
                            </c:when>
                            <c:otherwise>
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Sản phẩm</th>
                                            <th class="text-center">Số lượng</th>
                                            <th class="text-end">Đơn giá</th>
                                            <th class="text-end">Tạm tính</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${items}">
                                            <tr>
                                                <td>${item.productName}</td>
                                                <td class="text-center">${item.quantity}</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="đ"/>
                                                </td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="đ"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <!-- Phân trang -->
    <nav aria-label="Orders pagination">
        <ul class="pagination justify-content-center">
            <c:forEach begin="1" end="${pagedOrders.totalPages}" var="i">
                <li class="page-item ${i==pagedOrders.page?'active':''}">
                    <a class="page-link"
                       href="order-history?page=${i}&status=${status}&fromDate=${fromDate}&toDate=${toDate}&keywordorder=${keywordorder}">
                        ${i}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>
<!-- Modal Tracking Shipment -->
<div class="modal fade" id="shipmentModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    
      <div class="modal-header">
        <h5 class="modal-title">Theo dõi vận chuyển</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      
      <div class="modal-body">
        <p><b>Mã vận chuyển:</b> <span id="trackingNumber"></span></p>
        <p><b>Đơn vị vận chuyển:</b> <span id="carrier"></span></p>
        <p><b>Trạng thái hiện tại:</b> 
           <span class="badge bg-info" id="shipmentStatus"></span>
        </p>
        <hr>

        <ul id="timeline" class="list-group">
            <!-- Dữ liệu timeline render tại đây bằng JS -->
        </ul>

      </div>
    </div>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const trackButtons = document.querySelectorAll(".btn-track");

    trackButtons.forEach(btn => {
        btn.addEventListener("click", function() {
            const orderId = this.getAttribute("data-order-id");

            fetch("ajax/track-shipment?orderId=" + orderId)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        alert("Không có thông tin vận chuyển cho đơn này");
                        return;
                    }

                    // Gán thông tin shipment
                    document.getElementById("trackingNumber").textContent = data.trackingNumber;
                    document.getElementById("carrier").textContent = data.carrier;
                    document.getElementById("shipmentStatus").textContent = data.status;

                    // Clear timeline cũ
                    const timelineEl = document.getElementById("timeline");
                    timelineEl.innerHTML = "";

                    // Render timeline mới
                    data.events.forEach(e => {
                        const li = document.createElement("li");
                        li.classList.add("list-group-item");
                        li.innerHTML =
                            `<strong>${e.status}</strong>
                             <br>
                             <small>${e.location} - ${e.time}</small>`;
                        timelineEl.appendChild(li);
                    });

                    // Show modal
                    let modal = new bootstrap.Modal(document.getElementById('shipmentModal'));
                    modal.show();
                });
        });
    });
});
</script>

<jsp:include page="common/footer.jsp"/>
