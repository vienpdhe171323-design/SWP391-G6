package controller;

import dao.FollowStoreDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/follow-store")
public class FollowStoreController extends HttpServlet {

    private final FollowStoreDAO followDAO = new FollowStoreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // CHƯA ĐĂNG NHẬP → QUAY LẠI LOGIN
        if (user == null) {
            session.setAttribute("flash_error", "Bạn cần đăng nhập để theo dõi cửa hàng.");
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        String action = request.getParameter("action");
        String storeIdRaw = request.getParameter("storeId");

        if (action == null || storeIdRaw == null) {
            response.sendRedirect("home");
            return;
        }

        int storeId = Integer.parseInt(storeIdRaw);
        boolean result;

        switch (action) {
            case "follow" -> {
                result = followDAO.followStore(userId, storeId);
                if (result) session.setAttribute("flash_success", "Đã theo dõi cửa hàng.");
                else session.setAttribute("flash_error", "Bạn đã theo dõi cửa hàng này rồi.");
            }
            case "unfollow" -> {
                result = followDAO.unfollowStore(userId, storeId);
                if (result) session.setAttribute("flash_success", "Đã bỏ theo dõi cửa hàng.");
                else session.setAttribute("flash_error", "Bạn chưa theo dõi cửa hàng này.");
            }
            default -> session.setAttribute("flash_error", "Yêu cầu không hợp lệ.");
        }

        response.sendRedirect("store/detail?id=" + storeId);
    }
}
