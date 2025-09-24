<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <nav class="sidebar-menu">
        <a href="#" class="menu-item active">
            <i class="fas fa-home"></i>
            Dashboard
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-users"></i>
            Quản lý Users
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-box"></i>
            Sản phẩm
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-shopping-cart"></i>
            Đơn hàng
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-chart-bar"></i>
            Báo cáo
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-cog"></i>
            Cài đặt
        </a>
        <a href="#" class="menu-item">
            <i class="fas fa-sign-out-alt"></i>
            Đăng xuất
        </a>
    </nav>
</aside>

<script>
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');

        sidebar.classList.toggle('collapsed');
        sidebar.classList.toggle('show');
        mainContent.classList.toggle('expanded');
    }

    // Handle responsive menu
    window.addEventListener('resize', function () {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('mainContent');

        if (window.innerWidth > 768) {
            sidebar.classList.remove('show');
            sidebar.classList.remove('collapsed');
            mainContent.classList.remove('expanded');
        } else {
            sidebar.classList.add('collapsed');
            mainContent.classList.add('expanded');
        }
    });

    // Simulate filter functionality
    document.querySelector('form').addEventListener('submit', function (e) {
        e.preventDefault();
        alert('Tính năng tìm kiếm sẽ được xử lý bởi Servlet!\n\nCác tham số sẽ được gửi:\n- search: ' +
                document.querySelector('input[name="search"]').value + '\n- status: ' +
                document.querySelector('select[name="status"]').value + '\n- category: ' +
                document.querySelector('select[name="category"]').value);
    });

    // Simulate action buttons
    document.querySelectorAll('.btn-danger').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            if (confirm('Bạn có chắc chắn muốn xóa?')) {
                alert('Sẽ gọi servlet để xóa dữ liệu!');
            }
        });
    });

    document.querySelectorAll('.btn-primary.btn-sm').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.preventDefault();
            alert('Sẽ chuyển đến trang chỉnh sửa!');
        });
    });
</script>