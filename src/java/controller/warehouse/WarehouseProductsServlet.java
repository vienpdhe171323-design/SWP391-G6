package controller.warehouse;

import dao.WarehouseDAO;
import dao.WarehouseProductDAO;
import entity.Warehouse;
import util.PagedResult;
import entity.Product;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/warehouse/warehouse-products")
public class WarehouseProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu đúng role → xử lý như cũ
        int wid = parseIntOrDefault(req.getParameter("wid"), -1);
        if (wid == -1) {
            resp.sendRedirect("warehouses");
            return;
        }

        String search = req.getParameter("search");
        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int size = parseIntOrDefault(req.getParameter("size"), 10);

        WarehouseProductDAO pdao = new WarehouseProductDAO();
        WarehouseDAO wdao = new WarehouseDAO();

        PagedResult<Product> result = pdao.getProductsByWarehouse(wid, search, page, size);
        Warehouse warehouse = wdao.getAllActive().stream()
                .filter(w -> w.getId() == wid).findFirst().orElse(null);

        req.setAttribute("warehouse", warehouse);
        req.setAttribute("result", result);
        req.setAttribute("search", search == null ? "" : search);
        req.setAttribute("size", size);
        req.setAttribute("title", "Quản lý kho " + warehouse.getName());
        req.setAttribute("allWarehouses", wdao.getAllActive());

        req.getRequestDispatcher("warehouse-products.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
