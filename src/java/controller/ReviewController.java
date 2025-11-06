package controller;

import dao.ReviewDAO;
import dao.ReviewReportDAO;
import entity.Review;
import entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.google.gson.Gson;
import jakarta.servlet.annotation.MultipartConfig;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ReviewController", urlPatterns = {"/review"})
@MultipartConfig
public class ReviewController extends HttpServlet {

    private ReviewDAO reviewDAO = new ReviewDAO();
    private ReviewReportDAO reportDAO = new ReviewReportDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        System.out.println(action);
        if (action == null) {
            sendError(response, "Action is required");
            return;
        }

        // Kiểm tra login
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            sendError(response, "Bạn cần đăng nhập để thực hiện chức năng này");
            return;
        }

        switch (action) {
            case "add":
                addReview(request, response, user);
                break;
            case "edit":
                editReview(request, response, user);
                break;
            case "delete":
                deleteReview(request, response, user);
                break;
            case "report":
                reportReview(request, response, user);
                break;
            default:
                sendError(response, "Invalid action");
                break;
        }
    }

    private void addReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Kiểm tra đã review chưa
            if (reviewDAO.hasUserReviewed(productId, user.getId())) {
                sendError(response, "Bạn đã đánh giá sản phẩm này rồi");
                return;
            }

            // Validate
            if (rating < 1 || rating > 5) {
                sendError(response, "Rating phải từ 1-5 sao");
                return;
            }

            if (comment == null || comment.trim().isEmpty()) {
                sendError(response, "Vui lòng nhập nội dung đánh giá");
                return;
            }

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment.trim());

            if (reviewDAO.addReview(review)) {
                sendSuccess(response, "Thêm đánh giá thành công");
            } else {
                sendError(response, "Có lỗi xảy ra khi thêm đánh giá");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Lỗi: " + e.getMessage());
        }
    }

    private void editReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            // Validate
            if (rating < 1 || rating > 5) {
                sendError(response, "Rating phải từ 1-5 sao");
                return;
            }

            if (comment == null || comment.trim().isEmpty()) {
                sendError(response, "Vui lòng nhập nội dung đánh giá");
                return;
            }

            // Chỉ user tạo review mới được edit
            if (reviewDAO.updateReview(reviewId, user.getId(), rating, comment.trim())) {
                sendSuccess(response, "Cập nhật đánh giá thành công");
            } else {
                sendError(response, "Không thể cập nhật. Bạn chỉ có thể sửa đánh giá của mình");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Lỗi: " + e.getMessage());
        }
    }

    private void deleteReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));

            if (reviewDAO.deleteReview(reviewId, user.getId())) {
                sendSuccess(response, "Xóa đánh giá thành công");
            } else {
                sendError(response, "Không thể xóa. Bạn chỉ có thể xóa đánh giá của mình");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Lỗi: " + e.getMessage());
        }
    }

    private void reportReview(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String reportReason = request.getParameter("reportReason");

            if (reportReason == null || reportReason.trim().isEmpty()) {
                sendError(response, "Vui lòng nhập lý do báo cáo");
                return;
            }

            // Kiểm tra xem có phải review của chính mình không
            Review review = reviewDAO.getReviewById(reviewId);
            if (review != null && review.getUserId() == user.getId()) {
                sendError(response, "Bạn không thể báo cáo đánh giá của chính mình");
                return;
            }

            if (reportDAO.addReport(reviewId, user.getId(), reportReason.trim())) {
                sendSuccess(response, "Báo cáo đã được gửi");
            } else {
                sendError(response, "Bạn đã báo cáo đánh giá này rồi");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Lỗi: " + e.getMessage());
        }
    }

    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", message);
        response.getWriter().write(gson.toJson(result));
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", false);
        result.put("message", message);
        response.getWriter().write(gson.toJson(result));
    }
}
