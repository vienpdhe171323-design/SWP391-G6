package controller;

import dao.*;
import entity.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1️⃣ Lấy thông tin user và giỏ hàng
        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (cart == null || cart.getItems().isEmpty()) {
            request.setAttribute("error", "Giỏ hàng của bạn đang trống!");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
            return;
        }

        try {
            // 2️⃣ Khởi tạo DAO
            UserDAO userDAO = new UserDAO();
            ProductDAO productDAO = new ProductDAO();
            OrderDAO orderDAO = new OrderDAO();
            OrderItemDAO orderItemDAO = new OrderItemDAO();
            PaymentDAO paymentDAO = new PaymentDAO();

            // 3️⃣ Tính tổng tiền giỏ hàng
            BigDecimal totalPrice = cart.getTotalPrice(); // BigDecimal
            double totalAmount = totalPrice.doubleValue(); // Chuyển sang double

            // 4️⃣ Tạo Order mới
            Order order = new Order();
            order.setUserId(user.getId());
            order.setUserName(user.getFullName());
            order.setTotalAmount(totalAmount);
            order.setStatus("Completed");
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));

            int orderId = orderDAO.createOrder(order);

            // 5️⃣ Lưu từng OrderItem và trừ tồn kho
            for (CartItem item : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(item.getProductId());
                orderItem.setQuantity(item.getQuantity());
                // Dùng double vì unitPrice là double
                orderItem.setUnitPrice(item.getPrice().doubleValue());

                orderItemDAO.addOrderItem(orderItem);

                // Trừ tồn kho
                productDAO.updateStock(item.getProductId(), -item.getQuantity());
            }

            // 6️⃣ Ghi nhận thanh toán (giả lập COD)
Payment payment = new Payment();
payment.setOrderId(orderId);
payment.setAmount(BigDecimal.valueOf(totalAmount)); // ✅ sửa tại đây
payment.setMethod("COD");
payment.setStatus("Completed");
paymentDAO.createPayment(payment);


            // 7️⃣ Xóa giỏ hàng sau khi thanh toán thành công
            cart.clear();
            session.setAttribute("cart", cart);

            // 8️⃣ Hiển thị thông báo thành công
            request.setAttribute("message", "Thanh toán thành công! Cảm ơn bạn đã mua hàng.");
            request.setAttribute("orderId", orderId);
            request.getRequestDispatcher("payment-success.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi xử lý thanh toán!");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}
