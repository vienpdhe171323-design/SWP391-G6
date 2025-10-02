package controller;

import dao.OrderDAO;
import dao.OrderItemDAO;
import entity.Order;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.PagedResult;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!("buyer".equalsIgnoreCase(user.getRole()) || "1".equals(user.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập vào trang này.");
            return;
        }

        String status   = req.getParameter("status");
        String fromDate = req.getParameter("fromDate");
        String toDate   = req.getParameter("toDate");
        String keyword  = req.getParameter("keywordorder");

        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}

        List<Order> orders = orderDAO.getOrderHistoryByUser(
                user.getId(), status, fromDate, toDate, keyword, page);
        int total = orderDAO.countOrderHistoryByUser(
                user.getId(), status, fromDate, toDate, keyword);

        // Nạp items cho tất cả đơn trong trang hiện tại
        List<Integer> orderIds = orders.stream().map(Order::getOrderId).collect(Collectors.toList());
        Map<Integer, List<entity.OrderItem>> itemsMap = orderItemDAO.getItemsByOrderIds(orderIds);

        PagedResult<Order> pagedOrders = new PagedResult<>(orders, total, page, 5);
        req.setAttribute("pagedOrders", pagedOrders);
        req.setAttribute("status", status);
        req.setAttribute("fromDate", fromDate);
        req.setAttribute("toDate", toDate);
        req.setAttribute("keywordorder", keyword);
        req.setAttribute("itemsMap", itemsMap); // <<< quan trọng

        req.getRequestDispatcher("/order-history.jsp").forward(req, resp);
    }
}
