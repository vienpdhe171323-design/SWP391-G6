package controller;

import dao.UserDAO;
import util.MailSender;
import util.ResetTokenStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object error = session.getAttribute("flash_error");
            Object success = session.getAttribute("flash_success");
            Object form = session.getAttribute("flash_form");

            if (error != null) { req.setAttribute("error", error); session.removeAttribute("flash_error"); }
            if (success != null) { req.setAttribute("success", success); session.removeAttribute("flash_success"); }
            if (form != null) { req.setAttribute("form", form); session.removeAttribute("flash_form"); }
        }

        req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email").trim().toLowerCase();

        // Validate domain
        if (!email.matches("^[A-Za-z0-9._%+-]+@(gmail\\.com|yahoo\\.com|hotmail\\.com)$")) {
            req.getSession().setAttribute("flash_error", "Chỉ chấp nhận email Gmail, Yahoo hoặc Hotmail.");
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        UserDAO dao = new UserDAO();
        if (!dao.isEmailExist(email)) {
            req.getSession().setAttribute("flash_error", "Email không tồn tại trong hệ thống.");
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }

        // Tạo token
        String token = UUID.randomUUID().toString();
        ResetTokenStore.save(token, email);

        String link = req.getRequestURL().toString().replace("forgot-password", "reset-password")
                       + "?token=" + token;
        String html = "<p>Bạn vừa yêu cầu đặt lại mật khẩu.</p>"
                    + "<p>Nhấn vào link sau để đặt lại: <a href='" + link + "'>Đặt lại mật khẩu</a></p>"
                    + "<p>Link này có hiệu lực trong 15 phút.</p>";

        try {
            MailSender.send(email, "Online Market - Reset mật khẩu", html);
            req.getSession().setAttribute("flash_success", "Đã gửi link đặt lại mật khẩu tới email.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flash_error", "Không gửi được email. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
        }
    }
}
