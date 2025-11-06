package dao;

import entity.Review;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO extends DBContext {
    
    // Lấy tất cả review của một sản phẩm
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.ReviewId, r.ProductId, r.UserId, r.Rating, r.Comment, r.CreatedAt, " +
                     "u.FullName as UserName, u.Email as UserEmail " +
                     "FROM Reviews r " +
                     "LEFT JOIN Users u ON r.UserId = u.UserId " +
                     "WHERE r.ProductId = ? " +
                     "ORDER BY r.CreatedAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getInt("ReviewId"));
                    review.setProductId(rs.getInt("ProductId"));
                    review.setUserId(rs.getInt("UserId"));
                    review.setRating(rs.getInt("Rating"));
                    review.setComment(rs.getString("Comment"));
                    review.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    review.setUserName(rs.getString("UserName"));
                    review.setUserEmail(rs.getString("UserEmail"));
                    list.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Thêm review mới
    public boolean addReview(Review review) {
        String sql = "INSERT INTO Reviews (ProductId, UserId, Rating, Comment, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật review (chỉ user tạo mới được edit)
    public boolean updateReview(int reviewId, int userId, int rating, String comment) {
        String sql = "UPDATE Reviews SET Rating = ?, Comment = ? " +
                     "WHERE ReviewId = ? AND UserId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, reviewId);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa review (có thể dùng cho admin hoặc user tự xóa)
    public boolean deleteReview(int reviewId, int userId) {
        String sql = "DELETE FROM Reviews WHERE ReviewId = ? AND UserId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy một review theo ID
    public Review getReviewById(int reviewId) {
        String sql = "SELECT r.ReviewId, r.ProductId, r.UserId, r.Rating, r.Comment, r.CreatedAt, " +
                     "u.FullName as UserName, u.Email as UserEmail " +
                     "FROM Reviews r " +
                     "LEFT JOIN Users u ON r.UserId = u.UserId " +
                     "WHERE r.ReviewId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getInt("ReviewId"));
                    review.setProductId(rs.getInt("ProductId"));
                    review.setUserId(rs.getInt("UserId"));
                    review.setRating(rs.getInt("Rating"));
                    review.setComment(rs.getString("Comment"));
                    review.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    review.setUserName(rs.getString("UserName"));
                    review.setUserEmail(rs.getString("UserEmail"));
                    return review;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Kiểm tra user đã review sản phẩm này chưa
    public boolean hasUserReviewed(int productId, int userId) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE ProductId = ? AND UserId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Tính rating trung bình
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews WHERE ProductId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // Đếm số lượng review
    public int countReviews(int productId) {
        String sql = "SELECT COUNT(*) FROM Reviews WHERE ProductId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}