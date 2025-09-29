package controller;

import dao.SupplierDAO;
import entity.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SupplierServlet", urlPatterns = {"/suppliers"})
public class SupplierServlet extends HttpServlet {
    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listSuppliers(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "delete":
                deleteSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                createSupplier(request, response);
                break;
            case "update":
                updateSupplier(request, response);
                break;
            default:
                listSuppliers(request, response);
                break;
        }
    }

    private void listSuppliers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int pageIndex = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                pageIndex = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        //  lấy từ khóa tìm kiếm từ form
        String keyword = request.getParameter("search");

        List<Supplier> suppliers;
        int totalSuppliers;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Nếu có từ khóa thì gọi search
            suppliers = supplierDAO.searchSuppliersByName(keyword, pageIndex);
            totalSuppliers = supplierDAO.countSuppliersByName(keyword);
            request.setAttribute("search", keyword); // để giữ lại input search trong JSP
        } else {
            // Nếu không có từ khóa thì lấy toàn bộ
            suppliers = supplierDAO.getAllSuppliersWithPaging(pageIndex);
            totalSuppliers = supplierDAO.countSuppliers();
        }

        int totalPages = (int) Math.ceil((double) totalSuppliers / 5);

        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("suppliers.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Supplier supplier = supplierDAO.getSupplierById(id);
        request.setAttribute("supplier", supplier);
        request.getRequestDispatcher("supplier-detail.jsp").forward(request, response);
    }

    private void createSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        Supplier supplier = new Supplier(0, name, contact);
        supplierDAO.createSupplier(supplier);
        response.sendRedirect("suppliers?action=list");
    }

    private void updateSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        Supplier supplier = new Supplier(id, name, contact);
        supplierDAO.updateSupplier(supplier);
        response.sendRedirect("suppliers?action=list");
    }

    private void deleteSupplier(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        supplierDAO.deleteSupplier(id);
        response.sendRedirect("suppliers?action=list");
    }
}