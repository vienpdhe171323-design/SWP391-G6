package controller;

import dao.RoleDAO;
import dao.UserDAO;
import entity.Role;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu đã đăng nhập thì chuyển thẳng theo role
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            redirectByRole((User) session.getAttribute("user"), request, response);
            return;
        }
        if (session != null) {
            Object success = session.getAttribute("flash_success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("flash_success");
            }

            Object error = session.getAttribute("flash_error");
            if (error != null) {
                System.out.println(error);
                request.setAttribute("error", error);
                session.removeAttribute("flash_error");
            }
        }

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String email = request.getParameter("email") == null ? "" : request.getParameter("email").trim();
        String password = request.getParameter("password") == null ? "" : request.getParameter("password");
        boolean remember = request.getParameter("rememberMe") != null;

        User u = userDAO.login(email, password);

        if (u == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không đúng.");
            request.setAttribute("param.email", email); // để giữ lại email nếu bạn muốn
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", u);

        // Remember email (đơn giản) 7 ngày
        if (remember) {
            Cookie ck = new Cookie("rememberEmail", email);
            ck.setMaxAge(7 * 24 * 60 * 60);
            ck.setHttpOnly(true);
            ck.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            response.addCookie(ck);
        }

        redirectByRole(u, request, response);
    }

    private void redirectByRole(User u, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String roleStr = (u.getRole() == null ? "" : u.getRole().trim());
        String roleName = "";

        // Trường hợp role là số ID
        if (roleStr.matches("\\d+")) {
            int roleId = Integer.parseInt(roleStr);
            RoleDAO roleDAO = new RoleDAO();
            Role role = roleDAO.getUserRoleByRoleId(roleId);
            if (role != null) {
                roleName = role.getName().trim().toLowerCase();
            }
        } else {
            // Trường hợp role là tên luôn
            roleName = roleStr.toLowerCase();
        }

        // Redirect theo role
        if ("admin".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/adminDashboard");
        } else if ("buyer".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/home");
        } else if ("manager".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/manager/dashboard");

        } else if ("warehouse".equals(roleName)) {
            response.sendRedirect(request.getContextPath() + "/warehouse/warehouses");

        } else {
            // fallback
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

}
