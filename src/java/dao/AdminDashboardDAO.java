package dao;

import util.DBContext;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;

public class AdminDashboardDAO extends DBContext {

    /**
     * Đếm tổng số người dùng trong hệ thống
     */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public Map<String, Double> getRevenueByStore(String fromDate, String toDate) {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT s.StoreName, SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                + "JOIN Products p ON oi.ProductID = p.ProductID "
                + "JOIN Stores s ON p.StoreID = s.StoreID "
                + "WHERE o.Status = 'Completed' ";

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND o.OrderDate >= ?";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND o.OrderDate <= ?";
        }
        sql += " GROUP BY s.StoreName ORDER BY TotalRevenue DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(index++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("StoreName"), rs.getDouble("TotalRevenue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<String, Double> getRevenueByMonth(String fromDate, String toDate) {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(o.OrderDate, 'yyyy-MM') AS Month, "
                + "SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                + "WHERE o.Status = 'Completed' ";

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND o.OrderDate >= ?";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND o.OrderDate <= ?";
        }
        sql += " GROUP BY FORMAT(o.OrderDate, 'yyyy-MM') ORDER BY Month";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(index++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getString("Month"), rs.getDouble("TotalRevenue"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public double getTotalSystemRevenue(String fromDate, String toDate) {
        String sql = "SELECT SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue "
                + "FROM Orders o "
                + "JOIN OrderItems oi ON o.OrderID = oi.OrderID "
                + "WHERE o.Status = 'Completed' ";

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND o.OrderDate >= ?";
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND o.OrderDate <= ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(index++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(index++, toDate);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("TotalRevenue");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

}
