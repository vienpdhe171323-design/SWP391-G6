package dao;

import entity.Store;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Admin
 */
public class StoreDAO extends DBContext {

    public List<Store> getTopStores(int limit) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT TOP (?) StoreId, StoreName, CreatedAt "
                + "FROM Stores "
                + "ORDER BY StoreId DESC";
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

    // 🔹 Lấy danh sách tất cả store (id + name)
    public List<Store> getAllStores() {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT StoreId, StoreName, Status FROM Stores";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setStatus(rs.getString("Status"));
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Lấy tất cả store (cho admin), có phân trang + join lấy tên chủ sở hữu
    public List<Store> getAllStoresWithPaging(int pageIndex) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, s.Status, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "ORDER BY s.StoreId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName"),
                        rs.getString("Status")
                );
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Đếm tổng số store trong hệ thống
    public int countAllStores() {
        String sql = "SELECT COUNT(*) FROM Stores";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Lấy store theo userId (Seller)
    public List<Store> getStoresByUserWithPaging(int userId, int pageIndex) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, s.Status, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "WHERE s.UserId = ? "
                + "ORDER BY s.StoreId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName"),
                        rs.getString("Status")
                );
                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Đếm số store của một user (Seller)
    public int countStoresByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM Stores WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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

    // 🔹 Tạo mới store
    public boolean createStore(Store store) {
        String sql = "INSERT INTO Stores (UserId, StoreName, CreatedAt, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, store.getUserId());
            ps.setString(2, store.getStoreName());
            ps.setTimestamp(3, new Timestamp(store.getCreatedAt().getTime()));
            ps.setString(4, store.getStatus() == null ? "Active" : store.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Lấy store theo Id
    public Store getStoreById(int storeId) {
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, s.Status, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "WHERE s.StoreId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName"),
                        rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🔹 Cập nhật store
    public boolean updateStore(Store store) {
        String sql = "UPDATE Stores SET StoreName = ?, UserId = ?, Status = ? WHERE StoreId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, store.getStoreName());
            ps.setInt(2, store.getUserId());
            ps.setString(3, store.getStatus());
            ps.setInt(4, store.getStoreId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Xóa store theo StoreId
    public boolean deleteStore(int storeId) {
        String sql = "DELETE FROM Stores WHERE StoreId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, storeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Tìm kiếm store theo tên
    public List<Store> searchStoresByName(String keyword) {
        List<Store> list = new ArrayList<>();
        String sql = "SELECT s.StoreId, s.UserId, s.StoreName, s.CreatedAt, s.Status, u.FullName AS OwnerName "
                + "FROM Stores s "
                + "JOIN Users u ON s.UserId = u.UserId "
                + "WHERE s.StoreName LIKE ? "
                + "ORDER BY s.CreatedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Store s = new Store(
                        rs.getInt("StoreId"),
                        rs.getInt("UserId"),
                        rs.getString("StoreName"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OwnerName"),
                        rs.getString("Status")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Cập nhật trạng thái store (Suspend / Activate)
    public void updateStatus(int storeId, String status) {
        String sql = "UPDATE Stores SET Status = ? WHERE StoreId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, storeId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        StoreDAO dao = new StoreDAO();

        System.out.println("===== TEST getAllStores() =====");
        List<Store> stores = dao.getAllStores();

        if (stores.isEmpty()) {
            System.out.println("⚠️ Không có cửa hàng nào trong cơ sở dữ liệu!");
        } else {
            for (Store s : stores) {
                System.out.println(
                        "ID: " + s.getStoreId()
                        + " | Name: " + s.getStoreName()
                        + " | Status: " + s.getStatus()
                );
            }
        }

        System.out.println("===== END TEST =====");
    }

    public int countStores() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Stores";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

public Map<Integer, Integer> getProductCountOfStores() {
    Map<Integer, Integer> map = new HashMap<>();

    String sql = """
        SELECT s.StoreId, COUNT(p.ProductId) AS ProductCount
        FROM Stores s
        LEFT JOIN Products p ON s.StoreId = p.StoreId
        GROUP BY s.StoreId
        ORDER BY ProductCount DESC
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            map.put(rs.getInt("StoreId"), rs.getInt("ProductCount"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return map;
}


}
