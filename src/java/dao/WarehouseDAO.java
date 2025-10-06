package dao;

import entity.Warehouse;
import util.DBContext;
import util.PagedResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WarehouseDAO extends DBContext {

    private Warehouse map(ResultSet rs) throws SQLException {
        return new Warehouse(
                rs.getInt("WarehouseId"),
                rs.getString("Name"),
                rs.getString("Location"),
                rs.getString("status")
        );
    }

    public PagedResult<Warehouse> search(String keyword, int page, int pageSize) {
        String base = " FROM Warehouses ";
        String where = "";
        List<Object> params = new ArrayList<>();

        if (keyword != null && !(keyword = keyword.trim()).isEmpty()) {
            where = " WHERE Name LIKE ? OR Location LIKE ? ";
            String like = "%" + keyword + "%";
            params.add(like);
            params.add(like);
        }

        // Count
        int total = 0;
        String sqlCount = "SELECT COUNT(*)" + base + where;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Data
        String sqlData
                = "SELECT WarehouseId, Name, Location, status " + base + where
                + " ORDER BY WarehouseId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Warehouse> items = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlData)) {
            int idx = 1;
            for (Object p : params) {
                ps.setObject(idx++, p);
            }
            int offset = (Math.max(page, 1) - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PagedResult<>(items, total, page, pageSize);
    }

    public boolean add(Warehouse w) {
        String sql = "INSERT INTO Warehouses (Name, Location) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, w.getName());
            ps.setString(2, w.getLocation());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Warehouse w) {
        String sql = "UPDATE Warehouses SET Name=?, Location=? WHERE WarehouseId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, w.getName());
            ps.setString(2, w.getLocation());
            ps.setInt(3, w.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Warehouses WHERE WarehouseId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean toggleStatus(int id) {
        String sql = "UPDATE Warehouses SET Status = CASE WHEN Status='ACTIVE' THEN 'INACTIVE' ELSE 'ACTIVE' END WHERE WarehouseId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public PagedResult<Warehouse> searchActive(String keyword, int page, int pageSize) {
        String base = " FROM Warehouses WHERE Status='ACTIVE' ";
        String where = "";
        List<Object> params = new ArrayList<>();

        if (keyword != null && !(keyword = keyword.trim()).isEmpty()) {
            where = " AND (Name LIKE ? OR Location LIKE ?) ";
            String like = "%" + keyword + "%";
            params.add(like);
            params.add(like);
        }

        // Count
        int total = 0;
        String sqlCount = "SELECT COUNT(*) " + base + where;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Data
        String sqlData = "SELECT WarehouseId, Name, Location, Status "
                + base + where + " ORDER BY WarehouseId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Warehouse> items = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlData)) {
            int idx = 1;
            for (Object p : params) {
                ps.setObject(idx++, p);
            }
            int offset = (Math.max(page, 1) - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new PagedResult<>(items, total, page, pageSize);
    }

    /**
     * Lấy tất cả kho ACTIVE (dùng cho transfer dropdown)
     */
    public List<Warehouse> getAllActive() {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT WarehouseId, Name, Location, Status FROM Warehouses WHERE Status='ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Warehouse getById(int id) {
        String sql = "SELECT WarehouseId, Name, Location, Status FROM Warehouses WHERE WarehouseId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
