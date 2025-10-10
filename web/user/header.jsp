<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userName = (currentUser != null) ? currentUser.getFullName() : "Guest";
    String userAvatar = (currentUser != null && currentUser.getRole() != null && currentUser.getRole().equalsIgnoreCase("buyer"))
        ? (request.getContextPath() + "/img/default-avatar.png")
        : (request.getContextPath() + "/img/default-avatar.png"); // có thể đổi sau nếu bạn có avatar từ DB
%>

<!-- HEADER -->
<style>
    .navbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        background: linear-gradient(90deg, #6a5acd, #8b7df0);
        padding: 14px 60px;
        color: white;
        font-family: 'Segoe UI', sans-serif;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 8px rgba(106, 90, 205, 0.15);
    }

    .navbar .logo a {
        color: white;
        font-size: 22px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-decoration: none;
        transition: 0.3s;
    }

    .navbar .logo a:hover {
        color: #f3f0ff;
    }

    .navbar .menu {
        display: flex;
        gap: 28px;
        align-items: center;
    }

    .navbar .menu a {
        color: white;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.25s;
        position: relative;
    }

    .navbar .menu a::after {
        content: "";
        display: block;
        height: 2px;
        width: 0;
        background: white;
        transition: 0.3s;
        position: absolute;
        bottom: -5px;
        left: 0;
    }

    .navbar .menu a:hover::after {
        width: 100%;
    }

    .navbar .search-bar input {
        padding: 7px 12px;
        border: none;
        border-radius: 20px;
        outline: none;
        width: 220px;
        font-size: 14px;
        color: #333;
        transition: 0.3s;
    }

    .navbar .search-bar input:focus {
        box-shadow: 0 0 6px rgba(106, 90, 205, 0.4);
    }

    .navbar .user-section {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .navbar .user-avatar {
        width: 38px;
        height: 38px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #fff;
        cursor: pointer;
        transition: 0.3s;
    }

    .navbar .user-avatar:hover {
        transform: scale(1.05);
        border-color: #bbaaff;
    }

    .dropdown {
        position: relative;
        display: inline-block;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 45px;
        background-color: white;
        min-width: 170px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        border-radius: 8px;
        z-index: 999;
        overflow: hidden;
        animation: fadeIn 0.2s ease-in-out;
    }

    .dropdown-content a {
        color: #444;
        padding: 10px 16px;
        text-decoration: none;
        display: block;
        font-size: 14px;
        transition: 0.25s;
    }

    .dropdown-content a:hover {
        background-color: #f4f0ff;
        color: #6a5acd;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-5px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @media (max-width: 850px) {
        .navbar {
            flex-wrap: wrap;
            padding: 12px 30px;
        }
        .navbar .menu {
            flex-basis: 100%;
            justify-content: center;
            flex-wrap: wrap;
            margin: 10px 0;
        }
        .navbar .search-bar {
            flex-basis: 100%;
            text-align: center;
            margin-top: 8px;
        }
    }
</style>

<div class="navbar">
    <div class="logo">
        <a href="<%=request.getContextPath()%>/home">🛍 Online Market</a>
    </div>

    <div class="menu">
        <a href="<%=request.getContextPath()%>/home">Trang chủ</a>
        <a href="<%=request.getContextPath()%>/products">Sản phẩm</a>
        <a href="<%=request.getContextPath()%>/orders">Đơn hàng</a>
        <a href="<%=request.getContextPath()%>/profile">Tài khoản</a>
    </div>

    <div class="search-bar">
        <form action="<%=request.getContextPath()%>/search" method="get">
            <input type="text" name="q" placeholder="Tìm sản phẩm..." />
        </form>
    </div>

    <div class="user-section">
        <div class="dropdown">
            <img src="<%=userAvatar%>" alt="Avatar" class="user-avatar">
            <div class="dropdown-content">
                <a href="<%=request.getContextPath()%>/profile">👤 <%=userName%></a>
                <a href="<%=request.getContextPath()%>/orders">📦 Đơn hàng của tôi</a>
                <a href="<%=request.getContextPath()%>/logout">🚪 Đăng xuất</a>
            </div>
        </div>
    </div>
</div>
