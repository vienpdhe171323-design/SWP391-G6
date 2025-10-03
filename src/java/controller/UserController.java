package controller;

import dao.UserDAO;
import entity.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "UserController", urlPatterns = {"/user"})
public class UserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra vai trò admin
        User user = (User) session.getAttribute("user");
        String roleStr = (user.getRole() == null ? "" : user.getRole().trim()).toLowerCase();
        if (!"admin".equals(roleStr)) {
            response.sendRedirect(request.getContextPath() + "/home"); // Chuyển hướng về trang mặc định cho non-admin
            return;
        }

        String action = request.getParameter("action") != null ? request.getParameter("action") : "list";

        switch (action) {
            case "add":
                // Hiển thị form thêm user
                request.getRequestDispatcher("/userForm.jsp").forward(request, response);
                break;
            case "edit":
                // Hiển thị form sửa user
                int id = Integer.parseInt(request.getParameter("id"));
                User existingUser = userDAO.getById(id);
                if (existingUser != null) {
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("/userForm.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "User not found!");
                    request.getRequestDispatcher("/userList.jsp").forward(request, response);
                }
                break;
            case "delete":
                // Xử lý xóa user
                deleteUser(request, response);
                break;
            case "active":
            case "deactive":
                // Xử lý active/deactive user
                setUserStatus(request, response);
                break;
            case "search":
            case "list":
            default:
                // Hiển thị danh sách users với phân trang hoặc kết quả tìm kiếm
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra vai trò admin
        User user = (User) session.getAttribute("user");
        String roleStr = (user.getRole() == null ? "" : user.getRole().trim()).toLowerCase();
        if (!"admin".equals(roleStr)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            // Thêm user mới
            addUser(request, response);
        } else if ("update".equals(action)) {
            // Cập nhật user
            updateUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy số trang từ parameter, mặc định là trang 1
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // Lấy các tham số tìm kiếm
        String searchFullName = request.getParameter("searchFullName");
        if (searchFullName != null && searchFullName.trim().isEmpty()) {
            searchFullName = null;
        }
        String searchRole = request.getParameter("searchRole");
        if (searchRole != null && searchRole.trim().isEmpty()) {
            searchRole = null;
        }
        String searchStatus = request.getParameter("searchStatus");
        if (searchStatus != null && searchStatus.trim().isEmpty()) {
            searchStatus = null;
        }
        String searchEmail = request.getParameter("searchEmail");
        if (searchEmail != null && searchEmail.trim().isEmpty()) {
            searchEmail = null;
        }

        // Lấy tham số sắp xếp
        String sortOrder = request.getParameter("sortOrder");
        if (sortOrder != null && !sortOrder.matches("(?i)^(asc|desc)$")) {
            sortOrder = null; // Đặt lại nếu không hợp lệ
        }

        // Lấy danh sách users
        List<User> users;
        int totalUsers;
        if (searchFullName != null || searchRole != null || searchStatus != null || searchEmail != null) {
            users = userDAO.searchUsers(searchFullName, searchRole, searchStatus, page);
            totalUsers = userDAO.getTotalUsersBySearch(searchFullName, searchRole, searchStatus);
        } else if (sortOrder != null) {
            users = userDAO.getAllWithSort(sortOrder, page);
            totalUsers = userDAO.getTotalUsers();
        } else {
            users = userDAO.getAllWithPagination(page);
            totalUsers = userDAO.getTotalUsers();
        }
        request.setAttribute("users", users);

        // Tính tổng số trang để hiển thị phân trang
        int pageSize = 5;
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Lưu các tham số tìm kiếm và sắp xếp để giữ giá trị trong form
        request.setAttribute("searchFullName", searchFullName);
        request.setAttribute("searchRole", searchRole);
        request.setAttribute("searchStatus", searchStatus);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("sortOrder", sortOrder);

        // Chuyển đến JSP để hiển thị danh sách
        request.getRequestDispatcher("/userList.jsp").forward(request, response);
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Validate server-side
        List<String> errors = validateUserData(email, password, fullName, role, status, true); // true cho add
        if (!errors.isEmpty()) {
            request.setAttribute("validationErrors", errors);
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email đã tồn tại
        if (userDAO.isEmailExist(email)) {
            List<String> existErrors = new ArrayList<>();
            existErrors.add("Email already exists!");
            request.setAttribute("validationErrors", existErrors);
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User
        User user = new User();
        user.setEmail(email);
        user.setPasswordHash(password); // Sẽ được hash trong UserDAO
        user.setFullName(fullName);
        user.setRole(role);
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setStatus(status != null ? status : "Active");

        // Thêm user
        boolean success = userDAO.add(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            List<String> addErrors = new ArrayList<>();
            addErrors.add("Failed to add user!");
            request.setAttribute("validationErrors", addErrors);
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        // Lấy email cũ từ DB (không cho update email)
        User existingUser = userDAO.getById(id);
        if (existingUser == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }
        String email = existingUser.getEmail(); // Giữ nguyên email cũ

        // Validate server-side (không validate email vì không thay đổi)
        List<String> errors = validateUserData(email, password, fullName, role, status, false); // false cho update
        if (!errors.isEmpty()) {
            request.setAttribute("validationErrors", errors);
            request.setAttribute("user", existingUser); // Giữ dữ liệu để hiển thị lại modal
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }

        // Cập nhật đối tượng User
        User user = new User();
        user.setId(id);
        user.setEmail(email); // Giữ nguyên email cũ
        user.setPasswordHash(password); // Sẽ được hash trong UserDAO
        user.setFullName(fullName);
        user.setRole(role);
        user.setCreatedAt(existingUser.getCreatedAt()); // Giữ nguyên CreatedAt
        user.setStatus(status);

        // Cập nhật user
        boolean success = userDAO.update(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            List<String> updateErrors = new ArrayList<>();
            updateErrors.add("Failed to update user!");
            request.setAttribute("validationErrors", updateErrors);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Kiểm tra user tồn tại
        User user = userDAO.getById(id);
        if (user == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }

        // Xóa user
        boolean success = userDAO.deleteUser(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            request.setAttribute("error", "Failed to delete user! Possibly due to related data (orders, reviews, etc.).");
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
        }
    }

    private void setUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        String status = "active".equals(action) ? "Active" : "Deactive";

        // Kiểm tra user tồn tại
        User user = userDAO.getById(id);
        if (user == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
            return;
        }

        // Cập nhật trạng thái
        boolean success = userDAO.setUserStatus(id, status);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            request.setAttribute("error", "Failed to update user status!");
            request.getRequestDispatcher("/userList.jsp").forward(request, response);
        }
    }

    // Hàm validate server-side chung cho add và update
    private List<String> validateUserData(String email, String password, String fullName, String role, String status, boolean isAdd) {
        List<String> errors = new ArrayList<>();

        // Validate email (chỉ cho add, vì update không thay đổi)
        if (isAdd) {
            if (email == null || email.trim().isEmpty()) {
                errors.add("Email is required.");
            } else if (!email.matches("^[\\w-_.+]*[\\w-_.]@([\\w]+[.])+[\\w]+[\\w]$")) {
                errors.add("Invalid email format.");
            }
        }

        // Validate password
        if (password == null || password.trim().isEmpty()) {
            errors.add("Password is required.");
        } else if (password.length() < 6) {
            errors.add("Password must be at least 6 characters.");
        }

        // Validate fullName
        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Full Name is required.");
        }

        // Validate role
        if (role == null || role.trim().isEmpty()) {
            errors.add("Role is required.");
        }

        // Validate status
        if (status == null || status.trim().isEmpty()) {
            errors.add("Status is required.");
        } else if (!"Active".equals(status) && !"Deactive".equals(status)) {
            errors.add("Invalid status value.");
        }

        return errors;
    }
}