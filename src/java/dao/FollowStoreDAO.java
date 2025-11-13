package dao;

import entity.FollowStore;
import entity.Store;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBContext;
public class FollowStoreDAO extends DBContext {

    /* ----------------------------
        CHECK USER ĐÃ FOLLOW CHƯA
       ---------------------------- */
    public boolean isFollowing(int userId, int storeId) {
        String sql = "SELECT 1 FROM FollowStore WHERE UserId = ? AND StoreId = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, storeId);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ----------------------------
            FOLLOW STORE
       ---------------------------- */
    public boolean followStore(int userId, int storeId) {
        // Nếu đã follow thì không insert nữa
        if (isFollowing(userId, storeId)) return false;

        String sql = "INSERT INTO FollowStore (UserId, StoreId, CreatedAt) VALUES (?, ?, GETDATE())";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, storeId);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ----------------------------
            UNFOLLOW STORE
       ---------------------------- */
    public boolean unfollowStore(int userId, int storeId) {
        String sql = "DELETE FROM FollowStore WHERE UserId = ? AND StoreId = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, storeId);
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ---------------------------------------------
          LẤY DANH SÁCH STORE USER ĐANG THEO DÕI
       --------------------------------------------- */
    public List<Store> getFollowedStores(int userId) {
        List<Store> list = new ArrayList<>();

        String sql = """
                SELECT s.StoreId, s.StoreName, s.UserId, s.CreatedAt, s.Status
                FROM FollowStore f
                JOIN Stores s ON f.StoreId = s.StoreId
                WHERE f.UserId = ?
                ORDER BY f.CreatedAt DESC
                """;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                Store s = new Store();
                s.setStoreId(rs.getInt("StoreId"));
                s.setStoreName(rs.getString("StoreName"));
                s.setUserId(rs.getInt("UserId"));
                s.setCreatedAt(rs.getDate("CreatedAt"));
                s.setStatus(rs.getString("Status"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
}
