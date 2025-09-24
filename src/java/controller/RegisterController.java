package controller;

import dao.UserDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    // Nếu DB bạn dùng RoleId cho buyer là "1" thì đổi thành "1"
    private static final String DEFAULT_ROLE = "1"; // 1 là buyer

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            // Move flash messages & form from session -> request, rồi xóa
            Object error = session.getAttribute("flash_error");
            Object success = session.getAttribute("flash_success");
            Object form = session.getAttribute("flash_form");

            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("flash_error");
            }
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("flash_success");
            }
            if (form != null) {
                request.setAttribute("form", form);
                session.removeAttribute("flash_form");
            }
        }

        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        String firstName = safe(request.getParameter("firstName"));
        String lastName  = safe(request.getParameter("lastName"));
        String email     = safe(request.getParameter("email")).toLowerCase();
        String password  = safe(request.getParameter("password"));
        String confirm   = safe(request.getParameter("confirmPassword"));
        String address   = safe(request.getParameter("address"));
        boolean agree    = request.getParameter("agreeTerms") != null;

        // lưu form để fill lại sau khi redirect
        Map<String, String> form = new HashMap<>();
        form.put("firstName", firstName);
        form.put("lastName", lastName);
        form.put("email", email);

        // ===== Validate =====
        String error = null;
        if (firstName.isEmpty()) error = "Vui lòng nhập họ.";
        else if (lastName.isEmpty()) error = "Vui lòng nhập tên.";
        else if (email.isEmpty() || !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) error = "Email không đúng định dạng.";
        else if (password.length() < 6) error = "Mật khẩu phải có ít nhất 6 ký tự.";
        else if (!password.equals(confirm)) error = "Mật khẩu xác nhận không khớp.";
        else if (!agree) error = "Vui lòng đồng ý với Điều khoản sử dụng.";

        if (error != null) {
            session.setAttribute("flash_error", error);
            session.setAttribute("flash_form", form);
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.isEmailExist(email)) {
            session.setAttribute("flash_error", "Email đã tồn tại. Vui lòng dùng email khác.");
            session.setAttribute("flash_form", form);
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        // Tạo user (UserDAO.add() sẽ tự SHA-256 password trước khi lưu)
        User u = new User();
        u.setEmail(email);
        u.setPasswordHash(password); // plain -> DAO sẽ hash
        u.setFullName((firstName + " " + lastName).trim());
        u.setRole(DEFAULT_ROLE); // "buyer" hoặc "1" nếu dùng RoleId
        u.setCreatedAt(new java.sql.Date(System.currentTimeMillis()));

        boolean ok = userDAO.add(u);
        if (!ok) {
            session.setAttribute("flash_error", "Không thể tạo tài khoản. Vui lòng thử lại.");
            session.setAttribute("flash_form", form);
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        // Thành công -> flash success sang trang login
        session.setAttribute("flash_success", "Tạo tài khoản thành công! Vui lòng đăng nhập.");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    private String safe(String s) { return s == null ? "" : s.trim(); }
}
