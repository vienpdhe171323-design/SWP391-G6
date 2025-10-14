package dao;

import entity.Category;
import entity.Product;
import entity.Store;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HomePageDAO extends DBContext {

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.ProductId, p.ProductName, p.Price, p.Stock, p.ImageUrl, "
                + "s.StoreName, c.CategoryName "
                + "FROM Products p "
                + "JOIN Stores s ON p.StoreId = s.StoreId "
                + "JOIN Categories c ON p.CategoryId = c.CategoryId "
                + "WHERE p.Status = 'Active' AND p.CategoryId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryId, CategoryName, ParentCategoryId FROM Categories ORDER BY CategoryId";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("CategoryId"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setParentCategoryId((Integer) rs.getObject("ParentCategoryId"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getLatestProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.ProductId, p.ProductName, p.Price, p.Stock, p.ImageUrl, "
                + "s.StoreName, c.CategoryName "
                + "FROM Products p "
                + "JOIN Stores s ON p.StoreId = s.StoreId "
                + "JOIN Categories c ON p.CategoryId = c.CategoryId "
                + "WHERE p.Status = 'Active' ORDER BY p.ProductId DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = mapProduct(rs);
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getCheapProducts(double maxPrice, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.ProductId, p.ProductName, p.Price, p.Stock, p.ImageUrl, "
                + "s.StoreName, c.CategoryName "
                + "FROM Products p "
                + "JOIN Stores s ON p.StoreId = s.StoreId "
                + "JOIN Categories c ON p.CategoryId = c.CategoryId "
                + "WHERE p.Price <= ? AND p.Status = 'Active' "
                + "ORDER BY p.Price ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setDouble(2, maxPrice);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getRandomProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.ProductId, p.ProductName, p.Price, p.Stock, p.ImageUrl, "
                + "s.StoreName, c.CategoryName "
                + "FROM Products p "
                + "JOIN Stores s ON p.StoreId = s.StoreId "
                + "JOIN Categories c ON p.CategoryId = c.CategoryId "
                + "WHERE p.Status = 'Active' ORDER BY NEWID()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Store> getTopStores(int limit) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT TOP (?) StoreId, StoreName, CreatedAt FROM Stores ORDER BY StoreId DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setCreatedAt(rs.getDate("CreatedAt"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("ProductId"));
        p.setProductName(rs.getString("ProductName"));
        p.setPrice(rs.getBigDecimal("Price"));
        p.setStock(rs.getInt("Stock"));
        p.setImageUrl(rs.getString("ImageUrl"));
        p.setStoreName(rs.getString("StoreName"));
        p.setCategoryName(rs.getString("CategoryName"));
        return p;
    }
}
