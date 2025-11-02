package dao;

import entity.PaymentTransaction;
import util.DBContext;
import java.sql.*;
import java.math.BigDecimal;

public class PaymentTransactionDAO extends DBContext {

    public int insertTransaction(PaymentTransaction t) {
        String sql = "INSERT INTO PaymentTransactions (OrderId, VnpTxnRef, Amount, Status, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, t.getOrderId());
            ps.setString(2, t.getVnpTxnRef());
            ps.setBigDecimal(3, t.getAmount());
            ps.setString(4, t.getStatus());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateStatus(String vnpTxnRef, String status) {
        String sql = "UPDATE PaymentTransactions SET Status=? WHERE VnpTxnRef=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, vnpTxnRef);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public PaymentTransaction findByTxnRef(String vnpTxnRef) {
        String sql = "SELECT * FROM PaymentTransactions WHERE VnpTxnRef=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, vnpTxnRef);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PaymentTransaction t = new PaymentTransaction();
                t.setTransactionId(rs.getInt("TransactionId"));
                t.setOrderId(rs.getInt("OrderId"));
                t.setVnpTxnRef(rs.getString("VnpTxnRef"));
                t.setAmount(rs.getBigDecimal("Amount"));
                t.setStatus(rs.getString("Status"));
                t.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return t;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
