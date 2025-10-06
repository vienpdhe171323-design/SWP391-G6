/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.admin;

import dao.WarehouseDAO;
import entity.Warehouse;
import entity.User;
import util.PagedResult;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "WarehouseManagement", urlPatterns = {"/admin/manager-warehouse"})
public class WarehouseManagement extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            String search = req.getParameter("search");
            int page = parseIntOrDefault(req.getParameter("page"), 1);
            int size = parseIntOrDefault(req.getParameter("size"), 10);

            WarehouseDAO dao = new WarehouseDAO();
            PagedResult<Warehouse> result = dao.search(search, page, size);

            req.setAttribute("result", result);
            req.setAttribute("search", search == null ? "" : search);
            req.setAttribute("size", size);
            req.setAttribute("title", "Quản lý kho");

            req.getRequestDispatcher("manager-warehouse.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("../login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String name = req.getParameter("name");
        String location = req.getParameter("location");

        WarehouseDAO dao = new WarehouseDAO();
        Warehouse w = new Warehouse();
        w.setName(name);
        w.setLocation(location);

        boolean ok = false;
        HttpSession session = req.getSession();
        String message = "";
        String type = "success";

        if ("edit".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            w.setId(id);
            ok = dao.update(w);
            message = ok ? "Đã sửa kho thành công!" : "Sửa kho thất bại!";
        } else if ("add".equalsIgnoreCase(action)) {
            ok = dao.add(w);
            message = ok ? "Đã thêm kho thành công!" : "Thêm kho thất bại!";
        } else if ("toggle-status".equalsIgnoreCase(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            ok = dao.toggleStatus(id);
            if (ok) {
                message = "Đã đổi trạng thái kho thành công!";
            } else {
                message = "Đổi trạng thái kho thất bại!";
            }
        }

        // Set thông báo session
        session.setAttribute("msg", message);
        session.setAttribute("msgType", ok ? "success" : "danger");

        resp.sendRedirect(req.getContextPath() + "/admin/manager-warehouse");
    }

    private int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
