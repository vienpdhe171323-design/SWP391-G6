<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- FOOTER -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    .footer {
        background: #f8f6ff;
        color: #4a4a6a;
        padding: 50px 60px 20px;
        font-family: 'Segoe UI', sans-serif;
        border-top: 3px solid #b19cd9;
    }

    .footer-container {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 40px;
        margin-bottom: 30px;
    }

    .footer h4 {
        color: #6a5acd;
        font-weight: 600;
        margin-bottom: 15px;
        position: relative;
    }

    .footer h4::after {
        content: "";
        display: block;
        width: 35px;
        height: 2px;
        background: #b19cd9;
        margin-top: 5px;
    }

    .footer a {
        color: #4a4a6a;
        text-decoration: none;
        display: block;
        margin: 6px 0;
        font-size: 14px;
        transition: 0.2s;
    }

    .footer a:hover {
        color: #6a5acd;
        text-decoration: underline;
    }

    .footer p {
        font-size: 14px;
        line-height: 1.6;
    }

    .footer .social-icons {
        margin-top: 15px;
    }

    .footer .social-icons a {
        display: inline-block;
        width: 32px;
        height: 32px;
        background: #6a5acd;
        color: white;
        text-align: center;
        line-height: 32px;
        border-radius: 50%;
        margin-right: 8px;
        transition: 0.3s;
    }

    .footer .social-icons a:hover {
        background: #b19cd9;
    }

    .footer .newsletter {
        background: #ebe9ff;
        padding: 20px;
        border-radius: 10px;
        text-align: center;
        margin-top: 10px;
    }

    .footer .newsletter h5 {
        color: #6a5acd;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .footer .newsletter form {
        margin-top: 10px;
        display: flex;
        justify-content: center;
    }

    .footer .newsletter input[type="email"] {
        padding: 8px 12px;
        border: 1px solid #ccc;
        border-radius: 8px 0 0 8px;
        width: 250px;
        outline: none;
    }

    .footer .newsletter button {
        padding: 8px 14px;
        border: none;
        background: #6a5acd;
        color: white;
        border-radius: 0 8px 8px 0;
        cursor: pointer;
        transition: 0.2s;
    }

    .footer .newsletter button:hover {
        background: #b19cd9;
    }

    .footer-bottom {
        border-top: 1px solid #ddd;
        text-align: center;
        padding-top: 15px;
        font-size: 13px;
        color: #6a6a8a;
    }

    @media (max-width: 768px) {
        .footer {
            padding: 30px 20px;
        }
        .footer-container {
            gap: 25px;
        }
    }
</style>

<footer class="footer">
    <div class="footer-container">
        <!-- Column 1 -->
        <div>
            <h4>Online Market</h4>
            <p>
                Nền tảng thương mại điện tử hàng đầu tại Việt Nam,  
                mang đến trải nghiệm mua sắm tuyệt vời với hàng triệu sản phẩm chất lượng.
            </p>
            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>

        <!-- Column 2 -->
        <div>
            <h4>Liên kết nhanh</h4>
            <a href="<%=request.getContextPath()%>/home">Trang chủ</a>
            <a href="<%=request.getContextPath()%>/products">Sản phẩm</a>
            <a href="#">Danh mục</a>
            <a href="#">Khuyến mãi</a>
            <a href="#">Về chúng tôi</a>
            <a href="#">Liên hệ</a>
        </div>

        <!-- Column 3 -->
        <div>
            <h4>Hỗ trợ khách hàng</h4>
            <a href="#">Trung tâm trợ giúp</a>
            <a href="#">Vận chuyển</a>
            <a href="#">Đổi trả hàng</a>
            <a href="#">Bảo hành</a>
            <a href="#">Thanh toán</a>
            <a href="#">Câu hỏi thường gặp</a>
        </div>

        <!-- Column 4 -->
        <div>
            <h4>Tài khoản</h4>
            <a href="<%=request.getContextPath()%>/profile">Thông tin cá nhân</a>
            <a href="<%=request.getContextPath()%>/orders">Đơn hàng của tôi</a>
            <a href="#">Yêu thích</a>
            <a href="#">Sổ địa chỉ</a>
            <a href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
            <a href="#">Tra cứu đơn hàng</a>
        </div>

        <!-- Column 5 -->
        <div>
            <h4>Thông tin liên hệ</h4>
            <p><i class="fa fa-map-marker-alt"></i> 123 Đường ABC, Quận 1, TP. Hồ Chí Minh</p>
            <p><i class="fa fa-phone"></i> Hotline: <strong>1900 123 456</strong></p>
            <p><i class="fa fa-envelope"></i> Email: <a href="mailto:support@onlinemarket.com">support@onlinemarket.com</a></p>
            <p><i class="fa fa-clock"></i> Giờ làm việc: 8:00 – 22:00 (Hằng ngày)</p>
        </div>
    </div>

    <!-- Newsletter -->
    <div class="newsletter">
        <h5><i class="fa fa-envelope"></i> Đăng ký nhận tin khuyến mãi</h5>
        <p>Nhận thông tin về sản phẩm mới và ưu đãi đặc biệt.</p>
        <form action="#" method="post">
            <input type="email" placeholder="Nhập email của bạn" required>
            <button type="submit"><i class="fa fa-paper-plane"></i> Đăng ký</button>
        </form>
    </div>

    <!-- Bottom -->
    <div class="footer-bottom">
        © 2025 Online Market. Tất cả quyền được bảo lưu. |
        <a href="#" style="color:#6a5acd;">Chính sách bảo mật</a> |
        <a href="#" style="color:#6a5acd;">Điều khoản sử dụng</a>
    </div>
</footer>
