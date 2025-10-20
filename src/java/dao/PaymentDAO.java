package dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;
import entity.Payment;
import util.DBContext;

public class PaymentDAO extends DBContext {

    public PaymentDAO() {
        super();
    }

    // Thêm mới thanh toán
    public void createPayment(Payment payment) {
        String sql = "INSERT INTO Payments (OrderId, Amount, Method, Status, PaidAt) VALUES (?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, payment.getOrderId());
            ps.setBigDecimal(2, payment.getAmount());
            ps.setString(3, payment.getMethod());
            ps.setString(4, payment.getStatus());
            ps.executeUpdate();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // Lấy thanh toán theo OrderId
    public Payment getPaymentByOrderId(int orderId) {
        String sql = "SELECT * FROM Payments WHERE OrderId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("PaymentId"));
                p.setOrderId(rs.getInt("OrderId"));
                p.setAmount(rs.getBigDecimal("Amount"));
                p.setMethod(rs.getString("Method"));
                p.setStatus(rs.getString("Status"));
                p.setPaidAt(rs.getTimestamp("PaidAt"));
                return p;
            }

            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Cập nhật trạng thái thanh toán (Pending → Completed / Failed)
    public boolean updatePaymentStatus(int paymentId, String newStatus) {
        String sql = "UPDATE Payments SET Status = ? WHERE PaymentId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, paymentId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
