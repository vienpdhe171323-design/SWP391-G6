package dao;

import entity.Order;
import entity.OrderItem;
import entity.Product;
import entity.SellerDashboardInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import util.DBContext;

public class SellerDAO extends DBContext {

    // =============================================
    // 1. Lấy StoreId theo UserId
    // =============================================
    public Integer getStoreIdByUserId(int userId) {
        String sql = "SELECT StoreId FROM Stores WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("StoreId");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // user không có store
    }

    // =============================================
    // 2. Lấy thống kê Dashboard
    // =============================================
    public SellerDashboardInfo getDashboardStats(int storeId) {
        SellerDashboardInfo info = new SellerDashboardInfo();

        // Tổng số sản phẩm
        String totalProductsQuery = "SELECT COUNT(*) AS total FROM Products WHERE StoreId = ?";
        // Sản phẩm gần hết hàng
        String lowStockQuery = "SELECT COUNT(*) AS total FROM Products WHERE StoreId = ? AND Stock < 5";
        // Tổng đơn hàng
        String totalOrdersQuery =
            "SELECT COUNT(DISTINCT o.OrderId) AS total " +
            "FROM Orders o " +
            "JOIN OrderItems oi ON o.OrderId = oi.OrderId " +
            "JOIN Products p ON p.ProductId = oi.ProductId " +
            "WHERE p.StoreId = ?";
        // Tổng doanh thu
        String revenueQuery =
            "SELECT SUM(oi.UnitPrice * oi.Quantity) AS revenue " +
            "FROM OrderItems oi " +
            "JOIN Products p ON oi.ProductId = p.ProductId " +
            "WHERE p.StoreId = ?";

        try {
            // Tổng sản phẩm
            PreparedStatement ps = connection.prepareStatement(totalProductsQuery);
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) info.setTotalProducts(rs.getInt("total"));

            // Sản phẩm sắp hết hàng
            ps = connection.prepareStatement(lowStockQuery);
            ps.setInt(1, storeId);
            rs = ps.executeQuery();
            if (rs.next()) info.setLowStockProducts(rs.getInt("total"));

            // Tổng đơn hàng
            ps = connection.prepareStatement(totalOrdersQuery);
            ps.setInt(1, storeId);
            rs = ps.executeQuery();
            if (rs.next()) info.setTotalOrders(rs.getInt("total"));

            // Doanh thu
            ps = connection.prepareStatement(revenueQuery);
            ps.setInt(1, storeId);
            rs = ps.executeQuery();
            if (rs.next()) info.setTotalRevenue(rs.getDouble("revenue"));

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return info;
    }

    // =============================================
    // 3. Lấy danh sách sản phẩm của seller
    // =============================================
    public List<Product> getSellerProducts(int storeId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products WHERE StoreId = ? ORDER BY ProductId DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("ProductId"),
                        rs.getInt("StoreId"),
                        rs.getInt("CategoryId"),
                        rs.getString("ProductName"),
                        rs.getBigDecimal("Price"),
                        rs.getInt("Stock"),
                        rs.getString("Status"),
                        rs.getString("ImageUrl")
                );
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================================
    // 4. Lấy danh sách đơn hàng của seller
    // =============================================
    public List<Order> getSellerOrders(int storeId) {
        List<Order> list = new ArrayList<>();

        String sql =
            "SELECT DISTINCT o.OrderId, o.UserId, u.FullName AS UserName, " +
            "o.OrderDate, o.TotalAmount, o.Status " +
            "FROM Orders o " +
            "JOIN OrderItems oi ON o.OrderId = oi.OrderId " +
            "JOIN Products p ON p.ProductId = oi.ProductId " +
            "JOIN Users u ON u.UserId = o.UserId " +
            "WHERE p.StoreId = ? " +
            "ORDER BY o.OrderDate DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order o = new Order(
                        rs.getInt("OrderId"),
                        rs.getInt("UserId"),
                        rs.getString("UserName"),
                        rs.getTimestamp("OrderDate"),
                        rs.getDouble("TotalAmount"),
                        rs.getString("Status")
                );
                list.add(o);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================================
    // 5. Lấy chi tiết 1 đơn hàng (Order + Items)
    // =============================================
    public List<OrderItem> getOrderItems(int orderId, int storeId) {
        List<OrderItem> list = new ArrayList<>();

        String sql =
            "SELECT oi.OrderItemId, oi.OrderId, oi.ProductId, p.ProductName, " +
            "oi.Quantity, oi.UnitPrice " +
            "FROM OrderItems oi " +
            "JOIN Products p ON p.ProductId = oi.ProductId " +
            "WHERE oi.OrderId = ? AND p.StoreId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, storeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem(
                        rs.getInt("OrderItemId"),
                        rs.getInt("OrderId"),
                        rs.getInt("ProductId"),
                        rs.getString("ProductName"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice")
                );
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================================
    // 6. Lấy TOP SP bán chạy
    // =============================================
    public Map<String, Integer> getTopSellingProducts(int storeId) {
        Map<String, Integer> map = new HashMap<>();

        String sql =
            "SELECT TOP 5 p.ProductName, SUM(oi.Quantity) AS Sold " +
            "FROM OrderItems oi " +
            "JOIN Products p ON p.ProductId = oi.ProductId " +
            "WHERE p.StoreId = ? " +
            "GROUP BY p.ProductName " +
            "ORDER BY Sold DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString("ProductName"), rs.getInt("Sold"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return map;
    }
    
    public List<Order> searchOrders(int storeId, String keyword, String from, String to, String sort, String status) {
    List<Order> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
        "SELECT DISTINCT o.OrderId, o.UserId, u.FullName AS UserName, " +
        "o.OrderDate, o.TotalAmount, o.Status " +
        "FROM Orders o " +
        "JOIN OrderItems oi ON o.OrderId = oi.OrderId " +
        "JOIN Products p ON p.ProductId = oi.ProductId " +
        "JOIN Users u ON u.UserId = o.UserId " +
        "WHERE p.StoreId = ? "
    );

    // Tìm theo tên
    if (keyword != null && !keyword.isEmpty()) {
        sql.append(" AND u.FullName LIKE ? ");
    }

    // Lọc theo ngày
    if (from != null && !from.isEmpty()) {
        sql.append(" AND o.OrderDate >= ? ");
    }
    if (to != null && !to.isEmpty()) {
        sql.append(" AND o.OrderDate <= ? ");
    }

    // Lọc theo trạng thái
    if (status != null && !status.isEmpty()) {
        sql.append(" AND o.Status = ? ");
    }

    // Sort theo tổng tiền
    if ("asc".equals(sort)) {
        sql.append(" ORDER BY o.TotalAmount ASC ");
    } else if ("desc".equals(sort)) {
        sql.append(" ORDER BY o.TotalAmount DESC ");
    } else {
        sql.append(" ORDER BY o.OrderDate DESC ");
    }

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        int index = 1;

        ps.setInt(index++, storeId);

        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(index++, "%" + keyword + "%");
        }

        if (from != null && !from.isEmpty()) {
            ps.setString(index++, from);
        }

        if (to != null && !to.isEmpty()) {
            ps.setString(index++, to);
        }

        if (status != null && !status.isEmpty()) {
            ps.setString(index++, status);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Order(
                    rs.getInt("OrderId"),
                    rs.getInt("UserId"),
                    rs.getString("UserName"),
                    rs.getTimestamp("OrderDate"),
                    rs.getDouble("TotalAmount"),
                    rs.getString("Status")
            ));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

}
