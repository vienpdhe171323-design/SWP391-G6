package controller;

import dao.UserDAO;
import util.ResetTokenStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        String email = ResetTokenStore.getEmail(token);

        if (email == null) {
            req.setAttribute("error", "Link không hợp lệ hoặc đã hết hạn.");
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("token", token);
        req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        String email = ResetTokenStore.getEmail(token);

        if (email == null) {
            req.getSession().setAttribute("flash_error", "Link không hợp lệ hoặc đã hết hạn.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pass = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");

        if (pass == null || pass.length() < 6 || !pass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu không hợp lệ hoặc không khớp.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }

        UserDAO dao = new UserDAO();
        dao.updatePasswordByEmail(email, pass);

        ResetTokenStore.remove(token);
        req.getSession().setAttribute("flash_success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
