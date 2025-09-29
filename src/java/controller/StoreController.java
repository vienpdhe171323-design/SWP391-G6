package controller;

import dao.StoreDAO;
import dao.UserDAO;
import entity.Store;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "StoreController", urlPatterns = {"/store"})
public class StoreController extends HttpServlet {

    private final StoreDAO storeDAO = new StoreDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listStores(request, response, user);
                break;
            default:
                response.sendRedirect("store?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            // Chỉ admin được phép tạo
            if ("admin".equalsIgnoreCase(user.getRole())) {
                createStore(request, response, session);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tạo cửa hàng!");
            }
        } else {
            response.sendRedirect("store?action=list");
        }
    }

    private void listStores(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int page = 1;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Store> stores;
        int totalStores;

        if ("admin".equalsIgnoreCase(user.getRole())) {
            // Admin thấy tất cả store
            stores = storeDAO.getAllStoresWithPaging(page);
            totalStores = storeDAO.countAllStores();

            // Admin có quyền tạo store cho seller
            List<User> sellers = userDAO.getUsersByRole("seller");
            request.setAttribute("sellers", sellers);

        } else {
            // Seller chỉ thấy store của mình
            stores = storeDAO.getStoresByUserWithPaging(user.getId(), page);
            totalStores = storeDAO.countStoresByUser(user.getId());
        }

        int totalPages = (int) Math.ceil(totalStores / 5.0);

        request.setAttribute("stores", stores);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("storeList.jsp").forward(request, response);
    }

private void createStore(HttpServletRequest request, HttpServletResponse response, HttpSession session)
        throws IOException, ServletException {
    String storeName = request.getParameter("storeName");
    int userId = Integer.parseInt(request.getParameter("userId")); // Admin chọn seller

    Store store = new Store();
    store.setUserId(userId);
    store.setStoreName(storeName);
    store.setCreatedAt(new Date());

    boolean created = storeDAO.createStore(store);

    if (created) {
        session.setAttribute("flash_success", "Tạo cửa hàng thành công!");
        //luôn quay về trang đầu để hiển thị record mới
        response.sendRedirect("store?action=list&page=1");
    } else {
        request.setAttribute("error", "Tạo cửa hàng thất bại!");
        request.getRequestDispatcher("storeList.jsp").forward(request, response);
    }
}
}
