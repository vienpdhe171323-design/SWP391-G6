package controller;

import dao.*;
import entity.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import util.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

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
            PaymentTransactionDAO transDAO = new PaymentTransactionDAO();

            // 3️⃣ Tính tổng tiền
            BigDecimal totalPrice = cart.getTotalPrice();

            // 4️⃣ Tạo Order mới (trạng thái "Pending")
            Order order = new Order();
            order.setUserId(user.getId());
            order.setUserName(user.getFullName());
            order.setTotalAmount(totalPrice.doubleValue());
            order.setStatus("Pending");
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));

            int orderId = orderDAO.createOrder(order);

            // 5️⃣ Lưu chi tiết từng sản phẩm
            for (CartItem item : cart.getItems()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setProductId(item.getProductId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setUnitPrice(item.getPrice().doubleValue());
                orderItemDAO.addOrderItem(orderItem);

                // Trừ tồn kho
                productDAO.updateStock(item.getProductId(), -item.getQuantity());
            }

            // 6️⃣ Tạo bản ghi Payment (trạng thái Pending, phương thức VNPay)
            Payment payment = new Payment();
            payment.setOrderId(orderId);
            payment.setAmount(totalPrice);
            payment.setMethod("VNPay");
            payment.setStatus("Pending");
            paymentDAO.createPayment(payment);

            // 7️⃣ Tạo giao dịch VNPay (transactionId = timestamp)
            String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
            PaymentTransaction transaction = new PaymentTransaction();
            transaction.setOrderId(orderId);
            transaction.setVnpTxnRef(vnp_TxnRef);
            transaction.setAmount(totalPrice);
            transaction.setStatus("Pending");
            transaction.setCreatedAt(new Date());
            transDAO.insertTransaction(transaction);

            // 8️⃣ Chuẩn bị tham số gửi sang VNPay
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", "2.1.0");
            vnp_Params.put("vnp_Command", "pay");
            vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(totalPrice.multiply(BigDecimal.valueOf(100)).intValue()));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang #" + orderId);
            vnp_Params.put("vnp_OrderType", "billpayment");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
            vnp_Params.put("vnp_IpAddr", request.getRemoteAddr());

            // Thời gian tạo/expire
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            vnp_Params.put("vnp_CreateDate", formatter.format(cld.getTime()));
            cld.add(Calendar.MINUTE, 15);
            vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

            // 9️⃣ Sinh chuỗi hash và redirect VNPay
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            for (String field : fieldNames) {
                String value = vnp_Params.get(field);
                if (value != null && !value.isEmpty()) {
                    hashData.append(field).append('=').append(URLEncoder.encode(value, StandardCharsets.UTF_8)).append('&');
                    query.append(field).append('=').append(URLEncoder.encode(value, StandardCharsets.UTF_8)).append('&');
                }
            }

            // Bỏ ký tự '&' cuối
            hashData.setLength(hashData.length() - 1);
            query.setLength(query.length() - 1);

            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + vnp_SecureHash;

            // 10️⃣ Xóa giỏ hàng tạm, redirect người dùng sang VNPay
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect(paymentUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi trong quá trình thanh toán VNPay!");
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }
}
