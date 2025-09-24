<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Footer -->
<footer class="footer-section">
    <div class="container">
        <!-- Main Footer Content -->
        <div class="row g-4">
            <!-- Company Info -->
            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h5 class="footer-title">Online Market</h5>
                    <p class="footer-text">
                        Nền tảng thương mại điện tử hàng đầu Việt Nam, mang đến trải nghiệm mua sắm tuyệt vời với hàng triệu sản phẩm chất lượng.
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-link" title="Facebook">
                            <i class="fab fa-facebook-f"></i>
                        </a>
                        <a href="#" class="social-link" title="Instagram">
                            <i class="fab fa-instagram"></i>
                        </a>
                        <a href="#" class="social-link" title="Twitter">
                            <i class="fab fa-twitter"></i>
                        </a>
                        <a href="#" class="social-link" title="YouTube">
                            <i class="fab fa-youtube"></i>
                        </a>
                        <a href="#" class="social-link" title="LinkedIn">
                            <i class="fab fa-linkedin-in"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6">
                <div class="footer-widget">
                    <h6 class="footer-widget-title">Liên kết nhanh</h6>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/products">Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/categories">Danh mục</a></li>
                        <li><a href="${pageContext.request.contextPath}/deals">Khuyến mãi</a></li>
                        <li><a href="${pageContext.request.contextPath}/about">Về chúng tôi</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact">Liên hệ</a></li>
                    </ul>
                </div>
            </div>

            <!-- Customer Service -->
            <div class="col-lg-2 col-md-6">
                <div class="footer-widget">
                    <h6 class="footer-widget-title">Hỗ trợ khách hàng</h6>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/help">Trung tâm trợ giúp</a></li>
                        <li><a href="${pageContext.request.contextPath}/shipping">Vận chuyển</a></li>
                        <li><a href="${pageContext.request.contextPath}/returns">Đổi trả hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/warranty">Bảo hành</a></li>
                        <li><a href="${pageContext.request.contextPath}/payment">Thanh toán</a></li>
                        <li><a href="${pageContext.request.contextPath}/faq">Câu hỏi thường gặp</a></li>
                    </ul>
                </div>
            </div>

            <!-- Account -->
            <div class="col-lg-2 col-md-6">
                <div class="footer-widget">
                    <h6 class="footer-widget-title">Tài khoản</h6>
                    <ul class="footer-links">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <li><a href="${pageContext.request.contextPath}/profile">Thông tin cá nhân</a></li>
                                <li><a href="${pageContext.request.contextPath}/orders">Đơn hàng của tôi</a></li>
                                <li><a href="${pageContext.request.contextPath}/wishlist">Yêu thích</a></li>
                                <li><a href="${pageContext.request.contextPath}/addresses">Sổ địa chỉ</a></li>
                                <li><a href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/login">Đăng nhập</a></li>
                                <li><a href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                                <li><a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a></li>
                            </c:otherwise>
                        </c:choose>
                        <li><a href="${pageContext.request.contextPath}/track-order">Tra cứu đơn hàng</a></li>
                    </ul>
                </div>
            </div>

            <!-- Contact Info -->
            <div class="col-lg-3 col-md-6">
                <div class="footer-widget">
                    <h6 class="footer-widget-title">Thông tin liên hệ</h6>
                    <div class="contact-info">
                        <div class="contact-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <div>
                                <strong>Địa chỉ:</strong><br>
                                123 Đường ABC, Quận 1<br>
                                TP. Hồ Chí Minh, Việt Nam
                            </div>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <div>
                                <strong>Hotline:</strong><br>
                                <a href="tel:1900123456">1900 123 456</a>
                            </div>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <div>
                                <strong>Email:</strong><br>
                                <a href="mailto:support@onlinemarket.com">support@onlinemarket.com</a>
                            </div>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-clock"></i>
                            <div>
                                <strong>Giờ làm việc:</strong><br>
                                8:00 - 22:00 (Hàng ngày)
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Newsletter Subscription -->
        <div class="newsletter-section">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h5 class="newsletter-title">
                        <i class="fas fa-envelope-open me-2"></i>
                        Đăng ký nhận tin khuyến mãi
                    </h5>
                    <p class="newsletter-text">Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt</p>
                </div>
                <div class="col-lg-6">
                    <form class="newsletter-form" action="${pageContext.request.contextPath}/newsletter" method="POST">
                        <div class="input-group">
                            <input type="email" class="form-control" name="email" 
                                   placeholder="Nhập email của bạn" required>
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-paper-plane me-1"></i>Đăng ký
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

       
        <!-- Bottom Footer -->
        <div class="footer-bottom">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <p class="copyright">
                        &copy; 2025 Online Market. Tất cả quyền được bảo lưu.
                    </p>
                </div>
                <div class="col-lg-6">
                    <ul class="footer-bottom-links">
                        <li><a href="${pageContext.request.contextPath}/privacy">Chính sách bảo mật</a></li>
                        <li><a href="${pageContext.request.contextPath}/terms">Điều khoản sử dụng</a></li>
                        <li><a href="${pageContext.request.contextPath}/cookies">Cookie</a></li>
                        <li><a href="${pageContext.request.contextPath}/sitemap">Sơ đồ trang</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<button class="back-to-top" id="backToTop" title="Về đầu trang">
    <i class="fas fa-chevron-up"></i>
</button>

<!-- Footer CSS -->
<style>
.footer-section {
    background: #2c3e50;
    color: #ecf0f1;
    padding: 60px 0 0;
    margin-top: 80px;
}

.footer-title {
    color: #3498db;
    font-weight: bold;
    margin-bottom: 20px;
    font-size: 1.5rem;
}

.footer-text {
    color: #bdc3c7;
    line-height: 1.6;
    margin-bottom: 20px;
}

.footer-widget-title {
    color: #ecf0f1;
    font-weight: 600;
    margin-bottom: 20px;
    font-size: 1.1rem;
    border-bottom: 2px solid #3498db;
    padding-bottom: 8px;
    display: inline-block;
}

.footer-links {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-links li {
    margin-bottom: 8px;
}

.footer-links a {
    color: #bdc3c7;
    text-decoration: none;
    transition: all 0.3s ease;
    display: block;
    padding: 5px 0;
}

.footer-links a:hover {
    color: #3498db;
    padding-left: 10px;
}

.social-links {
    display: flex;
    gap: 10px;
    margin-top: 15px;
}

.social-link {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    background: #34495e;
    color: #ecf0f1;
    border-radius: 50%;
    text-decoration: none;
    transition: all 0.3s ease;
}

.social-link:hover {
    background: #3498db;
    color: white;
    transform: translateY(-3px);
}

.contact-info {
    margin-top: 10px;
}

.contact-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 15px;
    gap: 15px;
}

.contact-item i {
    color: #3498db;
    font-size: 1.2rem;
    margin-top: 3px;
}

.contact-item div {
    color: #bdc3c7;
    line-height: 1.5;
}

.contact-item strong {
    color: #ecf0f1;
}

.contact-item a {
    color: #3498db;
    text-decoration: none;
}

.contact-item a:hover {
    color: #5dade2;
}

.newsletter-section {
    background: #34495e;
    padding: 30px 0;
    margin: 40px 0;
    border-radius: 10px;
}

.newsletter-title {
    color: #3498db;
    margin-bottom: 10px;
    font-weight: 600;
}

.newsletter-text {
    color: #bdc3c7;
    margin-bottom: 0;
}

.newsletter-form .form-control {
    border: none;
    padding: 12px 15px;
    border-radius: 25px 0 0 25px;
    background: #2c3e50;
    color: #ecf0f1;
    border: 2px solid #3498db;
}

.newsletter-form .form-control:focus {
    background: #2c3e50;
    color: #ecf0f1;
    box-shadow: none;
    border-color: #5dade2;
}

.newsletter-form .btn {
    border-radius: 0 25px 25px 0;
    padding: 12px 20px;
    background: #3498db;
    border: 2px solid #3498db;
}

.newsletter-form .btn:hover {
    background: #2980b9;
    border-color: #2980b9;
}

.payment-section {
    padding: 30px 0;
    border-top: 1px solid #34495e;
    margin-top: 30px;
}

.payment-title {
    color: #ecf0f1;
    margin-bottom: 15px;
    font-weight: 600;
}

.payment-methods, .shipping-partners {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
    align-items: center;
}

.payment-method, .shipping-partner {
    height: 30px;
    border-radius: 5px;
    object-fit: cover;
    opacity: 0.8;
    transition: opacity 0.3s ease;
}

.payment-method:hover, .shipping-partner:hover {
    opacity: 1;
}

.footer-bottom {
    border-top: 1px solid #34495e;
    padding: 20px 0;
    margin-top: 30px;
}

.copyright {
    color: #bdc3c7;
    margin: 0;
    font-size: 0.9rem;
}

.footer-bottom-links {
    list-style: none;
    padding: 0;
    margin: 0;
    display: flex;
    justify-content: flex-end;
    gap: 20px;
    flex-wrap: wrap;
}

.footer-bottom-links a {
    color: #bdc3c7;
    text-decoration: none;
    font-size: 0.9rem;
    transition: color 0.3s ease;
}

.footer-bottom-links a:hover {
    color: #3498db;
}

.back-to-top {
    position: fixed;
    bottom: 30px;
    right: 30px;
    width: 50px;
    height: 50px;
    background: #3498db;
    color: white;
    border: none;
    border-radius: 50%;
    cursor: pointer;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    z-index: 1000;
    font-size: 1.2rem;
}

.back-to-top.show {
    opacity: 1;
    visibility: visible;
}

.back-to-top:hover {
    background: #2980b9;
    transform: translateY(-3px);
}

/* Responsive Design */
@media (max-width: 991.98px) {
    .footer-section {
        padding: 40px 0 0;
    }
    
    .newsletter-section {
        text-align: center;
    }
    
    .payment-methods, .shipping-partners {
        justify-content: center;
    }
    
    .footer-bottom-links {
        justify-content: center;
        margin-top: 15px;
    }
}

@media (max-width: 576px) {
    .newsletter-form .input-group {
        flex-direction: column;
    }
    
    .newsletter-form .form-control {
        border-radius: 25px;
        margin-bottom: 10px;
    }
    
    .newsletter-form .btn {
        border-radius: 25px;
    }
    
    .back-to-top {
        bottom: 20px;
        right: 20px;
        width: 45px;
        height: 45px;
    }
}
</style>

<!-- Footer JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Back to top functionality
    const backToTop = document.getElementById('backToTop');
    
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            backToTop.classList.add('show');
        } else {
            backToTop.classList.remove('show');
        }
    });
    
    backToTop.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    // Newsletter form submission
    const newsletterForm = document.querySelector('.newsletter-form');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const email = this.email.value;
            
            // Simple email validation
            if (email && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                alert('Cảm ơn bạn đã đăng ký nhận tin!');
                this.email.value = '';
            } else {
                alert('Vui lòng nhập email hợp lệ!');
            }
        });
    }
});
</script>