/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import entity.StockMovement;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBContext;
import util.PagedResult;

/**
 *
 * @author ADMIN
 */
public class StockMovementDAO extends DBContext {

    // Nhập kho
    public boolean stockIn(int productId, int warehouseId, int quantity) {
        String sql1 = "UPDATE Products SET Stock = Stock + ? WHERE ProductId = ?";
        String sql2 = "INSERT INTO StockMovements(ProductId, WarehouseId, Quantity, MovementType) VALUES(?,?,?,'IN')";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(sql1)) {
                ps.setInt(1, quantity);
                ps.setInt(2, productId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(sql2)) {
                ps.setInt(1, productId);
                ps.setInt(2, warehouseId);
                ps.setInt(3, quantity);
                ps.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
            }
        }
        return false;
    }

    // Xuất kho
    public boolean stockOut(int productId, int warehouseId, int quantity) {
        String sql1 = "UPDATE Products SET Stock = Stock - ? WHERE ProductId = ? AND Stock >= ?";
        String sql2 = "INSERT INTO StockMovements(ProductId, WarehouseId, Quantity, MovementType) VALUES(?,?,?,'OUT')";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(sql1)) {
                ps.setInt(1, quantity);
                ps.setInt(2, productId);
                ps.setInt(3, quantity);
                int updated = ps.executeUpdate();
                if (updated == 0) {
                    throw new SQLException("Not enough stock!");
                }
            }

            try (PreparedStatement ps = connection.prepareStatement(sql2)) {
                ps.setInt(1, productId);
                ps.setInt(2, warehouseId);
                ps.setInt(3, quantity);
                ps.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
            }
        }
        return false;
    }

    // Điều chuyển kho
    public boolean transfer(int productId, int fromWh, int toWh, int quantity) {
        try {
            connection.setAutoCommit(false);

            // Xuất khỏi fromWh
            if (!stockOut(productId, fromWh, quantity)) {
                throw new SQLException("Transfer failed - not enough stock in source warehouse");
            }

            // Nhập vào toWh
            if (!stockIn(productId, toWh, quantity)) {
                throw new SQLException("Transfer failed - cannot insert into target warehouse");
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (SQLException ex) {
            }
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
            }
        }
        return false;
    }

    private StockMovement map(ResultSet rs) throws SQLException {
        StockMovement sm = new StockMovement();
        sm.setId(rs.getInt("MovementId"));
        sm.setProductName(rs.getString("ProductName"));
        sm.setWarehouseName(rs.getString("WarehouseName"));
        sm.setQuantity(rs.getInt("Quantity"));
        sm.setMovementType(rs.getString("MovementType"));
        sm.setCreatedAt(rs.getTimestamp("MovementDate"));
        return sm;
    }

    public PagedResult<StockMovement> getHistory(String keyword, String type, int page, int size) {
        String base = " FROM StockMovements s "
                + " JOIN Products p ON s.ProductId = p.ProductId "
                + " JOIN Warehouses w ON s.WarehouseId = w.WarehouseId WHERE 1=1 ";
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            base += " AND (p.ProductName LIKE ? OR w.Name LIKE ?) ";
            String like = "%" + keyword + "%";
            params.add(like);
            params.add(like);
        }

        if (type != null && !type.isEmpty()) {
            base += " AND s.MovementType = ? ";
            params.add(type);
        }

        int total = 0;
        String sqlCount = "SELECT COUNT(*) " + base;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlData = "SELECT s.MovementId, p.ProductName, w.Name as WarehouseName, s.Quantity, s.MovementType, s.MovementDate "
                + base + " ORDER BY s.MovementDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<StockMovement> items = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlData)) {
            int idx = 1;
            for (Object p : params) {
                ps.setObject(idx++, p);
            }
            int offset = (Math.max(page, 1) - 1) * size;
            ps.setInt(idx++, offset);
            ps.setInt(idx, size);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return new PagedResult<>(items, total, page, size);
    }
}
