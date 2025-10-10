package dao;

import util.DBContext;
import java.sql.*;


public class AdminDashboardDAO extends DBContext {

    /**
     * Đếm tổng số người dùng trong hệ thống
     */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm tổng số đơn hàng
     */
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Đếm tổng số sản phẩm
     */
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Products";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Tính tổng doanh thu của các đơn hàng đã hoàn thành
     */
    public double getTotalRevenue() {
        String sql = "SELECT SUM(TotalAmount) FROM Orders WHERE Status = 'Completed'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
        public static void main(String[] args) {
        AdminDashboardDAO dao = new AdminDashboardDAO();

        System.out.println("=== TEST ADMIN DASHBOARD DAO ===");
        System.out.println("Total Users: " + dao.getTotalUsers());
        System.out.println("Total Products: " + dao.getTotalProducts());
        System.out.println("Total Orders: " + dao.getTotalOrders());
        System.out.println("Total Revenue (Completed Orders): " + dao.getTotalRevenue());
    }

}
