package dao;

import entity.Product;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO extends DBContext {

    // Add product to wishlist
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT INTO Wishlist (UserId, ProductId, CreatedAt) VALUES (?, ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            return false; // Exists already (UNIQUE)
        }
    }

    // Remove a product
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM Wishlist WHERE UserId = ? AND ProductId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if user favorited product
    public boolean isFavorited(int userId, int productId) {
        String sql = "SELECT 1 FROM Wishlist WHERE UserId = ? AND ProductId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            return false;
        }
    }

    // Load wishlist products
    public List<Product> getWishlistProducts(int userId) {
        List<Product> list = new ArrayList<>();

        String sql = """
                SELECT p.*
                FROM Products p
                JOIN Wishlist w ON p.ProductId = w.ProductId
                WHERE w.UserId = ?
                ORDER BY w.CreatedAt DESC
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductId"));
                p.setStoreId(rs.getInt("StoreId"));
                p.setCategoryId(rs.getInt("CategoryId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setStatus(rs.getString("Status"));
                p.setImageUrl(rs.getString("ImageUrl"));
                list.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // Kiểm tra sản phẩm đã nằm trong Wishlist của user hay chưa
public boolean isWishlisted(int userId, int productId) {
    String sql = "SELECT 1 FROM Wishlist WHERE UserId = ? AND ProductId = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ResultSet rs = ps.executeQuery();
        return rs.next();  // nếu có bản ghi → đã yêu thích
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

}
