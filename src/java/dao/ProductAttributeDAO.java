package dao;

import util.DBContext;
import java.sql.*;
import java.util.Map;

public class ProductAttributeDAO extends DBContext {

    public void insertProductAttributes(int productId, Map<Integer, String> attributes) {
        String sql = "INSERT INTO ProductAttributes (ProductId, AttributeId, Value) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (Map.Entry<Integer, String> entry : attributes.entrySet()) {
                ps.setInt(1, productId);
                ps.setInt(2, entry.getKey());
                ps.setString(3, entry.getValue());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Map<Integer, String> getAttributesByProductId(int productId) {
        Map<Integer, String> map = new java.util.HashMap<>();
        String sql = """
            SELECT AttributeId, Value
            FROM ProductAttributes
            WHERE ProductId = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt("AttributeId"), rs.getString("Value"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public void updateProductAttributes(int productId, Map<Integer, String> attributes) {
        try {
            String deleteSQL = "DELETE FROM ProductAttributes WHERE ProductId = ?";
            try (PreparedStatement del = connection.prepareStatement(deleteSQL)) {
                del.setInt(1, productId);
                del.executeUpdate();
            }

            String insertSQL = "INSERT INTO ProductAttributes (ProductId, AttributeId, Value) VALUES (?, ?, ?)";
            try (PreparedStatement ins = connection.prepareStatement(insertSQL)) {
                for (Map.Entry<Integer, String> entry : attributes.entrySet()) {
                    ins.setInt(1, productId);
                    ins.setInt(2, entry.getKey());
                    ins.setString(3, entry.getValue());
                    ins.addBatch();
                }
                ins.executeBatch();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
