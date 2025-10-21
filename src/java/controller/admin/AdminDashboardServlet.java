package controller.admin;

import dao.AdminDashboardDAO;
import dao.StoreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


@WebServlet(name = "AdminDashboard", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();
        StoreDAO storeDAO = new StoreDAO();

        // 🔹 Lấy các dữ liệu tổng
        int totalUsers = dashboardDAO.getTotalUsers();
        int totalProducts = dashboardDAO.getTotalProducts();
        int totalOrders = dashboardDAO.getTotalOrders();
        double totalRevenue = dashboardDAO.getTotalRevenue();
        int totalStores = storeDAO.countStores(); // ✅ thêm tổng số cửa hàng

        // 🔹 Gửi dữ liệu sang JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalStores", totalStores);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
