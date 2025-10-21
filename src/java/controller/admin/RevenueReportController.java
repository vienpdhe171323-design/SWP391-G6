package controller.admin;

import dao.AdminDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "RevenueReportController", urlPatterns = {"/admin/revenue-report"})
public class RevenueReportController extends HttpServlet {

    private final AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- 1️⃣ Lấy tham số từ form ---
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        if (fromDate != null && fromDate.isEmpty()) fromDate = null;
        if (toDate != null && toDate.isEmpty()) toDate = null;

        // --- 2️⃣ Lấy dữ liệu từ DAO ---
        Map<String, Double> revenueByStore = dashboardDAO.getRevenueByStore(fromDate, toDate);
        Map<String, Double> revenueByMonth = dashboardDAO.getRevenueByMonth(fromDate, toDate);
        double totalSystemRevenue = dashboardDAO.getTotalSystemRevenue(fromDate, toDate);

        // --- 3️⃣ Đặt attribute để JSP hiển thị ---
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("revenueByStore", revenueByStore);
        request.setAttribute("revenueByMonth", revenueByMonth);
        request.setAttribute("totalSystemRevenue", totalSystemRevenue);

        // --- 4️⃣ Forward đến trang JSP ---
        request.getRequestDispatcher("/admin/revenue-report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cho phép form submit bằng POST, xử lý như GET
        doGet(request, response);
    }
}
