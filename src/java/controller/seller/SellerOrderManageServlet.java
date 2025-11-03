package controller.seller;

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
@WebServlet("/seller/orders")
public class SellerOrderManageServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        if (!("seller".equalsIgnoreCase(user.getRole()) || "2".equals(user.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập.");
            return;
        }

        String keyword = req.getParameter("keywordorder");
        int page = 1;
        int size = 10;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
        try { size = Integer.parseInt(req.getParameter("size")); } catch (Exception ignored) {}

        List<Order> orders = orderDAO.searchOrdersWithoutShipment(keyword, page, size);
        int total = orderDAO.countOrdersWithoutShipment(keyword);
        System.out.println(orders.size());
        // nạp items để xem chi tiết trong modal (nếu cần)
        List<Integer> orderIds = orders.stream().map(Order::getOrderId).collect(Collectors.toList());
        Map<Integer, List<entity.OrderItem>> itemsMap = orderItemDAO.getItemsByOrderIds(orderIds);

        PagedResult<Order> pagedOrders = new PagedResult<>(orders, total, page, size);

        req.setAttribute("pagedOrders", pagedOrders);
        req.setAttribute("keywordorder", keyword == null ? "" : keyword);
        req.setAttribute("size", size);
        req.setAttribute("itemsMap", itemsMap);

        req.getRequestDispatcher("order-manage.jsp").forward(req, resp);
    }
}
