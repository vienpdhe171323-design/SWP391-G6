package dao;

import entity.OrderItem;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class OrderItemDAO extends DBContext {

    // Lấy danh sách OrderItem theo OrderId
    public List<OrderItem> getItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.OrderItemId, oi.OrderId, oi.ProductId, p.ProductName, oi.Quantity, oi.UnitPrice "
                + "FROM OrderItems oi "
                + "JOIN Products p ON oi.ProductId = p.ProductId "
                + "WHERE oi.OrderId = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem(
                        rs.getInt("OrderItemId"),
                        rs.getInt("OrderId"),
                        rs.getInt("ProductId"),
                        rs.getString("ProductName"),
                        rs.getInt("Quantity"),
                        rs.getDouble("UnitPrice")
                );
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }


    public Map<Integer, List<OrderItem>> getItemsByOrderIds(List<Integer> orderIds) {
        Map<Integer, List<OrderItem>> map = new HashMap<>();
        if (orderIds == null || orderIds.isEmpty()) {
            return map;
        }

        String placeholders = orderIds.stream().map(id -> "?")
                .collect(Collectors.joining(","));
        String sql = "SELECT oi.OrderItemId, oi.OrderId, oi.ProductId, p.ProductName, "
                + "       oi.Quantity, oi.UnitPrice "
                + "FROM OrderItems oi "
                + "JOIN Products p ON oi.ProductId = p.ProductId "
                + "WHERE oi.OrderId IN (" + placeholders + ") "
                + "ORDER BY oi.OrderId, oi.OrderItemId";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            for (Integer id : orderIds) {
                ps.setInt(idx++, id);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("OrderId");
                    OrderItem item = new OrderItem(
                            rs.getInt("OrderItemId"),
                            orderId,
                            rs.getInt("ProductId"),
                            rs.getString("ProductName"),
                            rs.getInt("Quantity"),
                            rs.getDouble("UnitPrice")
                    );
                    map.computeIfAbsent(orderId, k -> new ArrayList<>()).add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    // Test main
    public static void main(String[] args) {
        OrderItemDAO dao = new OrderItemDAO();
        List<OrderItem> items = dao.getItemsByOrderId(1);
        for (OrderItem i : items) {
            System.out.println(i);
            System.out.println("Subtotal = " + i.getSubtotal());
        }
    }
}
