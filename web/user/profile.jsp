<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User, entity.UserProfile" %>
<%
    User user = (User) request.getAttribute("user");
    UserProfile profile = (UserProfile) request.getAttribute("profile");
%>
<html>
<head>
    <title>User Profile | Online Market</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f6f4ff; /* tím nhạt nền */
        }

        h2 {
            text-align: center;
            color: #5a4fcf;
            font-weight: 600;
            margin: 30px 0 20px;
        }

        .profile-container {
            max-width: 900px;
            background: #fff;
            margin: 20px auto 60px;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 18px rgba(106, 90, 205, 0.1);
        }

        label {
            display: block;
            font-weight: 600;
            margin-top: 15px;
            color: #444;
        }

        input, select {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            margin-bottom: 12px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 14px;
            transition: 0.2s;
            box-sizing: border-box;
        }

        input:focus, select:focus {
            border-color: #9b8df4;
            box-shadow: 0 0 4px rgba(106, 90, 205, 0.2);
            outline: none;
        }

        .btn-container {
            text-align: center;
            margin-top: 25px;
        }

        button {
            padding: 10px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            margin: 0 6px;
            font-size: 15px;
        }

        .btn-save {
            background-color: #6a5acd;
            color: white;
            transition: 0.2s;
        }

        .btn-save:hover {
            background-color: #7c6ef2;
        }

        .btn-back {
            background-color: #ccc;
            color: #333;
            transition: 0.2s;
        }

        .btn-back:hover {
            background-color: #b3b3b3;
        }

        .alert-success {
            background-color: #f0f7ff;
            border: 1px solid #b8c7ff;
            color: #3742fa;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
            font-weight: 500;
        }

        .avatar-preview {
            text-align: center;
            margin-top: 15px;
        }

        .avatar-preview img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #d1c4ff;
            background: #fafafa;
            box-shadow: 0 3px 6px rgba(106, 90, 205, 0.2);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .profile-container {
                padding: 25px;
                margin: 15px;
            }
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <script>
        function previewAvatar(event) {
            const [file] = event.target.files;
            if (file) {
                const preview = document.getElementById("avatarImg");
                preview.src = URL.createObjectURL(file);
            }
        }
    </script>
</head>
<body>
    <%@ include file="../user/header.jsp" %>

    <h2>Hồ sơ cá nhân</h2>

    <div class="profile-container">
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form action="profile" method="post" enctype="multipart/form-data">
            <div class="form-grid">
                <div>
                    <!-- Email -->
                    <label>Email (không thể thay đổi):</label>
                    <input type="text" value="<%= user.getEmail() %>" readonly />

                    <!-- Full Name -->
                    <label>Họ và tên:</label>
                    <input type="text" name="fullName" value="<%= user.getFullName() %>" required />

                    <!-- Phone -->
                    <label>Số điện thoại:</label>
                    <input type="text" name="phone" value="<%= profile != null ? profile.getPhone() : "" %>" />

                    <!-- Date of Birth -->
                    <label>Ngày sinh:</label>
                    <input type="date" name="dob"
                        value="<%= profile != null && profile.getDateOfBirth() != null 
                            ? profile.getDateOfBirth().toString() : "" %>" />

                    <!-- Gender -->
                    <label>Giới tính:</label>
                    <select name="gender">
                        <option value="Male" <%= profile != null && "Male".equals(profile.getGender()) ? "selected" : "" %>>Nam</option>
                        <option value="Female" <%= profile != null && "Female".equals(profile.getGender()) ? "selected" : "" %>>Nữ</option>
                        <option value="Other" <%= profile != null && "Other".equals(profile.getGender()) ? "selected" : "" %>>Khác</option>
                    </select>
                </div>

                <div>
                    <!-- Avatar upload -->
                    <label>Ảnh đại diện:</label>
                    <input type="file" name="avatarFile" accept="image/*" onchange="previewAvatar(event)" />

                    <div class="avatar-preview">
                        <img id="avatarImg"
                            src="<%= (profile != null && profile.getAvatarUrl() != null && !profile.getAvatarUrl().isEmpty()) 
                                ? (request.getContextPath() + "/" + profile.getAvatarUrl()) 
                                : (request.getContextPath() + "/img/default-avatar.png") %>"
                            alt="Avatar Preview">
                    </div>

                    <!-- Address -->
                    <label>Địa chỉ:</label>
                    <input type="text" name="address" value="<%= profile != null ? profile.getAddress() : "" %>" />
                </div>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn-save">💾 Lưu thay đổi</button>
                <button type="button" class="btn-back" onclick="window.history.back()">← Quay lại</button>
            </div>
        </form>
    </div>

    <%@ include file="../user/footer.jsp" %>
</body>
</html>
