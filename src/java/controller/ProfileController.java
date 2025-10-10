package controller;

import dao.UserDAO;
import dao.UserProfileDAO;
import entity.User;
import entity.UserProfile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Date;

/**
 * ProfileController
 * Handle user profile viewing and updating (with avatar upload)
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 5 * 1024 * 1024,   // 5MB per file
    maxRequestSize = 10 * 1024 * 1024 // 10MB total
)
@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Load profile info
        UserProfileDAO profileDAO = new UserProfileDAO();
        UserProfile profile = profileDAO.getProfileByUserId(user.getId());

        request.setAttribute("user", user);
        request.setAttribute("profile", profile);

        // Show success message if available
        Object msg = session.getAttribute("flash_success");
        if (msg != null) {
            request.setAttribute("success", msg);
            session.removeAttribute("flash_success");
        }

        request.getRequestDispatcher("user/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // --- Get basic fields ---
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        Date dob = (dobStr == null || dobStr.isEmpty()) ? null : Date.valueOf(dobStr);

        // --- Handle avatar upload ---
        String avatarPath = null;
        Part filePart = request.getPart("avatarFile");

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadDirPath = getServletContext().getRealPath("/") + "uploads/avatars/";
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            File savedFile = new File(uploadDirPath + fileName);
            filePart.write(savedFile.getAbsolutePath());

            // Path to save in DB (relative to context)
            avatarPath = "uploads/avatars/" + fileName;
        }

        // --- Get current profile (for fallback data) ---
        UserProfileDAO profileDAO = new UserProfileDAO();
        UserProfile currentProfile = profileDAO.getProfileByUserId(user.getId());

        // --- Prepare profile object for update ---
        UserProfile updatedProfile = new UserProfile();
        updatedProfile.setUserId(user.getId());
        updatedProfile.setPhone(phone);
        updatedProfile.setAddress(address);
        updatedProfile.setDateOfBirth(dob);
        updatedProfile.setGender(gender);
        updatedProfile.setAvatarUrl(avatarPath != null ? avatarPath
                : (currentProfile != null ? currentProfile.getAvatarUrl() : null));

        // --- Update profile in DB ---
        profileDAO.updateProfile(updatedProfile);

        // --- Update full name in Users table ---
        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
            new UserDAO().updateFullName(user.getId(), fullName.trim());
        }

        // --- Update session info ---
        session.setAttribute("user", user);
        session.setAttribute("flash_success", "Profile updated successfully!");

        // Redirect back
        response.sendRedirect("profile");
    }
}
