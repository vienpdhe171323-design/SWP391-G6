package dao;

import entity.Shipment;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShipmentDAO extends DBContext {

    // Map ResultSet thành Shipment object
    private Shipment map(ResultSet rs) throws SQLException {
        return new Shipment(
                rs.getInt("ShipmentId"),
                rs.getInt("OrderId"),
                rs.getString("Carrier"),
                rs.getString("TrackingNumber"),
                rs.getString("Status"),
                rs.getTimestamp("ShippedAt")
        );
    }

    // Lấy Shipment theo OrderId (Buyer xem tracking)
    public Shipment getByOrderId(int orderId) {
        String sql = "SELECT * FROM Shipments WHERE OrderId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy Shipment theo ShipmentId (Admin/Carrier)
    public Shipment getByShipmentId(int shipmentId) {
        String sql = "SELECT * FROM Shipments WHERE ShipmentId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, shipmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Seller tạo Shipment mới (UC 6.1)
    public boolean createShipment(Shipment s) {
        String sql = "INSERT INTO Shipments (OrderId, Carrier, TrackingNumber, Status, ShippedAt) "
                   + "VALUES (?, ?, ?, 'PENDING', GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, s.getOrderId());
            ps.setString(2, s.getCarrier());
            ps.setString(3, s.getTrackingNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Carrier cập nhật status (UC 6.2)
    public boolean updateStatus(int shipmentId, String status) {
        String sql = "UPDATE Shipments SET Status = ? WHERE ShipmentId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, shipmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Admin xem tất cả shipments
    public List<Shipment> getAll() {
        List<Shipment> list = new ArrayList<>();
        String sql = "SELECT * FROM Shipments ORDER BY ShippedAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
