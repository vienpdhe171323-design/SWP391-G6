package controller.seller;

import dao.SellerDAO;
import entity.SellerDashboardInfo;
import entity.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/seller/dashboard")
public class SellerDashboardServlet extends HttpServlet {

    private SellerDAO sellerDAO = new SellerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra login
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // 2. Lấy StoreId theo UserId
        Integer storeId = sellerDAO.getStoreIdByUserId(user.getId());
        if (storeId == null) {
            request.setAttribute("error", "You don't have a store assigned!");
            request.getRequestDispatcher("/seller/dashboard.jsp").forward(request, response);
            return;
        }

        // 3. Lấy thống kê dashboard
        SellerDashboardInfo info = sellerDAO.getDashboardStats(storeId);

        // 4. Lấy top sản phẩm bán chạy
        var topSelling = sellerDAO.getTopSellingProducts(storeId);

        request.setAttribute("dashboard", info);
        request.setAttribute("topSelling", topSelling);
        request.setAttribute("storeId", storeId);

        request.getRequestDispatcher("/seller/dashboard.jsp").forward(request, response);
    }
}
