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
/*    
    public static void main(String[] args) {
    StoreDAO storeDAO = new StoreDAO();

    // Tạo store mới để test
    Store store = new Store();
    store.setUserId(3); // gán đúng UserId có thật trong bảng Users (ví dụ seller có UserId = 3)
    store.setStoreName("Test Store ABC");
    store.setCreatedAt(new java.util.Date());

    boolean success = storeDAO.createStore(store);

    if (success) {
        System.out.println("Tạo store thành công!");
    } else {
        System.out.println("Tạo store thất bại!");
    }
}
*/

}
