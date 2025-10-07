/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.warehouse;

import dao.StockMovementDAO;
import dao.WarehouseProductDAO;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "StockServlet", urlPatterns = {"/warehouse/stock-action"})
public class StockServlet extends HttpServlet {

    private StockMovementDAO dao = new StockMovementDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int productId = Integer.parseInt(req.getParameter("productId"));
        int warehouseId = Integer.parseInt(req.getParameter("warehouseId"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));

        // Lấy số lượng tồn hiện tại trong kho
        WarehouseProductDAO wpDao = new WarehouseProductDAO();
        int currentStock = wpDao.getCurrentStock(productId, warehouseId);

        HttpSession session = req.getSession();
        boolean ok = false;
        String action = req.getParameter("action");
        String actionText = "";

        if ("in".equals(action)) {
            actionText = "Nhập kho";
            ok = dao.stockIn(productId, warehouseId, quantity);
        } else if ("out".equals(action)) {
            actionText = "Xuất kho";
            if (quantity > currentStock) {
                session.setAttribute("msg", "Không thể " + actionText + " quá số lượng tồn (" + currentStock + ")");
                session.setAttribute("msgType", "danger");
            } else {
                ok = dao.stockOut(productId, warehouseId, quantity);
            }
        } else if ("transfer".equals(action)) {
            actionText = "Chuyển kho";
            int toWh = Integer.parseInt(req.getParameter("toWarehouseId"));
            if (quantity > currentStock) {
                session.setAttribute("msg", "Không thể " + actionText + " quá số lượng tồn (" + currentStock + ")");
                session.setAttribute("msgType", "danger");
            } else {
                ok = dao.transfer(productId, warehouseId, toWh, quantity);
            }
        }

        if (ok) {
            session.setAttribute("msg", actionText + " thành công!");
            session.setAttribute("msgType", "success");
        } else if (session.getAttribute("msg") == null) {
            session.setAttribute("msg", actionText + " thất bại!");
            session.setAttribute("msgType", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/warehouse/warehouse-products?wid=" + warehouseId);
    }

}
