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

    private CompareDAO compareDAO = new CompareDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        List<Integer> compareList = (List<Integer>) session.getAttribute("compareList");
        if (compareList == null) compareList = new ArrayList<>();

        // ================== ADD ==================
        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            if (!compareList.contains(productId) && compareList.size() < 3) {
                compareList.add(productId);
            }
        }

        // ================== REMOVE ==================
        else if ("remove".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            compareList.remove(Integer.valueOf(productId));
        }

        // ================== CLEAR ==================
        else if ("clear".equals(action)) {
            compareList.clear();
        }

        session.setAttribute("compareList", compareList);
        response.sendRedirect("compare");
    }

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    List<Integer> compareList = (List<Integer>) session.getAttribute("compareList");

    List<ProductBox> products = compareDAO.getProductsForCompare(compareList);
    request.setAttribute("products", products);

    // ====== Calculate min price ======
    Integer minPrice = null;
    Integer maxStock = null;

    for (ProductBox p : products) {
        if (minPrice == null || p.getPrice().intValue() < minPrice) {
            minPrice = p.getPrice().intValue();
        }
        if (maxStock == null || p.getStock() > maxStock) {
            maxStock = p.getStock();
        }
    }

    request.setAttribute("minPrice", minPrice);
    request.setAttribute("maxStock", maxStock);

    request.getRequestDispatcher("compare.jsp").forward(request, response);
}

}
