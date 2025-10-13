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
        User currentUser = (User) session.getAttribute("user");
        String roleStr = (currentUser.getRole() == null ? "" : currentUser.getRole().trim()).toLowerCase();
        if (!"admin".equals(roleStr)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Lấy action
        String action = request.getParameter("action") != null ? request.getParameter("action") : "list";

        switch (action) {
            case "add":
                // Hiển thị form thêm người dùng
                request.getRequestDispatcher("/user/addUser.jsp").forward(request, response);
                break;

            case "edit":
                // Hiển thị form chỉnh sửa người dùng
                int id = Integer.parseInt(request.getParameter("id"));
                User existingUser = userDAO.getById(id);
                if (existingUser != null) {
                    request.setAttribute("user", existingUser);
                    request.getRequestDispatcher("/user/editUser.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "User not found!");
                    request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
                }
                break;

            case "delete":
                deleteUser(request, response);
                break;

            case "active":
            case "deactive":
                setUserStatus(request, response);
                break;

            case "list":
            default:
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
        User currentUser = (User) session.getAttribute("user");
        String roleStr = (currentUser.getRole() == null ? "" : currentUser.getRole().trim()).toLowerCase();
        if (!"admin".equals(roleStr)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }

    // ==================================================
    // =============== HIỂN THỊ DANH SÁCH ===============
    // ==================================================
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String searchFullName = request.getParameter("searchFullName");
        String searchRole = request.getParameter("searchRole");
        String searchStatus = request.getParameter("searchStatus");
        String searchEmail = request.getParameter("searchEmail");

        if (searchFullName != null && searchFullName.trim().isEmpty()) searchFullName = null;
        if (searchRole != null && searchRole.trim().isEmpty()) searchRole = null;
        if (searchStatus != null && searchStatus.trim().isEmpty()) searchStatus = null;
        if (searchEmail != null && searchEmail.trim().isEmpty()) searchEmail = null;

        List<User> users;
        int totalUsers;

        if (searchFullName != null || searchRole != null || searchStatus != null || searchEmail != null) {
            users = userDAO.searchUsers(searchFullName, searchRole, searchStatus, page);
            totalUsers = userDAO.getTotalUsersBySearch(searchFullName, searchRole, searchStatus);
        } else {
            users = userDAO.getAllWithPagination(page);
            totalUsers = userDAO.getTotalUsers();
        }

        int pageSize = 5;
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchFullName", searchFullName);
        request.setAttribute("searchRole", searchRole);
        request.setAttribute("searchStatus", searchStatus);
        request.setAttribute("searchEmail", searchEmail);

        request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
    }

    // ==================================================
    // ================== THÊM NGƯỜI DÙNG ===============
    // ==================================================
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        List<String> errors = validateUserData(email, password, fullName, role, status, true);
        if (!errors.isEmpty()) {
            request.setAttribute("validationErrors", errors);
            request.getRequestDispatcher("/user/addUser.jsp").forward(request, response);
            return;
        }

        if (userDAO.isEmailExist(email)) {
            List<String> existErrors = new ArrayList<>();
            existErrors.add("Email already exists!");
            request.setAttribute("validationErrors", existErrors);
            request.getRequestDispatcher("/user/addUser.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setFullName(fullName);
        user.setRole(role);
        user.setCreatedAt(new Date(System.currentTimeMillis()));
        user.setStatus(status != null ? status : "Active");

        boolean success = userDAO.add(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            List<String> addErrors = new ArrayList<>();
            addErrors.add("Failed to add user!");
            request.setAttribute("validationErrors", addErrors);
            request.getRequestDispatcher("/user/addUser.jsp").forward(request, response);
        }
    }

    // ==================================================
    // ================== CẬP NHẬT NGƯỜI DÙNG ===========
    // ==================================================
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String status = request.getParameter("status");

        User existingUser = userDAO.getById(id);
        if (existingUser == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
            return;
        }

        String email = existingUser.getEmail(); // không cho đổi email

        // Validate, password có thể bỏ trống
        List<String> errors = validateUserData(email, password, fullName, role, status, false);
        if (!errors.isEmpty()) {
            request.setAttribute("validationErrors", errors);
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("/user/editUser.jsp").forward(request, response);
            return;
        }

        // Nếu password trống, giữ nguyên mật khẩu cũ
        if (password == null || password.trim().isEmpty()) {
            password = existingUser.getPasswordHash();
        }

        User user = new User();
        user.setId(id);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setFullName(fullName);
        user.setRole(role);
        user.setCreatedAt(existingUser.getCreatedAt());
        user.setStatus(status);

        boolean success = userDAO.update(user);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            List<String> updateErrors = new ArrayList<>();
            updateErrors.add("Failed to update user!");
            request.setAttribute("validationErrors", updateErrors);
            request.setAttribute("user", user);
            request.getRequestDispatcher("/user/editUser.jsp").forward(request, response);
        }
    }

    // ==================================================
    // =================== XÓA NGƯỜI DÙNG ===============
    // ==================================================
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getById(id);
        if (user == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.deleteUser(id);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            request.setAttribute("error", "Failed to delete user! Possibly related data exists.");
            request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
        }
    }

    // ==================================================
    // ============== ACTIVE / DEACTIVE USER ============
    // ==================================================
    private void setUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String action = request.getParameter("action");
        String status = "active".equalsIgnoreCase(action) ? "Active" : "Deactive";

        User user = userDAO.getById(id);
        if (user == null) {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.setUserStatus(id, status);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        } else {
            request.setAttribute("error", "Failed to update user status!");
            request.getRequestDispatcher("/user/userList.jsp").forward(request, response);
        }
    }

    // ==================================================
    // ================= VALIDATION LOGIC ===============
    // ==================================================
    private List<String> validateUserData(String email, String password, String fullName,
                                          String role, String status, boolean isAdd) {
        List<String> errors = new ArrayList<>();

        if (isAdd) {
            if (email == null || email.trim().isEmpty()) {
                errors.add("Email is required.");
            } else if (!email.matches("^[\\w-_.+]*[\\w-_.]@([\\w]+[.])+[\\w]+[\\w]$")) {
                errors.add("Invalid email format.");
            }

            if (password == null || password.trim().isEmpty()) {
                errors.add("Password is required.");
            } else if (password.length() < 6) {
                errors.add("Password must be at least 6 characters.");
            }
        } else {
            if (password != null && !password.trim().isEmpty() && password.length() < 6) {
                errors.add("Password must be at least 6 characters.");
            }
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.add("Full Name is required.");
        }

        if (role == null || role.trim().isEmpty()) {
            errors.add("Role is required.");
        }

        if (status == null || status.trim().isEmpty()) {
            errors.add("Status is required.");
        } else if (!"Active".equals(status) && !"Deactive".equals(status)) {
            errors.add("Invalid status value.");
        }

        return errors;
    }
}
