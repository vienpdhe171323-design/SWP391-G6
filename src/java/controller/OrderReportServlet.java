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
import java.util.*;

@WebServlet(name = "OrderReportServlet", urlPatterns = {"/order-report"})
public class OrderReportServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Kiểm tra role (chỉ admin, manager, seller được xem)
        String role = user.getRole() != null ? user.getRole().toLowerCase() : "";
        if (!(role.equals("admin") || role.equals("manager") || role.equals("seller"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập!");
            return;
        }

        // Lấy tham số filter
        String status = request.getParameter("status") == null ? "" : request.getParameter("status").trim();
        String fromDate = request.getParameter("fromDate") == null ? "" : request.getParameter("fromDate").trim();
        String toDate = request.getParameter("toDate") == null ? "" : request.getParameter("toDate").trim();
        String keyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword").trim();

        int pageIndex = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }

        // Lấy danh sách order
        List<Order> orders = orderDAO.getOrderHistory(status, fromDate, toDate, keyword, pageIndex);
        int totalOrders = orderDAO.countOrderHistory(status, fromDate, toDate, keyword);
        int totalPages = (int) Math.ceil((double) totalOrders / 5);

        // Lấy OrderItems cho từng order
        Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
        for (Order o : orders) {
            List<OrderItem> items = orderItemDAO.getItemsByOrderId(o.getOrderId());
            orderItemsMap.put(o.getOrderId(), items);
        }

        // Set attribute
        request.setAttribute("orders", orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("keyword", keyword);

        // Forward
        request.getRequestDispatcher("order-report.jsp").forward(request, response);
    }
}
