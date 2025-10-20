package controller;

import dao.OrderDAO;
import dao.OrderItemDAO;
import entity.Order;
import entity.OrderItem;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // ✅ Hiển thị danh sách đơn hàng (có lọc theo ngày)
            case "list": {
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                String fromDate = request.getParameter("fromDate");
                String toDate = request.getParameter("toDate");

                OrderDAO orderDAO = new OrderDAO();
                List<Order> orders = orderDAO.getOrdersByUserAndDateRange(user.getId(), fromDate, toDate);

                request.setAttribute("orders", orders);
                request.setAttribute("fromDate", fromDate);
                request.setAttribute("toDate", toDate);

                request.getRequestDispatcher("user/my-orders.jsp").forward(request, response);
                break;
            }

            // ✅ Xem chi tiết đơn hàng
            case "detail": {
                String orderIdParam = request.getParameter("orderId");
                if (orderIdParam == null) {
                    response.sendRedirect("order?action=list");
                    return;
                }

                int orderId = Integer.parseInt(orderIdParam);
                OrderItemDAO itemDAO = new OrderItemDAO();
                List<OrderItem> items = itemDAO.getItemsByOrderId(orderId);

                request.setAttribute("orderId", orderId);
                request.setAttribute("items", items);
                request.getRequestDispatcher("user/order-detail.jsp").forward(request, response);
                break;
            }

            default:
                response.sendRedirect("order?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
