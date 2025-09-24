<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Include Header -->
<jsp:include page="common/header.jsp"/>

<link rel="stylesheet" href="assets/css/home.css">

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-4 fw-bold mb-4">Chào mừng đến Online Market</h1>
                <p class="lead mb-4">Khám phá hàng triệu sản phẩm chất lượng với giá tốt nhất. Giao hàng nhanh chóng, đổi trả dễ dàng.</p>
                <div class="d-flex gap-3">
                    <a href="#products" class="btn btn-light btn-lg">
                        <i class="fas fa-shopping-bag me-2"></i>Mua sắm ngay
                    </a>
                    <a href="#" class="btn btn-outline-light btn-lg">
                        <i class="fas fa-gift me-2"></i>Ưu đãi hôm nay
                    </a>
                </div>
            </div>
            <div class="col-lg-6 text-center">
                <img src="https://via.placeholder.com/500x400/667eea/ffffff?text=Online+Shopping" 
                     class="img-fluid rounded shadow" alt="Shopping">
            </div>
        </div>
    </div>
</section>

<!-- Main Content -->
<div class="container my-5" id="products">
    <div class="row">
        <!-- Sidebar Filters -->
        <div class="col-lg-3 mb-4">
            <div class="filter-sidebar sticky-top" style="top: 20px;">
                <h5 class="mb-4"><i class="fas fa-filter me-2"></i>Bộ lọc</h5>
                
                <!-- Category Filter -->
                <div class="mb-4">
                    <h6 class="fw-bold">Danh mục</h6>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="" 
                               ${empty param.category ? 'checked' : ''} onchange="filterProducts()">
                        <label class="form-check-label">Tất cả</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="electronics" 
                               ${param.category == 'electronics' ? 'checked' : ''} onchange="filterProducts()">
                        <label class="form-check-label">Điện tử</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="clothing" 
                               ${param.category == 'clothing' ? 'checked' : ''} onchange="filterProducts()">
                        <label class="form-check-label">Thời trang</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="books" 
                               ${param.category == 'books' ? 'checked' : ''} onchange="filterProducts()">
                        <label class="form-check-label">Sách</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="category" value="home" 
                               ${param.category == 'home' ? 'checked' : ''} onchange="filterProducts()">
                        <label class="form-check-label">Gia dụng</label>
                    </div>
                </div>

                <!-- Price Range -->
                <div class="mb-4">
                    <h6 class="fw-bold">Khoảng giá</h6>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="priceRange" value="">
                        <label class="form-check-label">Tất cả</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="priceRange" value="0-500000">
                        <label class="form-check-label">Dưới 500.000đ</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="priceRange" value="500000-1000000">
                        <label class="form-check-label">500.000đ - 1.000.000đ</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="priceRange" value="1000000-2000000">
                        <label class="form-check-label">1.000.000đ - 2.000.000đ</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="radio" name="priceRange" value="2000000-">
                        <label class="form-check-label">Trên 2.000.000đ</label>
                    </div>
                </div>

                <!-- Rating Filter -->
                <div class="mb-4">
                    <h6 class="fw-bold">Đánh giá</h6>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="5">
                        <label class="form-check-label">
                            <span class="text-warning">★★★★★</span> (5 sao)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="4">
                        <label class="form-check-label">
                            <span class="text-warning">★★★★☆</span> (4 sao trở lên)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" value="3">
                        <label class="form-check-label">
                            <span class="text-warning">★★★☆☆</span> (3 sao trở lên)
                        </label>
                    </div>
                </div>

                <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                    <i class="fas fa-times me-2"></i>Xóa bộ lọc
                </button>
            </div>
        </div>

        <!-- Products Content -->
        <div class="col-lg-9">
            <!-- Sort and Results Info -->
            <div class="row mb-4 align-items-center">
                <div class="col-md-6">
                    <h4 class="mb-0">
                        <c:choose>
                            <c:when test="${not empty param.keyword}">
                                Kết quả tìm kiếm cho: "<em>${param.keyword}</em>"
                            </c:when>
                            <c:when test="${not empty param.category}">
                                Danh mục: 
                                <c:choose>
                                    <c:when test="${param.category == 'electronics'}">Điện tử</c:when>
                                    <c:when test="${param.category == 'clothing'}">Thời trang</c:when>
                                    <c:when test="${param.category == 'books'}">Sách</c:when>
                                    <c:when test="${param.category == 'home'}">Gia dụng</c:when>
                                    <c:otherwise>Tất cả sản phẩm</c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>Tất cả sản phẩm</c:otherwise>
                        </c:choose>
                    </h4>
                    <p class="text-muted mb-0">Hiển thị 1-20 trong số 150 sản phẩm</p>
                </div>
                <div class="col-md-6">
                    <div class="d-flex justify-content-end align-items-center">
                        <label class="me-2">Sắp xếp theo:</label>
                        <select class="form-select w-auto" onchange="sortProducts(this.value)">
                            <option value="">Mặc định</option>
                            <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                            <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                            <option value="name_asc" ${param.sort == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                            <option value="name_desc" ${param.sort == 'name_desc' ? 'selected' : ''}>Tên Z-A</option>
                            <option value="newest" ${param.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Products Grid -->
            <div class="row g-4" id="products-container">
                <!-- Sample Products (Fixed Data) -->
                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100 position-relative">
                        <div class="discount-badge">-20%</div>
                        <img src="https://via.placeholder.com/300x200/007bff/ffffff?text=iPhone+15" 
                             class="card-img-top product-img" alt="iPhone 15">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">iPhone 15 Pro Max 256GB</h6>
                            <p class="card-text text-muted flex-grow-1">Điện thoại thông minh cao cấp với chip A17 Pro, camera 48MP và màn hình Super Retina XDR.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★★</span>
                                <small class="text-muted">(128 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-original">25.990.000đ</span>
                                <br>
                                <span class="price-current">20.790.000đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(1)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100 position-relative">
                        <div class="discount-badge">-15%</div>
                        <img src="https://via.placeholder.com/300x200/28a745/ffffff?text=MacBook+Pro" 
                             class="card-img-top product-img" alt="MacBook Pro">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">MacBook Pro 14" M3 512GB</h6>
                            <p class="card-text text-muted flex-grow-1">Laptop chuyên nghiệp với chip M3, màn hình Liquid Retina XDR và hiệu năng vượt trội.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★★</span>
                                <small class="text-muted">(89 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-original">52.990.000đ</span>
                                <br>
                                <span class="price-current">45.040.000đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(2)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100">
                        <img src="https://via.placeholder.com/300x200/dc3545/ffffff?text=Áo+Thun+Nam" 
                             class="card-img-top product-img" alt="Áo thun nam">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">Áo Thun Nam Basic Cotton</h6>
                            <p class="card-text text-muted flex-grow-1">Áo thun nam chất liệu cotton 100%, form slim fit, nhiều màu sắc để lựa chọn.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★☆</span>
                                <small class="text-muted">(245 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-current">199.000đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(3)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100 position-relative">
                        <div class="discount-badge">-30%</div>
                        <img src="https://via.placeholder.com/300x200/6f42c1/ffffff?text=Sách+Lập+Trình" 
                             class="card-img-top product-img" alt="Sách lập trình">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">Clean Code - Mã Nguồn Sạch</h6>
                            <p class="card-text text-muted flex-grow-1">Sách hướng dẫn viết mã nguồn sạch và chuyên nghiệp cho lập trình viên.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★★</span>
                                <small class="text-muted">(312 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-original">299.000đ</span>
                                <br>
                                <span class="price-current">209.300đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(4)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100">
                        <img src="https://via.placeholder.com/300x200/fd7e14/ffffff?text=Nồi+Cơm+Điện" 
                             class="card-img-top product-img" alt="Nồi cơm điện">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">Nồi Cơm Điện Toshiba 1.8L</h6>
                            <p class="card-text text-muted flex-grow-1">Nồi cơm điện cao cấp với công nghệ IH, lòng nồi chống dính và nhiều chức năng.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★☆</span>
                                <small class="text-muted">(167 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-current">2.590.000đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(5)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="card product-card h-100 position-relative">
                        <div class="discount-badge">-25%</div>
                        <img src="https://via.placeholder.com/300x200/e83e8c/ffffff?text=Giày+Thể+Thao" 
                             class="card-img-top product-img" alt="Giày thể thao">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title">Giày Thể Thao Nike Air Max</h6>
                            <p class="card-text text-muted flex-grow-1">Giày chạy bộ chất lượng cao với đệm khí Air Max và thiết kế năng động.</p>
                            <div class="mb-2">
                                <span class="text-warning">★★★★★</span>
                                <small class="text-muted">(456 đánh giá)</small>
                            </div>
                            <div class="price-section mb-3">
                                <span class="price-original">3.200.000đ</span>
                                <br>
                                <span class="price-current">2.400.000đ</span>
                            </div>
                            <div class="d-grid gap-2">
                                <button class="btn btn-primary" onclick="addToCart(6)">
                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-eye me-1"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <nav aria-label="Product pagination" class="mt-5">
                <ul class="pagination pagination-custom justify-content-center">
                    <li class="page-item disabled">
                        <a class="page-link" href="#" tabindex="-1">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    <li class="page-item active">
                        <a class="page-link" href="#">1</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=2">2</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=3">3</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="#" disabled>...</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=8">8</a>
                    </li>
                    <li class="page-item">
                        <a class="page-link" href="?page=2">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- JavaScript Functions -->
<script>
    function filterProducts() {
        const category = document.querySelector('input[name="category"]:checked').value;
        const priceRange = document.querySelector('input[name="priceRange"]:checked')?.value || '';
        const keyword = new URLSearchParams(window.location.search).get('keyword') || '';
        const sort = new URLSearchParams(window.location.search).get('sort') || '';
        
        let url = '${pageContext.request.contextPath}/home?';
        if (keyword) url += 'keyword=' + encodeURIComponent(keyword) + '&';
        if (category) url += 'category=' + category + '&';
        if (priceRange) url += 'priceRange=' + priceRange + '&';
        if (sort) url += 'sort=' + sort + '&';
        
        window.location.href = url.replace(/&$/, '');
    }
    
    function sortProducts(sortValue) {
        const urlParams = new URLSearchParams(window.location.search);
        if (sortValue) {
            urlParams.set('sort', sortValue);
        } else {
            urlParams.delete('sort');
        }
        window.location.href = '${pageContext.request.contextPath}/home?' + urlParams.toString();
    }
    
    function clearFilters() {
        const keyword = new URLSearchParams(window.location.search).get('keyword') || '';
        let url = '${pageContext.request.contextPath}/home';
        if (keyword) url += '?keyword=' + encodeURIComponent(keyword);
        window.location.href = url;
    }
    
    // Initialize page
    document.addEventListener('DOMContentLoaded', function() {
        // Set price range filter from URL
        const urlParams = new URLSearchParams(window.location.search);
        const priceRange = urlParams.get('priceRange');
        if (priceRange) {
            const priceInput = document.querySelector(`input[name="priceRange"][value="${priceRange}"]`);
            if (priceInput) priceInput.checked = true;
        }
    });
</script>

<!-- Include Footer -->
<jsp:include page="common/footer.jsp"/>