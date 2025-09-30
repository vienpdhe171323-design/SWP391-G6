package dao;

import util.PagedResult;
import entity.Supplier;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext {

    private Supplier map(ResultSet rs) throws SQLException {
        Supplier s = new Supplier();
        s.setId(rs.getInt("SupplierId"));
        s.setName(rs.getString("SupplierName"));
        s.setContactInfo(rs.getString("ContactInfo"));
        return s;
    }

    /** Tìm kiếm theo SupplierName/ContactInfo + phân trang (1 DAO) */
    public PagedResult<Supplier> search(String keyword, int page, int pageSize) {
        String base = " FROM Suppliers ";
        String where = "";
        List<Object> params = new ArrayList<>();

        if (keyword != null && !(keyword = keyword.trim()).isEmpty()) {
            where = " WHERE SupplierName LIKE ? OR ContactInfo LIKE ? ";
            String like = "%" + keyword + "%";
            params.add(like); params.add(like);
        }

        // Count
        int total = 0;
        String sqlCount = "SELECT COUNT(*)" + base + where;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            for (int i=0; i<params.size(); i++) ps.setObject(i+1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) total = rs.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }

        // Page data (SQL Server)
        String sqlData =
            "SELECT SupplierId, SupplierName, ContactInfo " +
            base + where +
            " ORDER BY SupplierId " +
            " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Supplier> items = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlData)) {
            int idx = 1;
            for (Object p : params) ps.setObject(idx++, p);
            int offset = (Math.max(page,1)-1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) items.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }

        return new PagedResult<>(items, total, Math.max(page,1), pageSize);
    }

    public Supplier getById(int id) {
        String sql = "SELECT SupplierId, SupplierName, ContactInfo FROM Suppliers WHERE SupplierId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return map(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean add(Supplier s) {
        String sql = "INSERT INTO Suppliers (SupplierName, ContactInfo) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getContactInfo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Supplier s) {
        String sql = "UPDATE Suppliers SET SupplierName=?, ContactInfo=? WHERE SupplierId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getContactInfo());
            ps.setInt(3, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
