package controller.store;

import dao.FollowStoreDAO;
import entity.Store;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/followed-stores")
public class FollowedStoresServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Chưa đăng nhập → chuyển sang login
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        FollowStoreDAO dao = new FollowStoreDAO();
        List<Store> followed = dao.getFollowedStores(user.getId());

        request.setAttribute("stores", followed);
        request.getRequestDispatcher("/user/followed-stores.jsp")
                .forward(request, response);
    }
}
