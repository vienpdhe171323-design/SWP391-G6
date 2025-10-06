/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import util.DBContext;

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
            try { connection.rollback(); } catch (SQLException ex) {}
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
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
            try { connection.rollback(); } catch (SQLException ex) {}
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
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
            try { connection.rollback(); } catch (SQLException ex) {}
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
        }
        return false;
    }
}
