package controller.store;

import dao.StoreDAO;
import dao.ProductDAO;
import dao.FollowStoreDAO;
import entity.Store;
import entity.Product;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/store/detail")
public class StoreDetailServlet extends HttpServlet {

    private final StoreDAO storeDAO = new StoreDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final FollowStoreDAO followDAO = new FollowStoreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy ID cửa hàng
        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect("../home");
            return;
        }

        int storeId = Integer.parseInt(idRaw);

        // Lấy thông tin cửa hàng và sản phẩm
        Store store = storeDAO.getStoreById(storeId);
        List<Product> products = productDAO.getProductsByStore(storeId);

        // Lấy người dùng đang đăng nhập
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        boolean isFollowing = false;

        // Nếu user đăng nhập → kiểm tra có follow chưa
        if (user != null) {
            isFollowing = followDAO.isFollowing(user.getId(), storeId);
        }

        // Gửi về JSP
        request.setAttribute("store", store);
        request.setAttribute("products", products);
        request.setAttribute("isFollowing", isFollowing);

        request.getRequestDispatcher("/store/store-detail.jsp").forward(request, response);
    }
}
