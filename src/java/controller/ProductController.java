package controller;

import dao.AttributeDAO;
import dao.WishlistDAO;
import entity.User;

import dao.ProductDAO;
import dao.StoreDAO;
import dao.CategoryDAO;
import dao.ProductAttributeDAO;
import dao.ReviewDAO;
import entity.Product;
import entity.ProductBox;
import entity.Review;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
@MultipartConfig
public class ProductController extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private StoreDAO storeDAO = new StoreDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "detail":
                viewDetail(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                insertProduct(request, response);
                break;
            case "edit":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int pageIndex = 1;
        if (request.getParameter("page") != null) {
            pageIndex = Integer.parseInt(request.getParameter("page"));
        }

        int totalProducts = productDAO.getTotalProductCount();
        int pageSize = 10;
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        List<Product> list = productDAO.getProductsByPage(pageIndex);
        request.setAttribute("products", list);
        request.setAttribute("pageIndex", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("product/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("stores", storeDAO.getAllStores());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("attributes", new AttributeDAO().getAllAttributes());
        request.getRequestDispatcher("product/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Product product = productDAO.getProductById(id);
        Map<Integer, String> productAttrs = new ProductAttributeDAO().getAttributesByProductId(id);

        request.setAttribute("product", product);
        request.setAttribute("stores", storeDAO.getAllStores());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("attributes", new AttributeDAO().getAllAttributes());
        request.setAttribute("productAttrs", productAttrs);
        request.getRequestDispatcher("product/edit.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int storeId = Integer.parseInt(request.getParameter("storeId"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String productName = request.getParameter("productName");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String status = request.getParameter("status");

        //Upload ảnh
        Part filePart = request.getPart("imageFile");
        String fileName = (filePart != null) ? filePart.getSubmittedFileName() : "";
        String imagePath = "images/no-image.png";
        if (!fileName.isEmpty()) {
            String uploadDir = request.getServletContext().getRealPath("/images");
            filePart.write(uploadDir + File.separator + fileName);
            imagePath = "images/" + fileName;
        }

        Product p = new Product(0, storeId, categoryId, productName, price, stock, status, imagePath);
        int newProductId = productDAO.insertProduct(p);

        // ✅ Thêm thuộc tính
        if (newProductId > 0) {
            Map<Integer, String> attrs = new HashMap<>();

            // Ví dụ: bạn cho người dùng nhập giá trị trên form
            // <input name="attr_1"> → AttributeId = 1
            // <input name="attr_2"> → AttributeId = 2
            // Bạn lấy tất cả từ request
            for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
                String param = e.nextElement();
                if (param.startsWith("attr_")) {
                    int attrId = Integer.parseInt(param.substring(5)); // tách id sau "attr_"
                    String value = request.getParameter(param);
                    if (value != null && !value.isBlank()) {
                        attrs.put(attrId, value);
                    }
                }
            }

            new ProductAttributeDAO().insertProductAttributes(newProductId, attrs);
        }

        request.getSession().setAttribute("message", "Product added successfully!");
        response.sendRedirect("product?action=list");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int storeId = Integer.parseInt(request.getParameter("storeId"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String productName = request.getParameter("productName");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String status = request.getParameter("status");
        String oldImage = request.getParameter("oldImage");

        // upload ảnh nếu có
        Part filePart = request.getPart("imageFile");
        String imageUrl = oldImage;
        if (filePart != null && filePart.getSize() > 0) {
            String uploadDir = request.getServletContext().getRealPath("/images");
            String fileName = filePart.getSubmittedFileName();
            filePart.write(uploadDir + File.separator + fileName);
            imageUrl = "images/" + fileName;
        }

        Product p = new Product(id, storeId, categoryId, productName, price, stock, status, imageUrl);
        productDAO.updateProduct(p);

        // Cập nhật attributes
        Map<Integer, String> attrs = new HashMap<>();
        for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
            String param = e.nextElement();
            if (param.startsWith("attr_")) {
                int attrId = Integer.parseInt(param.substring(5));
                String value = request.getParameter(param);
                if (value != null && !value.isBlank()) {
                    attrs.put(attrId, value);
                }
            }
        }
        new ProductAttributeDAO().updateProductAttributes(id, attrs);

        request.getSession().setAttribute("message", "Product updated successfully!");
        response.sendRedirect("product?action=list");
    }

private void viewDetail(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    int id = Integer.parseInt(request.getParameter("id"));

    // ================== LOAD PRODUCT ==================
    ProductBox box = productDAO.getProductBoxById(id);
    request.setAttribute("productBox", box);

    // ================== LOAD REVIEWS ==================
    ReviewDAO reviewDAO = new ReviewDAO();
    List<Review> reviews = reviewDAO.getReviewsByProductId(id);
    double avgRating = reviewDAO.getAverageRating(id);
    int reviewCount = reviewDAO.countReviews(id);

    request.setAttribute("reviews", reviews);
    request.setAttribute("avgRating", avgRating);
    request.setAttribute("reviewCount", reviewCount);

    // ================== WISHLIST CHECK ==================
    WishlistDAO wishlistDAO = new WishlistDAO();

    boolean isWishlisted = false;   // default
    User sessionUser = (User) request.getSession().getAttribute("user");

    if (sessionUser != null) {
        int userId = sessionUser.getId();
        // ĐÚNG TÊN HÀM DAO
        isWishlisted = wishlistDAO.isWishlisted(userId, id);
    }

request.setAttribute("isFavorited", isWishlisted);

    // ======================================================

    request.getRequestDispatcher("product/detail.jsp").forward(request, response);
}



    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        productDAO.deleteProduct(id);
        request.getSession().setAttribute("message", "Product deleted successfully!");
        response.sendRedirect("product?action=list");
    }
}
