package controller;

import dao.CompareDAO;
import entity.ProductBox;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/compare")
public class CompareServlet extends HttpServlet {

    private final CompareDAO compareDAO = new CompareDAO();

    // ================== POST: XỬ LÝ THÊM/XÓA SO SÁNH ==================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        List<Integer> compareList = getOrCreateCompareList(session);

        try {
            switch (action != null ? action : "") {
                case "add" -> handleAdd(request, compareList);
                case "remove" -> handleRemove(request, compareList);
                case "clear" -> compareList.clear();
                default -> { /* ignore */ }
            }
        } catch (NumberFormatException e) {
            // Invalid productId → ignore
        }

        session.setAttribute("compareList", compareList);
        response.sendRedirect(request.getContextPath() + "/compare");
    }

    // ================== GET: HIỂN THỊ TRANG SO SÁNH ==================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<Integer> compareList = getOrCreateCompareList(session);

        // Lấy danh sách sản phẩm + thuộc tính
        List<ProductBox> products = compareDAO.getProductsForCompare(compareList);
        request.setAttribute("products", products);

        // Tính giá thấp nhất & tồn kho cao nhất
        Integer minPrice = null;
        Integer maxStock = null;
        for (ProductBox p : products) {
            int price = p.getPrice().intValue();
            int stock = p.getStock();
            if (minPrice == null || price < minPrice) minPrice = price;
            if (maxStock == null || stock > maxStock) maxStock = stock;
        }
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxStock", maxStock);

        // GỬI DANH SÁCH TÊN THUỘC TÍNH DUY NHẤT (để hiển thị theo dòng)
        Set<String> allAttributeNames = new LinkedHashSet<>();
        for (ProductBox p : products) {
            for (var attr : p.getAttributes()) {
                allAttributeNames.add(attr.getAttributeName());
            }
        }
        request.setAttribute("allAttributeNames", new ArrayList<>(allAttributeNames));

        request.getRequestDispatcher("/compare.jsp").forward(request, response);
    }

    // ================== HELPER METHODS ==================

    /** Lấy hoặc tạo compareList từ session */
    private List<Integer> getOrCreateCompareList(HttpSession session) {
        List<Integer> list = (List<Integer>) session.getAttribute("compareList");
        if (list == null) {
            list = new ArrayList<>();
            session.setAttribute("compareList", list);
        }
        return list;
    }

    /** Thêm sản phẩm vào so sánh (tối đa 3) */
    private void handleAdd(HttpServletRequest request, List<Integer> compareList) {
        String idStr = request.getParameter("productId");
        if (idStr == null || idStr.isBlank()) return;

        int productId = Integer.parseInt(idStr);
        if (!compareList.contains(productId) && compareList.size() < 3) {
            compareList.add(productId);
        }
    }

    /** Xóa sản phẩm khỏi danh sách so sánh */
    private void handleRemove(HttpServletRequest request, List<Integer> compareList) {
        String idStr = request.getParameter("productId");
        if (idStr == null || idStr.isBlank()) return;

        int productId = Integer.parseInt(idStr);
        compareList.remove(Integer.valueOf(productId));
    }
}