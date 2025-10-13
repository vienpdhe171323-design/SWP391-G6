<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:include page="common/header.jsp"></jsp:include>
<jsp:include page="common/sidebar.jsp"></jsp:include>

<main class="container mt-4">

    <h3>Tạo vận chuyển cho đơn #${orderId}</h3>

    <form method="post" action="create-shipment">
        <input type="hidden" name="orderId" value="${orderId}"/>

        <div class="mb-3">
            <label>Đơn vị vận chuyển</label>
            <input type="text" name="carrier" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Mã Tracking</label>
            <input type="text" name="trackingNumber" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-success">Tạo vận chuyển</button>
        <a href="seller/orders" class="btn btn-secondary">Hủy</a>
    </form>

</main>

<jsp:include page="../common/footer.jsp"></jsp:include>
