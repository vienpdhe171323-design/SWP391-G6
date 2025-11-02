<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công - Online Market</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bs-primary: #6f42c1;
        }
        .text-primary { color: var(--bs-primary) !important; }
        .btn-primary {
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
        }
        .btn-primary:hover {
            background-color: #5d37a8;
            border-color: #5d37a8;
        }
        .success-icon {
            font-size: 100px;
            color: #28a745;
        }
    </style>
</head>
<body class="bg-light">

<div class="container text-center mt-5">
    <div class="card shadow-lg p-5 mx-auto" style="max-width: 600px;">
        <div class="card-body">
            <i class="fas fa-check-circle success-icon mb-4"></i>
            <h2 class="text-success mb-3">Thanh toán thành công!</h2>
            <p class="lead">Cảm ơn bạn đã mua hàng tại <strong>Online Market</strong>.</p>
            
            <c:if test="${param.orderId != null}">
                <p class="mt-3">Mã đơn hàng của bạn là: 
                    <strong class="text-primary">#${param.orderId}</strong>
                </p>
            </c:if>

            <p>Chúng tôi sẽ xử lý đơn hàng và liên hệ sớm nhất khi giao hàng.</p>

            <div class="mt-4">
                <a href="home" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i> Quay về trang chủ
                </a>
                <a href="order" class="btn btn-outline-success">
                    <i class="fas fa-list me-2"></i> Xem đơn hàng
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/js/all.min.js"></script>
</body>
</html>
