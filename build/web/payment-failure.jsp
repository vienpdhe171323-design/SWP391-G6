<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại - Online Market</title>
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
        .fail-icon {
            font-size: 100px;
            color: #dc3545;
        }
    </style>
</head>
<body class="bg-light">

<div class="container text-center mt-5">
    <div class="card shadow-lg p-5 mx-auto" style="max-width: 600px;">
        <div class="card-body">
            <i class="fas fa-times-circle fail-icon mb-4"></i>
            <h2 class="text-danger mb-3">Thanh toán thất bại!</h2>
            <p class="lead">Rất tiếc, giao dịch của bạn không thành công hoặc đã bị hủy.</p>

            <c:if test="${param.vnp_ResponseCode != null}">
                <p>Mã lỗi giao dịch: 
                    <strong class="text-primary">${param.vnp_ResponseCode}</strong>
                </p>
            </c:if>

            <p>Bạn có thể thử lại hoặc chọn phương thức thanh toán khác.</p>

            <div class="mt-4">
                <a href="cart.jsp" class="btn btn-primary">
                    <i class="fas fa-shopping-cart me-2"></i> Quay lại giỏ hàng
                </a>
                <a href="home" class="btn btn-outline-danger">
                    <i class="fas fa-home me-2"></i> Trang chủ
                </a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/js/all.min.js"></script>
</body>
</html>
