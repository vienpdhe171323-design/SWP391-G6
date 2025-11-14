package controller.seller;

import dao.SellerDAO;
import entity.Order;
import entity.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/seller/orders22")
public class SellerOrderController extends HttpServlet {

    private SellerDAO sellerDAO = new SellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        Integer storeId = sellerDAO.getStoreIdByUserId(user.getId());
        if (storeId == null) {
            request.setAttribute("error", "You don't own any store.");
            request.getRequestDispatcher("/seller/orders.jsp").forward(request, response);
            return;
        }

        // =========================
        // DETAIL ORDER
        // =========================
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("items", sellerDAO.getOrderItems(orderId, storeId));
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("/seller/order-detail.jsp").forward(request, response);
            return;
        }

        // =========================
        // LIST + SEARCH + FILTER
        // =========================
        String keyword = request.getParameter("keyword");
        String from = request.getParameter("from");
        String to = request.getParameter("to");
        String sort = request.getParameter("sort");
        String status = request.getParameter("status");

        List<Order> orders = sellerDAO.searchOrders(storeId, keyword, from, to, sort, status);

        request.setAttribute("keyword", keyword);
        request.setAttribute("from", from);
        request.setAttribute("to", to);
        request.setAttribute("sort", sort);
        request.setAttribute("status", status);
        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/seller/orders.jsp").forward(request, response);
    }
}
