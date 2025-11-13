package controller.store;

import dao.StoreDAO;
import dao.ProductDAO;
import entity.Store;
import entity.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/store/detail")
public class StoreDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int storeId = Integer.parseInt(request.getParameter("id"));

        StoreDAO storeDAO = new StoreDAO();
        ProductDAO productDAO = new ProductDAO();

        Store store = storeDAO.getStoreById(storeId);
        List<Product> products = productDAO.getProductsByStore(storeId);

        request.setAttribute("store", store);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/store/store-detail.jsp").forward(request, response);
    }
}
