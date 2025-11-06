package dao;

import entity.ReviewReport;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewReportDAO extends DBContext {
    
    // Thêm báo cáo mới
    public boolean addReport(int reviewId, int reportedBy, String reportReason) {
        // Kiểm tra xem user đã report review này chưa
        if (hasUserReported(reviewId, reportedBy)) {
            return false; // Đã report rồi thì không cho report nữa
        }
        
        String sql = "INSERT INTO ReviewReports (ReviewId, ReportedBy, ReportReason, ReportedAt, Status) " +
                     "VALUES (?, ?, ?, GETDATE(), 'PENDING')";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, reportedBy);
            ps.setString(3, reportReason);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Kiểm tra user đã report review này chưa
    public boolean hasUserReported(int reviewId, int reportedBy) {
        String sql = "SELECT COUNT(*) FROM ReviewReports WHERE ReviewId = ? AND ReportedBy = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, reportedBy);
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
    
    // Lấy tất cả reports (dùng cho admin)
    public List<ReviewReport> getAllReports() {
        List<ReviewReport> list = new ArrayList<>();
        String sql = "SELECT * FROM ReviewReports ORDER BY ReportedAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReviewReport report = new ReviewReport();
                report.setReportId(rs.getInt("ReportId"));
                report.setReviewId(rs.getInt("ReviewId"));
                report.setReportedBy(rs.getInt("ReportedBy"));
                report.setReportReason(rs.getString("ReportReason"));
                report.setReportedAt(rs.getTimestamp("ReportedAt"));
                report.setStatus(rs.getString("Status"));
                list.add(report);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Đếm số lượng report của một review
    public int countReportsByReviewId(int reviewId) {
        String sql = "SELECT COUNT(*) FROM ReviewReports WHERE ReviewId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
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
    
    // Cập nhật trạng thái report (dùng cho admin)
    public boolean updateReportStatus(int reportId, String status) {
        String sql = "UPDATE ReviewReports SET Status = ? WHERE ReportId = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reportId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}