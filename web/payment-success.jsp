<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công - Online Market</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .success-card {
            max-width: 600px;
            margin: 100px auto;
            padding: 40px;
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            font-size: 60px;
            color: #28a745;
        }
        .btn-primary {
            background-color: #6f42c1;
            border-color: #6f42c1;
        }
        .btn-primary:hover {
            background-color: #5d37a8;
            border-color: #5d37a8;
        }
    </style>
</head>
<body>
    <div class="success-card">
        <i class="fas fa-check-circle success-icon mb-3"></i>
        <h2 class="text-success mb-3">Thanh toán thành công!</h2>
        <p class="text-muted">Cảm ơn bạn đã mua hàng tại <b>Online Market</b>.</p>
        <p>Mã đơn hàng của bạn là: <strong>${orderId}</strong></p>
        <hr>
        <a href="home" class="btn btn-primary mt-3">
            <i class="fas fa-home me-2"></i> Về trang chủ
        </a>
    </div>
</body>
</html>
