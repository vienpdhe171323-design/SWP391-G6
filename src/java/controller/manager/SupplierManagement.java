package controller.manager;

import dao.SupplierDAO;
import util.PagedResult;
import entity.Supplier;
import entity.User;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "SupplierManagement", urlPatterns = {"/manager/manager-supplier"})
public class SupplierManagement extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {

            String search = request.getParameter("search");
            int page = parseIntOrDefault(request.getParameter("page"), 1);
            int size = parseIntOrDefault(request.getParameter("size"), 10);

            SupplierDAO dao = new SupplierDAO();
            PagedResult<Supplier> result = dao.search(search, page, size);

            request.setAttribute("result", result);
            request.setAttribute("search", search == null ? "" : search);
            request.setAttribute("page", result.getPage());
            request.setAttribute("size", result.getPageSize());
            request.setAttribute("total", result.getTotal());
            request.setAttribute("totalPages", result.getTotalPages());

            request.getRequestDispatcher("manager-supplier.jsp").forward(request, response);
        } else {
            request.setAttribute("Bạn cần đăng nhập trước", "error");
            response.sendRedirect("../login");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action"); // add | edit
        String name = request.getParameter("name");
        String contact = request.getParameter("contactInfo");

        SupplierDAO dao = new SupplierDAO();
        Supplier s = new Supplier();
        s.setName(name);
        s.setContactInfo(contact);

        boolean ok = false;
        String label;
        try {
            if ("edit".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                s.setId(id);
                ok = dao.update(s);
                label = "Sửa";
            } else { // add
                ok = dao.add(s);
                label = "Thêm";
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            label = ("edit".equalsIgnoreCase(action)) ? "Sửa" : "Thêm";
        }

        HttpSession session = request.getSession();
        session.setAttribute(ok ? "alert_success" : "alert_error",
                ok ? (label + " thành công!") : (label + " thất bại. Vui lòng thử lại!"));

        response.sendRedirect(request.getContextPath() + "/manager/manager-supplier");
    }

    private int parseIntOrDefault(String s, int d) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return d;
        }
    }
}
