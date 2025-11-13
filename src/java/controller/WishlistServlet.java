package controller;

import dao.WishlistDAO;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getId();
        int productId = Integer.parseInt(request.getParameter("productId"));

        // Sửa đúng tên hàm
        boolean already = wishlistDAO.isWishlisted(userId, productId);

        if (already) {
            wishlistDAO.removeFromWishlist(userId, productId);
            request.getSession().setAttribute("favMessage", "Đã bỏ yêu thích");
        } else {
            wishlistDAO.addToWishlist(userId, productId);
            request.getSession().setAttribute("favMessage", "Đã thêm vào yêu thích");
        }

        response.sendRedirect("product?action=detail&id=" + productId);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setAttribute("wishlist", wishlistDAO.getWishlistProducts(user.getId()));

        // Sửa đường dẫn đúng folder JSP
        request.getRequestDispatcher("user/wishlist.jsp").forward(request, response);
    }
}
