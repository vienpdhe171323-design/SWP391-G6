package dao;

import entity.Supplier;
import util.DBContext;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DBContext {

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
            ps.setString(1, supplier.getSupplierName());
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
            ps.setString(1, supplier.getSupplierName());
            ps.setString(2, supplier.getContactInfo());
            ps.setInt(3, supplier.getSupplierId());
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
