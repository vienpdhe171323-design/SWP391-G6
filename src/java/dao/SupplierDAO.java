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
    
        // Lấy danh sách suppliers (có phân trang, 5 bản ghi mỗi trang)
    public List<Supplier> getAllSuppliersWithPaging(int pageIndex) {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT SupplierId, SupplierName, ContactInfo "
                + "FROM Suppliers "
                + "ORDER BY SupplierId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier(
                        rs.getInt("SupplierId"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactInfo")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số supplier
    public int countSuppliers() {
        String sql = "SELECT COUNT(*) FROM Suppliers";
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

    // Lấy supplier theo ID
    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT SupplierId, SupplierName, ContactInfo FROM Suppliers WHERE SupplierId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Supplier(
                        rs.getInt("SupplierId"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactInfo")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tạo mới supplier
    public boolean createSupplier(Supplier supplier) {
        String sql = "INSERT INTO Suppliers (SupplierName, ContactInfo) VALUES (?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getContactInfo());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật supplier
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE Suppliers SET SupplierName = ?, ContactInfo = ? WHERE SupplierId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getContactInfo());
            ps.setInt(3, supplier.getId());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa supplier
    public boolean deleteSupplier(int supplierId) {
        String sql = "DELETE FROM Suppliers WHERE SupplierId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, supplierId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Tìm kiếm suppliers theo tên (có phân trang, 5 bản ghi mỗi trang)
    public List<Supplier> searchSuppliersByName(String keyword, int pageIndex) {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT SupplierId, SupplierName, ContactInfo "
                + "FROM Suppliers "
                + "WHERE SupplierName LIKE ? "
                + "ORDER BY SupplierId ASC "
                + "OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, (pageIndex - 1) * 5);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier s = new Supplier(
                        rs.getInt("SupplierId"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactInfo")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Đếm tổng số supplier theo keyword
    public int countSuppliersByName(String keyword) {
        String sql = "SELECT COUNT(*) FROM Suppliers WHERE SupplierName LIKE ?";
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
