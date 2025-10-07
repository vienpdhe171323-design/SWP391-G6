/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.warehouse;

import dao.WarehouseDAO;
import entity.User;
import entity.Warehouse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import util.PagedResult;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "WarehouseServlet", urlPatterns = {"/warehouse/warehouses"})
public class WarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int size = parseIntOrDefault(req.getParameter("size"), 8);

        WarehouseDAO dao = new WarehouseDAO();
        PagedResult<Warehouse> result = dao.searchActive(search, page, size);

        req.setAttribute("result", result);
        req.setAttribute("search", search == null ? "" : search);
        req.setAttribute("size", size);
        req.setAttribute("title", "Danh sách kho");

        req.getRequestDispatcher("warehouse.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }

}
