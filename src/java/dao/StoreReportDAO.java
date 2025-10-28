package dao;

import entity.ProductReport;
import entity.StorePerformance;
import jakarta.servlet.http.HttpServletRequest;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StoreReportDAO extends DBContext {

    public double getTotalRevenue(int storeId) {
        String sql = """
    SELECT ISNULL(SUM(oi.Quantity * oi.UnitPrice), 0)
    FROM OrderItems oi
    JOIN Products p ON oi.ProductId = p.ProductId
    WHERE p.StoreId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int getTotalOrders(int storeId) {
        String sql = """
                SELECT COUNT(DISTINCT o.OrderId)
                FROM Orders o
                JOIN OrderItems oi ON o.OrderId = oi.OrderId
                JOIN Products p ON oi.ProductId = p.ProductId
                WHERE p.StoreId = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalProductsSold(int storeId) {
        String sql = """
                SELECT ISNULL(SUM(oi.Quantity), 0)
                FROM OrderItems oi
                JOIN Products p ON oi.ProductId = p.ProductId
                WHERE p.StoreId = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getAverageRating(int storeId) {
        String sql = """
                SELECT ISNULL(AVG(r.Rating), 0)
                FROM Reviews r
                JOIN Products p ON r.ProductId = p.ProductId
                WHERE p.StoreId = ?
                """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public List<ProductReport> getTopProducts(int storeId) {
        List<ProductReport> list = new ArrayList<>();
        String sql = """
    SELECT TOP 5 
        p.ProductId,
        p.ProductName,
        SUM(oi.Quantity) AS TotalSold,
        SUM(oi.Quantity * oi.UnitPrice) AS Revenue
    FROM OrderItems oi
    JOIN Products p ON oi.ProductId = p.ProductId
    WHERE p.StoreId = ?
    GROUP BY p.ProductId, p.ProductName
    ORDER BY TotalSold DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductReport pr = new ProductReport(
                        rs.getInt("ProductId"),
                        rs.getString("ProductName"),
                        rs.getInt("TotalSold"),
                        rs.getDouble("Revenue")
                );
                list.add(pr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public StorePerformance getStorePerformance(int storeId, String storeName) {
        double revenue = getTotalRevenue(storeId);
        int orders = getTotalOrders(storeId);
        int sold = getTotalProductsSold(storeId);
        double rating = getAverageRating(storeId);

        return new StorePerformance(storeId, storeName, revenue, orders, sold, rating);
    }

   // ==============================================
// 🧩 Helper: Lấy storeId theo userId
// ==============================================
public int getStoreIdByUser(int userId, HttpServletRequest request) {
    String sql = "SELECT TOP 1 StoreId, StoreName FROM Stores WHERE UserId = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            if (request != null) { // ✅ tránh lỗi khi chạy main()
                request.setAttribute("storeName", rs.getString("StoreName"));
            }
            return rs.getInt("StoreId");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}

    
    public static void main(String[] args) {
    StoreReportDAO dao = new StoreReportDAO();

    // 🔹 Thay đổi StoreId và StoreName cho đúng dữ liệu DB của bạn
    int testStoreId = 1;
    String testStoreName = "Store Alpha"; // hoặc Store Beta, v.v.

    System.out.println("===== 📊 TEST STORE PERFORMANCE =====");
    StorePerformance performance = dao.getStorePerformance(testStoreId, testStoreName);

    if (performance != null) {
        System.out.println("Store ID: " + performance.getStoreId());
        System.out.println("Store Name: " + performance.getStoreName());
        System.out.println("Total Revenue: " + performance.getTotalRevenue());
        System.out.println("Total Orders: " + performance.getTotalOrders());
        System.out.println("Total Products Sold: " + performance.getTotalProductsSold());
        System.out.println("Average Rating: " + performance.getAverageRating());
    } else {
        System.out.println("❌ Không tìm thấy dữ liệu cho store ID " + testStoreId);
    }

    System.out.println("\n===== 🏆 TOP 5 PRODUCTS =====");
    List<ProductReport> topProducts = dao.getTopProducts(testStoreId);
    if (topProducts.isEmpty()) {
        System.out.println("❌ Không có sản phẩm nào trong cửa hàng này.");
    } else {
        for (ProductReport p : topProducts) {
            System.out.println("- " + p.getProductName()
                    + " | Sold: " + p.getQuantitySold()
                    + " | Revenue: " + p.getTotalRevenue());
        }
    }

    // ✅ Test hàm lấy storeId theo userId (nếu cần)
    int testUserId = 3;
    int storeIdByUser = dao.getStoreIdByUser(testUserId, null);
    System.out.println("\nStoreId of user " + testUserId + ": " + storeIdByUser);
}

}
