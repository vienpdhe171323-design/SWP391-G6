package dao;

import entity.Store;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Admin
 */
public class StoreDAO extends DBContext {
    
       // Lấy danh sách tất cả các store (id + name)
    public List<Store> getAllStores() {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT StoreId, StoreName FROM Stores";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("StoreId");
                String name = rs.getString("StoreName");
                Store s = new Store(id, name);
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy toàn bộ store (cho admin), có phân trang + join để lấy tên user
    public List<Store> getAllStoresWithPaging(int pageIndex) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "ORDER BY s.StoreId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số store trong hệ thống
    public int countAllStores() {
        String sql = "SELECT COUNT(*) FROM Stores";
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

    // Lấy store theo userId (Seller), có phân trang + join Users để lấy FullName
    public List<Store> getStoresByUserWithPaging(int userId, int pageIndex) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "WHERE s.UserId = ? "
                + "ORDER BY s.StoreId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm số store của một user (Seller)
    public int countStoresByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM Stores WHERE UserId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tạo mới store
    public boolean createStore(Store store) {
        String sql = "INSERT INTO Stores (UserId, StoreName, CreatedAt) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, store.getUserId());
            ps.setString(2, store.getStoreName());
            ps.setTimestamp(3, new java.sql.Timestamp(store.getCreatedAt().getTime()));

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy store theo Id
    public Store getStoreById(int storeId) {
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "WHERE s.StoreId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

// Cập nhật store
    public boolean updateStore(Store store) {
        String sql = "UPDATE Stores SET StoreName = ?, UserId = ? WHERE StoreId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, store.getStoreName());
            ps.setInt(2, store.getUserId());
            ps.setInt(3, store.getStoreId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Xóa store theo StoreId
    public boolean deleteStore(int storeId) {
        String sql = "DELETE FROM Stores WHERE StoreId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, storeId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Search store theo tên (LIKE)
    public List<Store> searchStoresByName(String keyword) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, u.FullName AS OwnerName "
                + "FROM Store s "
                + "JOIN Users u ON s.UserId = u.Id "
                + "WHERE s.StoreName LIKE ? "
                + "ORDER BY s.CreatedAt DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
