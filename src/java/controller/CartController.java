package controller;

import dao.ProductDAO;
import entity.Cart;
import entity.CartItem;
import entity.Product;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("flash_error", "Vui lòng đăng nhập để xem giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("flash_error", "Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity") != null ? request.getParameter("quantity") : "1");

            // Lấy thông tin sản phẩm
            Product product = productDAO.getProductById(productId);
            if (product == null || !"Active".equals(product.getStatus())) {
                session.setAttribute("flash_error", "Sản phẩm không tồn tại hoặc không khả dụng.");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            // Lấy hoặc tạo giỏ hàng trong session
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
                session.setAttribute("cart", cart);
            }

            // Thêm sản phẩm vào giỏ hàng
            CartItem item = new CartItem(
                    product.getId(),
                    product.getProductName(),
                    product.getPrice(),
                    quantity,
                    product.getImageUrl()
            );
            cart.addItem(item);

            // Lưu thông báo thành công
            session.setAttribute("flash_success", "Đã thêm " + product.getProductName() + " vào giỏ hàng!");
            response.sendRedirect(request.getContextPath() + "/home");
        } else if ("remove".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                cart.removeItem(productId);
                session.setAttribute("flash_success", "Đã xóa sản phẩm khỏi giỏ hàng!");
            }
            response.sendRedirect(request.getContextPath() + "/cart");
        } else if ("update".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String change = request.getParameter("change");
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart != null) {
                for (CartItem item : cart.getItems()) {
                    if (item.getProductId() == productId) {
                        int newQuantity = item.getQuantity();
                        if ("increase".equals(change)) {
                            newQuantity++;
                        } else if ("decrease".equals(change)) {
                            newQuantity = Math.max(1, newQuantity - 1);
                        }
                        item.setQuantity(newQuantity);
                        session.setAttribute("flash_success", "Đã cập nhật số lượng sản phẩm " + item.getProductName() + "!");
                        break;
                    }
                }
                session.setAttribute("cart", cart);
            }
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}