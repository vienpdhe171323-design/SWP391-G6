<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giỏ hàng - Online Market</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <style>
        :root {
            --bs-primary: #6f42c1;
        }
        .bg-primary { background-color: var(--bs-primary) !important; }
        .text-primary { color: var(--bs-primary) !important; }
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
             --bs-table-border-color: #c9b0e2;
        }
        .footer-dark-bg {
             background-color: #2F4050;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
        <div class="container">
            <a class="navbar-brand fw-bold" href="home">🛒 Online Market</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Đăng nhập</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="cart.jsp">
                            <i class="fas fa-shopping-cart"></i> Giỏ hàng
                            <c:if test="${sessionScope.cart != null}">
                                <span class="badge bg-danger">${sessionScope.cart.totalQuantity}</span>
                            </c:if>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container mt-5 mb-5 flex-grow-1">
        <h1 class="text-primary mb-4 border-bottom pb-2">Giỏ hàng</h1>
        
        <c:if test="${sessionScope.cart == null || sessionScope.cart.items.size() == 0}">
            <div class="alert alert-info" role="alert">
                Giỏ hàng của bạn đang trống. <a href="home" class="alert-link">Tiếp tục mua sắm</a>.
            </div>
        </c:if>
        
        <c:if test="${sessionScope.cart != null && sessionScope.cart.items.size() > 0}">
            <div class="table-responsive">
                <table class="table table-striped table-hover table-bordered align-middle bg-white shadow-sm">
                    <thead class="table-primary">
                        <tr>
                            <th class="text-white">Ảnh</th>
                            <th class="text-white">Sản phẩm</th>
                            <th class="text-white text-end">Giá</th>
                            <th class="text-white text-center">Số lượng</th>
                            <th class="text-white text-end">Tổng</th>
                            <th class="text-white text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${sessionScope.cart.items}">
                            <tr>
                                <td>
                                    <img src="${item.imageUrl}" class="img-thumbnail" alt="${item.productName}" style="width: 80px; height: 80px; object-fit: cover;">
                                </td>
                                <td>${item.productName}</td>
                                <td class="text-end">${item.price}₫</td>
                                <td class="text-center">
                                    <form action="cart" method="post" style="display: inline-flex; align-items: center;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <button type="submit" class="btn btn-sm btn-outline-secondary" name="change" value="decrease" <c:if test="${item.quantity <= 1}">disabled</c:if>>
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" name="quantity" value="${item.quantity}" class="form-control quantity-input mx-2" min="1" readonly>
                                        <button type="submit" class="btn btn-sm btn-outline-secondary" name="change" value="increase">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </form>
                                </td>
                                <td class="text-end">${item.totalPrice}₫</td>
                                <td class="text-center">
                                    <form action="cart" method="post" style="display: inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm ${item.productName} khỏi giỏ hàng không?');">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="text-end mt-4">
    <h4>Tổng cộng: 
        <span class="text-danger fw-bold">
            ${sessionScope.cart.totalPrice}₫
        </span>
    </h4>
    
    <!-- ✅ Form gửi POST đến CheckoutServlet -->
    <form action="checkout" method="post" style="display: inline;">
        <button type="submit" class="btn btn-primary mt-2">
            <i class="fas fa-credit-card"></i> Tiến hành thanh toán
        </button>
    </form>
</div>

        </c:if>
    </div>
    
    <footer class="mt-auto pt-5 text-white footer-dark-bg">
        <div class="container">
            <div class="row pb-4 border-bottom border-secondary">
                <div class="col-lg-4 mb-4">
                    <h5 class="fw-bold mb-3" style="color: #ADD8E6;">Online Market</h5>
                    <p class="small text-white-50">
                        Nền tảng thương mại điện tử hàng đầu Việt Nam, mang đến trải nghiệm mua sắm tuyệt vời với hàng triệu sản phẩm chất lượng.
                    </p>
                    <div class="d-flex social-icons mt-3">
                        <a href="#" class="text-white-50 me-3"><i class="fab fa-facebook-f fa-lg"></i></a>
                        <a href="#" class="text-white-50 me-3"><i class="fab fa-twitter fa-lg"></i></a>
                        <a href="#" class="text-white-50 me-3"><i class="fab fa-youtube fa-lg"></i></a>
                        <a href="#" class="text-white-50 me-3"><i class="fab fa-instagram fa-lg"></i></a>
                        <a href="#" class="text-white-50"><i class="fab fa-linkedin-in fa-lg"></i></a>
                    </div>
                </div>
                <div class="col-6 col-md-2 col-lg-2 mb-4">
                    <h5 class="fw-bold mb-3">Liên kết nhanh</h5>
                    <ul class="list-unstyled">
                        <li><a href="home" class="text-white-50 text-decoration-none small">Trang chủ</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Sản phẩm</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Danh mục</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Khuyến mãi</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Về chúng tôi</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Liên hệ</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 col-lg-2 mb-4">
                    <h5 class="fw-bold mb-3">Hỗ trợ khách hàng</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white-50 text-decoration-none small">Trung tâm trợ giúp</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Vận chuyển</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Đổi trả hàng</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Bảo hành</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Thanh toán</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Câu hỏi thường gặp</a></li>
                    </ul>
                </div>
                <div class="col-6 col-md-3 col-lg-2 mb-4">
                    <h5 class="fw-bold mb-3">Tài khoản</h5>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white-50 text-decoration-none small">Thông tin cá nhân</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Đơn hàng của tôi</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Yêu thích</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Sổ địa chỉ</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Đăng xuất</a></li>
                        <li><a href="#" class="text-white-50 text-decoration-none small">Tra cứu đơn hàng</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 mb-4">
                    <h5 class="fw-bold mb-3">Thông tin liên hệ</h5>
                    <ul class="list-unstyled small text-white-50">
                        <li class="mb-2"><i class="fas fa-map-marker-alt me-2 text-primary"></i> **Địa chỉ:** <br>123 Đường ABC, Quận 1, TP. Hồ Chí Minh, Việt Nam</li>
                        <li class="mb-2"><i class="fas fa-phone me-2 text-primary"></i> **Hotline:** <br>1900 123 456</li>
                        <li class="mb-2"><i class="fas fa-envelope me-2 text-primary"></i> **Email:** <br>support@onlinemarket.com</li>
                        <li class="mb-2"><i class="fas fa-clock me-2 text-primary"></i> **Giờ làm việc:** <br>8:00 - 22:00 (Hàng ngày)</li>
                    </ul>
                </div>
            </div>
            <div class="row py-4 border-bottom border-secondary">
                <div class="col-12">
                    <div class="d-flex flex-column flex-md-row align-items-md-center p-3 rounded" style="background-color: #263442;">
                        <div class="me-md-auto mb-2 mb-md-0">
                            <h6 class="mb-1 text-white"><i class="fas fa-envelope-open-text me-2"></i> **Đăng ký nhận tin khuyến mãi**</h6>
                            <p class="mb-0 small text-white-50">Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt</p>
                        </div>
                        <form class="d-flex w-100 w-md-auto ms-md-4">
                            <input type="email" class="form-control me-2" placeholder="Nhập email của bạn" aria-label="Email khuyến mãi">
                            <button class="btn btn-primary text-nowrap" type="submit"><i class="fas fa-paper-plane me-1"></i> Đăng ký</button>
                        </form>
                    </div>
                </div>
            </div>
            <div class="row py-3">
                <div class="col-md-6 small text-white-50 mb-2 mb-md-0">
                    &copy; 2025 Online Market. Tất cả quyền được bảo lưu.
                </div>
                <div class="col-md-6 text-md-end small">
                    <a href="#" class="text-white-50 text-decoration-none me-3">Chính sách bảo mật</a>
                    <a href="#" class="text-white-50 text-decoration-none me-3">Điều khoản sử dụng</a>
                    <a href="#" class="text-white-50 text-decoration-none me-3">Cookie</a>
                    <a href="#" class="text-white-50 text-decoration-none">Sơ đồ trang</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>