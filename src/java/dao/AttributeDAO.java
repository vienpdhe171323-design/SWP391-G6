package dao;

import entity.Attribute;
import util.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttributeDAO extends DBContext {

    public List<Attribute> getAllAttributes() {
        List<Attribute> list = new ArrayList<>();
        String sql = "SELECT AttributeId, AttributeName FROM Attributes";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Attribute(rs.getInt("AttributeId"), rs.getString("AttributeName")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
