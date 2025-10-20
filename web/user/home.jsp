<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Trang chủ - Cửa hàng</title>
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
        .category-link.active {
            font-weight: bold;
            color: var(--bs-primary); 
        }
        .footer-dark-bg {
             background-color: #2F4050;
        }
        .bg-warning-custom {
            background-color: #d1c4e9 !important;
            color: #4527a0 !important;
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
                        <a class="nav-link active" aria-current="page" href="home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Đăng nhập</a>
                    </li>
                     <li class="nav-item">
                        <a class="nav-link" href="order">Xem Lịch Sử Mua Hàng</a>
                    </li>
                      <li class="nav-item">
                        <a class="nav-link" href="profile">Hồ Sơ Của Tôi</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="cart.jsp">
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
        
        <c:if test="${sessionScope.flash_success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.flash_success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="flash_success" scope="session"/>
        </c:if>
        <c:if test="${sessionScope.flash_error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.flash_error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="flash_error" scope="session"/>
        </c:if>
        
        <h1 class="text-primary mb-4 border-bottom pb-2">Trang chủ <small class="text-muted fs-5">(Sản phẩm nổi bật)</small></h1>
        
        <form action="home" method="get" style="margin-bottom: 20px;">
            <input type="text" name="keyword" 
                   value="${param.keyword}" 
                   placeholder="Tìm sản phẩm..." 
                   style="padding: 5px; width: 250px;">
            <button type="submit">Tìm kiếm</button>
        </form>

        <div class="row">
            
            <div class="col-lg-3">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-white border-bottom">
                        <h3 class="h5 mb-0 text-secondary">Danh mục sản phẩm</h3>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">
                            <a href="home" class="category-link ${selectedCategoryId == null ? 'active' : ''}">
                                <i class="fas fa-grip-horizontal me-2"></i> Tất cả
                            </a>
                        </li>
                        <c:forEach var="cat" items="${categories}">
                            <li class="list-group-item">
                                <a href="home?categoryId=${cat.categoryId}"
                                   class="category-link ${cat.categoryId == selectedCategoryId ? 'active' : ''}">
                                    <i class="fas fa-tag me-2"></i> ${cat.categoryName}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                
                <div class="card shadow-sm">
                    <div class="card-header bg-warning-custom">
                        <h3 class="h5 mb-0">⭐ Cửa hàng nổi bật</h3>
                    </div>
                    <ul class="list-group list-group-flush small">
                        <c:forEach var="s" items="${topStores}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                ${s.storeName} 
                                <span class="badge bg-secondary text-white">Ngày tạo: ${s.createdAt}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            <div class="col-lg-9">
                
                <h3 class="mb-3 text-secondary border-bottom pb-2">Danh sách sản phẩm</h3>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover table-bordered align-middle bg-white shadow-sm">
                        <thead class="table-primary">
                            <tr>
                                <th class="text-white">Ảnh</th>
                                <th class="text-white">Tên sản phẩm</th>
                                <th class="text-white text-end">Giá</th>
                                <th class="text-white">Cửa hàng</th>
                                <th class="text-white text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${products}">
                                <tr>
                                    <td>
                                        <img src="${p.imageUrl}" class="img-thumbnail" alt="${p.productName}" style="width: 80px; height: 80px; object-fit: cover;">
                                    </td>
                                    <td>${p.productName}</td>
                                    <td class="text-end text-danger fw-bold">${p.price}₫</td>
                                    <td>${p.storeName}</td>
                                    <td class="text-center">
                                        <a href="product?action=detail&id=${p.id}" class="btn btn-sm btn-outline-primary">
                                            Xem
                                        </a>
                                        <form action="cart" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-sm btn-primary">
                                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <nav aria-label="Phân trang sản phẩm" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:choose>
                            <c:when test="${pageIndex > 1}">
                                <li class="page-item">
                                    <a class="page-link text-primary" href="home?page=${pageIndex - 1}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>" aria-label="Trang trước">
                                        <span aria-hidden="true">&laquo;</span> Trang trước
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled">
                                    <span class="page-link text-muted" aria-label="Trang trước">
                                        <span aria-hidden="true">&laquo;</span> Trang trước
                                    </span>
                                </li>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == pageIndex}">
                                    <li class="page-item active" aria-current="page">
                                        <span class="page-link bg-primary border-primary">${i}</span>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="page-item">
                                        <a class="page-link text-primary" href="home?page=${i}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>">${i}</a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${pageIndex < totalPages}">
                                <li class="page-item">
                                    <a class="page-link text-primary" href="home?page=${pageIndex + 1}<c:if test='${selectedCategoryId != null}'>&categoryId=${selectedCategoryId}</c:if><c:if test='${param.keyword != null}'>&keyword=${param.keyword}</c:if>" aria-label="Trang sau">
                                        Trang sau <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li class="page-item disabled">
                                    <span class="page-link text-muted" aria-label="Trang sau">
                                        Trang sau <span aria-hidden="true">&raquo;</span>
                                    </span>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
                
            </div>
        </div>
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