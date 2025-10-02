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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listStores(request, response, user);
                break;
            case "edit":
                editStore(request, response, user);
                break;
            case "delete":
                deleteStore(request, response, user);
                break;
            case "search":
                searchStores(request, response, user);
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
            if ("admin".equalsIgnoreCase(user.getRole())) {
                createStore(request, response, session);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tạo cửa hàng!");
            }
        } else if ("update".equals(action)) {
            if ("admin".equalsIgnoreCase(user.getRole())) {
                updateStore(request, response, session);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền cập nhật cửa hàng!");
            }
        } else {
            response.sendRedirect("store?action=list");
        }
    }

    private void searchStores(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Store> stores;

        if (keyword != null && !keyword.trim().isEmpty()) {
            stores = storeDAO.searchStoresByName(keyword.trim());
        } else {
            // Nếu không nhập gì thì load lại list bình thường
            stores = storeDAO.getAllStoresWithPaging(1);
        }

        request.setAttribute("stores", stores);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 1);

        // Load sellers nếu là admin (để hiện trong dropdown Add/Edit)
        if ("admin".equalsIgnoreCase(user.getRole())) {
            List<User> sellers = userDAO.getUsersByRole("seller");
            request.setAttribute("sellers", sellers);
        }

        request.getRequestDispatcher("storeList.jsp").forward(request, response);
    }

    // ====== LIST ======
    private void listStores(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int page = 1;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        List<Store> stores;
        int totalStores;

        if ("admin".equalsIgnoreCase(user.getRole())) {
            stores = storeDAO.getAllStoresWithPaging(page);
            totalStores = storeDAO.countAllStores();

            List<User> sellers = userDAO.getUsersByRole("Seller"); // lưu ý role trong DB viết hoa
            request.setAttribute("sellers", sellers);

        } else {
            stores = storeDAO.getStoresByUserWithPaging(user.getId(), page);
            totalStores = storeDAO.countStoresByUser(user.getId());
        }

        int totalPages = (int) Math.ceil(totalStores / 5.0);

        request.setAttribute("stores", stores);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("storeList.jsp").forward(request, response);
    }

    // ====== CREATE ======
    private void createStore(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException, ServletException {
        String storeName = request.getParameter("storeName");
        int userId = Integer.parseInt(request.getParameter("userId"));

        Store store = new Store();
        store.setUserId(userId);
        store.setStoreName(storeName);
        store.setCreatedAt(new Date());

        boolean created = storeDAO.createStore(store);

        if (created) {
            session.setAttribute("flash_success", "Tạo cửa hàng thành công!");
            response.sendRedirect("store?action=list&page=1");
        } else {
            request.setAttribute("error", "Tạo cửa hàng thất bại!");
            request.getRequestDispatcher("storeList.jsp").forward(request, response);
        }
    }

    // ====== EDIT ======
    private void editStore(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        int storeId = Integer.parseInt(request.getParameter("id"));
        Store store = storeDAO.getStoreById(storeId);

        request.setAttribute("store", store);

        if ("admin".equalsIgnoreCase(user.getRole())) {
            List<User> sellers = userDAO.getUsersByRole("Seller");
            request.setAttribute("sellers", sellers);
        }

        request.getRequestDispatcher("storeEdit.jsp").forward(request, response);
    }

    // ====== UPDATE ======
    private void updateStore(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException, ServletException {
        int storeId = Integer.parseInt(request.getParameter("storeId"));
        String storeName = request.getParameter("storeName");
        int userId = Integer.parseInt(request.getParameter("userId"));

        Store store = new Store();
        store.setStoreId(storeId);
        store.setStoreName(storeName);
        store.setUserId(userId);

        boolean updated = storeDAO.updateStore(store);

        if (updated) {
            session.setAttribute("flash_success", "Cập nhật cửa hàng thành công!");
            response.sendRedirect("store?action=list&page=1");
        } else {
            request.setAttribute("error", "Cập nhật cửa hàng thất bại!");
            request.setAttribute("store", store);
            request.getRequestDispatcher("storeEdit.jsp").forward(request, response);
        }
    }

    // ====== DELETE ======
    private void deleteStore(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xóa cửa hàng!");
            return;
        }

        int storeId = Integer.parseInt(request.getParameter("id"));
        boolean deleted = storeDAO.deleteStore(storeId);

        HttpSession session = request.getSession();
        if (deleted) {
            session.setAttribute("flash_success", "Xóa cửa hàng thành công!");
        } else {
            session.setAttribute("flash_error", "Xóa cửa hàng thất bại!");
        }

        response.sendRedirect("store?action=list&page=1");
    }
}
