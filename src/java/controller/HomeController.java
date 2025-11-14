package controller;

import dao.CategoryDAO;
import dao.HomePageDAO;
import dao.ProductDAO;
import dao.StoreDAO;
import entity.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final StoreDAO storeDAO = new StoreDAO();
    private final HomePageDAO homePageDAO = new HomePageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryParam = request.getParameter("categoryId");
        String pageParam = request.getParameter("page");
        String keyword = request.getParameter("keyword");

        Integer categoryId = (categoryParam != null && !categoryParam.isEmpty())
                ? Integer.parseInt(categoryParam) : null;

        int pageIndex = (pageParam != null && !pageParam.isEmpty())
                ? Integer.parseInt(pageParam) : 1;

        int pageSize = 12;

        // Sidebar categories
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("selectedCategoryId", categoryId);

        List<Product> products;
        int totalProducts;

        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search
            products = productDAO.searchProductsByName(keyword, pageIndex, pageSize);
            totalProducts = productDAO.getTotalProductCountByName(keyword);

        } else if (categoryId != null) {
            // Filter by category
            products = productDAO.getProductsByCategoryAndPage(categoryId, pageIndex);
            totalProducts = productDAO.getTotalProductCountByCategory(categoryId);

        } else {
            // All products
            products = productDAO.getProductsByPage(pageIndex);
            totalProducts = productDAO.getTotalProductCount();
        }

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("products", products);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);

        // ============================
        // 🔥 HANDLE STORE LIST SECTION
        // ============================

        // 1. Lấy productCountMap {storeId -> số sản phẩm}
        Map<Integer, Integer> productCountMap = storeDAO.getProductCountOfStores();

        // 2. Lấy toàn bộ store
        List<entity.Store> allStores = storeDAO.getAllStores();

        // 3. Sắp xếp store theo số sản phẩm giảm dần
        allStores.sort((a, b) -> {
            int countA = productCountMap.getOrDefault(a.getStoreId(), 0);
            int countB = productCountMap.getOrDefault(b.getStoreId(), 0);
            return Integer.compare(countB, countA);
        });

        // 4. Lấy top 5 store
        List<entity.Store> topStores = allStores.stream().limit(5).collect(Collectors.toList());

        // 5. Gửi ra JSP
        request.setAttribute("topStores", topStores);
        request.setAttribute("allStores", allStores);
        request.setAttribute("productCountMap", productCountMap);

        // Forward
        request.getRequestDispatcher("/user/home.jsp").forward(request, response);
    }
}
