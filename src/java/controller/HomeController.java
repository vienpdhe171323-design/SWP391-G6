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

        Integer categoryId = (categoryParam != null && !categoryParam.isEmpty()) ? Integer.parseInt(categoryParam) : null;
        int pageIndex = (pageParam != null) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 10;

        // Danh mục sidebar
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("selectedCategoryId", categoryId);

        List<Product> products;
        int totalProducts;

        if (categoryId != null) {
            products = productDAO.getProductsByCategoryAndPage(categoryId, pageIndex);
            totalProducts = productDAO.getTotalProductCountByCategory(categoryId);
        } else {
            products = productDAO.getProductsByPage(pageIndex);
            totalProducts = productDAO.getTotalProductCount();
        }

        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        request.setAttribute("products", products);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("topStores", storeDAO.getTopStores(5));

        request.getRequestDispatcher("/user/home.jsp").forward(request, response);
    }

}
