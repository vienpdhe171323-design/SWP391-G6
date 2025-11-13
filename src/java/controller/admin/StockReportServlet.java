package controller.admin;

import dao.CategoryDAO;
import dao.StockReportDAO;
import dao.StoreDAO;
import entity.Category;
import entity.StockReport;
import entity.Store;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StockReportServlet", urlPatterns = {"/admin/stock-report"})
public class StockReportServlet extends HttpServlet {

    private StockReportDAO stockDAO = new StockReportDAO();
    private StoreDAO storeDAO = new StoreDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK LOGIN + ADMIN
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // FILTER PARAMS
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        Integer storeId = parseInt(request.getParameter("storeId"));
        Integer categoryId = parseInt(request.getParameter("categoryId"));

        // PAGINATION PARAMS
        int pageIndex = parseInt(request.getParameter("page")) != null ? parseInt(request.getParameter("page")) : 1;
        int pageSize = 10;

        // COUNT TOTAL DATA
        int totalRecords = stockDAO.countStockReport(search, storeId, categoryId);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // GET DATA
        List<StockReport> list = stockDAO.getStockReport(search, storeId, categoryId, sort, pageIndex, pageSize);

        // DROPDOWN DATA
        List<Store> stores = storeDAO.getAllStores();
        List<Category> categories = categoryDAO.getAllCategories();

        // SET ATTRIBUTES
        request.setAttribute("stores", stores);
        request.setAttribute("categories", categories);
        request.setAttribute("stockReport", list);

        request.setAttribute("search", search);
        request.setAttribute("sort", sort);
        request.setAttribute("storeId", storeId);
        request.setAttribute("categoryId", categoryId);

        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("../admin/stock_report.jsp").forward(request, response);
    }

    private Integer parseInt(String value) {
        try {
            if (value == null) return null;
            return Integer.parseInt(value);
        } catch (Exception e) {
            return null;
        }
    }
}
