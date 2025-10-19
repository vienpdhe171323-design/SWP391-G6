package dao;

import entity.Product;
import entity.ProductAttributeBox;
import entity.ProductBox;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBContext {

    public List<Product> getProductsByPage(int pageIndex) {
        List<Product> list = new ArrayList<>();
        int pageSize = 10;

        String sql = "SELECT * FROM ("
                + " SELECT ROW_NUMBER() OVER (ORDER BY p.ProductId ASC) AS RowNum, "
                + " p.ProductId, p.ProductName, p.Price, p.Stock, p.Status, p.ImageUrl, "
                + " c.CategoryName, s.StoreName "
                + " FROM Products p "
                + " JOIN Categories c ON p.CategoryId = c.CategoryId "
                + " JOIN Stores s ON p.StoreId = s.StoreId "
                + ") AS Result "
                + " WHERE RowNum BETWEEN (? - 1) * ? + 1 AND ? * ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pageIndex);
            ps.setInt(2, pageSize);
            ps.setInt(3, pageIndex);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setStatus(rs.getString("Status"));
                p.setImageUrl(rs.getString("ImageUrl"));

                p.setCategoryName(rs.getString("CategoryName"));
                p.setStoreName(rs.getString("StoreName"));

                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalProductCount() {
        String sql = "SELECT COUNT(*) FROM Products";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM Products WHERE ProductId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(
                        rs.getInt("ProductId"),
                        rs.getInt("StoreId"),
                        rs.getInt("CategoryId"),
                        rs.getString("ProductName"),
                        rs.getBigDecimal("Price"),
                        rs.getInt("Stock"),
                        rs.getString("Status"),
                        rs.getString("ImageUrl")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertProduct(Product p) {
        String sql = "INSERT INTO Products (StoreId, CategoryId, ProductName, Price, Stock, Status, ImageUrl) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getStoreId());
            ps.setInt(2, p.getCategoryId());
            ps.setString(3, p.getProductName());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getStatus());
            ps.setString(7, p.getImageUrl());

            ps.executeUpdate();

            // ✅ Lấy ProductId mới tạo
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // thất bại
    }

    public void updateProduct(Product p) {
        String sql = "UPDATE Products SET StoreId=?, CategoryId=?, ProductName=?, Price=?, Stock=?, Status=?, ImageUrl=? "
                + "WHERE ProductId=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, p.getStoreId());
            ps.setInt(2, p.getCategoryId());
            ps.setString(3, p.getProductName());
            ps.setBigDecimal(4, p.getPrice());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getStatus());
            ps.setString(7, p.getImageUrl());
            ps.setInt(8, p.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM Products WHERE ProductId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ProductBox getProductBoxById(int id) {
        String sql = """
        SELECT 
            p.ProductId,
            p.ProductName,
            p.Price,
            p.Stock,
            p.Status,
            p.ImageUrl,
            s.StoreName,
            CONVERT(varchar, s.CreatedAt, 103) AS StoreCreatedAt,
            c.CategoryName,
            pc.CategoryName AS ParentCategoryName
        FROM Products p
        JOIN Stores s ON p.StoreId = s.StoreId
        JOIN Categories c ON p.CategoryId = c.CategoryId
        LEFT JOIN Categories pc ON c.ParentCategoryId = pc.CategoryId
        WHERE p.ProductId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ProductBox box = new ProductBox(
                            rs.getInt("ProductId"),
                            rs.getString("ProductName"),
                            rs.getBigDecimal("Price"),
                            rs.getInt("Stock"),
                            rs.getString("Status"),
                            rs.getString("ImageUrl"),
                            rs.getString("StoreName"),
                            rs.getString("CategoryName"),
                            rs.getString("ParentCategoryName"),
                            rs.getString("StoreCreatedAt")
                    );

                    box.setAttributes(getAttributesByProduct(id));
                    return box;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ProductAttributeBox> getAttributesByProduct(int productId) {
        List<ProductAttributeBox> list = new ArrayList<>();
        String sql = """
        SELECT a.AttributeName, pa.Value
        FROM ProductAttributes pa
        JOIN Attributes a ON pa.AttributeId = a.AttributeId
        WHERE pa.ProductId = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ProductAttributeBox(
                            rs.getString("AttributeName"),
                            rs.getString("Value")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.ProductId, p.ProductName, p.Price, p.Stock, p.Status, p.ImageUrl, "
                + "s.StoreName, c.CategoryName "
                + "FROM Products p "
                + "JOIN Stores s ON p.StoreId = s.StoreId "
                + "JOIN Categories c ON p.CategoryId = c.CategoryId "
                + "WHERE p.Status = 'Active' AND p.CategoryId = ? "
                + "ORDER BY p.ProductId DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setStatus(rs.getString("Status"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setStoreName(rs.getString("StoreName"));
                p.setCategoryName(rs.getString("CategoryName"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Đếm tổng số sản phẩm theo CategoryId
    public int getTotalProductCountByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Products WHERE CategoryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

// ✅ Lấy sản phẩm theo Category + phân trang (ROW_NUMBER)
    public List<Product> getProductsByCategoryAndPage(int categoryId, int pageIndex) {
        List<Product> list = new ArrayList<>();
        int pageSize = 10;

        String sql = "SELECT * FROM ("
                + " SELECT ROW_NUMBER() OVER (ORDER BY p.ProductId ASC) AS RowNum, "
                + " p.ProductId, p.ProductName, p.Price, p.Stock, p.Status, p.ImageUrl, "
                + " c.CategoryName, s.StoreName "
                + " FROM Products p "
                + " JOIN Categories c ON p.CategoryId = c.CategoryId "
                + " JOIN Stores s ON p.StoreId = s.StoreId "
                + " WHERE p.CategoryId = ? "
                + ") AS Result "
                + " WHERE RowNum BETWEEN (? - 1) * ? + 1 AND ? * ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, pageIndex);
            ps.setInt(3, pageSize);
            ps.setInt(4, pageIndex);
            ps.setInt(5, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setStatus(rs.getString("Status"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setStoreName(rs.getString("StoreName"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> searchProductsByName(String keyword, int pageIndex, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                + " SELECT ROW_NUMBER() OVER (ORDER BY p.ProductId ASC) AS RowNum, "
                + " p.ProductId, p.ProductName, p.Price, p.Stock, p.Status, p.ImageUrl, "
                + " c.CategoryName, s.StoreName "
                + " FROM Products p "
                + " JOIN Categories c ON p.CategoryId = c.CategoryId "
                + " JOIN Stores s ON p.StoreId = s.StoreId "
                + " WHERE p.ProductName LIKE ? AND p.Status = 'Active' "
                + ") AS Result "
                + " WHERE RowNum BETWEEN (? - 1) * ? + 1 AND ? * ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, pageIndex);
            ps.setInt(3, pageSize);
            ps.setInt(4, pageIndex);
            ps.setInt(5, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setStatus(rs.getString("Status"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setStoreName(rs.getString("StoreName"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalProductCountByName(String keyword) {
        String sql = "SELECT COUNT(*) FROM Products WHERE ProductName LIKE ? AND Status = 'Active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
