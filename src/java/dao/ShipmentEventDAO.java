package dao;

import entity.ShipmentEvent;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShipmentEventDAO extends DBContext {

    // Map dữ liệu
    private ShipmentEvent map(ResultSet rs) throws SQLException {
        return new ShipmentEvent(
                rs.getInt("EventId"),
                rs.getInt("ShipmentId"),
                rs.getString("Status"),
                rs.getTimestamp("EventTime"),
                rs.getString("Location")
        );
    }

    // Buyer xem timeline theo ShipmentId
    public List<ShipmentEvent> getEventsByShipmentId(int shipmentId) {
        List<ShipmentEvent> list = new ArrayList<>();
        String sql = "SELECT * FROM ShipmentEvents WHERE ShipmentId = ? ORDER BY EventTime DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, shipmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Carrier thêm Event mới khi cập nhật trạng thái
    public boolean addEvent(ShipmentEvent e) {
        String sql = "INSERT INTO ShipmentEvents (ShipmentId, Status, EventTime, Location) "
                   + "VALUES (?, ?, GETDATE(), ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, e.getShipmentId());
            ps.setString(2, e.getStatus());
            ps.setString(3, e.getLocation());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }
}
