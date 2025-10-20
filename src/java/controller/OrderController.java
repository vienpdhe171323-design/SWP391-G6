package controller;

import dao.OrderDAO;
import dao.OrderItemDAO;
import entity.Order;
import entity.OrderItem;
import entity.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list"; // mặc định là xem danh sách

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();

        switch (action) {

            // 🧾 Xem danh sách đơn hàng
            case "list": {
                try {
                    int userId = user.getId();
                    List<Order> orders = orderDAO.getOrdersByUserId(userId);

                    request.setAttribute("orders", orders);
                    request.getRequestDispatcher("user/my-orders.jsp").forward(request, response);

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Không thể tải danh sách đơn hàng!");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
                break;
            }

            // 📦 Xem chi tiết đơn hàng
            case "detail": {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    List<OrderItem> items = orderItemDAO.getItemsByOrderId(orderId);

                    request.setAttribute("items", items);
                    request.setAttribute("orderId", orderId);
                    request.getRequestDispatcher("user/order-detail.jsp").forward(request, response);

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Không thể tải chi tiết đơn hàng!");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
                break;
            }

            // ⚙️ Các hành động khác (mở rộng sau)
            default: {
                response.sendRedirect("home");
            }
        }
    }
}
