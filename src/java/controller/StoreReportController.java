package controller;

import dao.StoreReportDAO;
import entity.ProductReport;
import entity.StorePerformance;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StoreReportController", urlPatterns = {"/store-report"})
public class StoreReportController extends HttpServlet {

    private final StoreReportDAO reportDAO = new StoreReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 🔒 Tạm thời vẫn kiểm tra đăng nhập, nhưng KHÔNG kiểm tra role
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // 🚫 Tạm thời bỏ kiểm tra quyền
        /*
        String role = user.getRole().toLowerCase();
        if (!role.equals("admin") && !role.equals("seller")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền truy cập báo cáo hiệu suất cửa hàng!");
            return;
        }
        */

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view":
                viewStorePerformance(request, response, user);
                break;

            case "top-products":
                viewTopProducts(request, response, user);
                break;

            default:
                response.sendRedirect("dashboard.jsp");
        }
    }

    // ==============================================
    // 🧾 ACTION 1: Xem hiệu suất cửa hàng
    // ==============================================
    private void viewStorePerformance(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int storeId;
        String storeName = "";

        if ("admin".equalsIgnoreCase(user.getRole())) {
            String storeIdParam = request.getParameter("storeId");
            if (storeIdParam == null || storeIdParam.isEmpty()) {
                request.setAttribute("error", "Vui lòng chọn cửa hàng để xem báo cáo!");
                request.getRequestDispatcher("storeList.jsp").forward(request, response);
                return;
            }

            storeId = Integer.parseInt(storeIdParam);
            storeName = request.getParameter("storeName");

        } else {
            storeId = reportDAO.getStoreIdByUser(user.getId(), request);
            storeName = (String) request.getAttribute("storeName");

            if (storeId == 0) {
                request.setAttribute("error", "Bạn chưa có cửa hàng nào để xem báo cáo!");
                request.getRequestDispatcher("storeList.jsp").forward(request, response);
                return;
            }
        }

        StorePerformance perf = reportDAO.getStorePerformance(storeId, storeName);
        List<ProductReport> topProducts = reportDAO.getTopProducts(storeId);

        request.setAttribute("performance", perf);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("storeName", storeName);

        request.getRequestDispatcher("storeReport.jsp").forward(request, response);
    }

    // ==============================================
    // 🏆 ACTION 2: Xem top sản phẩm bán chạy
    // ==============================================
    private void viewTopProducts(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        // 🚫 Bỏ kiểm tra role ở đây luôn
        /*
        String role = user.getRole().toLowerCase();
        if (!role.equals("admin") && !role.equals("seller")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền truy cập báo cáo sản phẩm!");
            return;
        }
        */

        int storeId = Integer.parseInt(request.getParameter("storeId"));
        List<ProductReport> topProducts = reportDAO.getTopProducts(storeId);

        request.setAttribute("topProducts", topProducts);
        request.getRequestDispatcher("storeTopProducts.jsp").forward(request, response);
    }
}
