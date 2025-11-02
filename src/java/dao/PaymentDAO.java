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

    /**
     * Tạo thanh toán mới khi người dùng tiến hành checkout.
     * Status mặc định là "Pending"
     */
    public boolean createPaymentForVNPay(int orderId, BigDecimal amount) {
        String sql = "INSERT INTO Payments (OrderId, Amount, Method, Status, PaidAt) VALUES (?, ?, ?, ?, NULL)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, "VNPay"); // phương thức cố định
            ps.setString(4, "Pending");
            ps.executeUpdate();
            ps.close();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Lấy thông tin thanh toán theo OrderId
     */
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
                rs.close();
                ps.close();
                return p;
            }

            rs.close();
            ps.close();
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Cập nhật trạng thái thanh toán VNPay (Pending → Completed/Failed)
     */
    public boolean updateVNPayStatus(int orderId, String newStatus) {
        String sql = "UPDATE Payments SET Status = ?, PaidAt = GETDATE() WHERE OrderId = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            int rows = ps.executeUpdate();
            ps.close();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Dành cho các phương thức khác: cập nhật trực tiếp theo PaymentId
     */
    public boolean updatePaymentStatus(int paymentId, String newStatus) {
        String sql = "UPDATE Payments SET Status = ?, PaidAt = GETDATE() WHERE PaymentId = ?";
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

    /**
     * Kiểm tra xem đơn hàng đã có bản ghi thanh toán VNPay chưa
     */
    public boolean existsVNPayRecord(int orderId) {
        String sql = "SELECT 1 FROM Payments WHERE OrderId = ? AND Method = 'VNPay'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            boolean exists = rs.next();
            rs.close();
            ps.close();
            return exists;
        } catch (SQLException ex) {
            Logger.getLogger(PaymentDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
    public int createPayment(Payment payment) {
    String sql = """
        INSERT INTO Payments (OrderId, Amount, Method, Status, PaidAt)
        VALUES (?, ?, ?, ?, ?)
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, payment.getOrderId());
        ps.setBigDecimal(2, payment.getAmount());
        ps.setString(3, payment.getMethod());
        ps.setString(4, payment.getStatus());

        // Nếu chưa có thời điểm thanh toán, để null (sẽ cập nhật khi callback VNPay)
        if (payment.getPaidAt() != null) {
            ps.setTimestamp(5, new java.sql.Timestamp(payment.getPaidAt().getTime()));
        } else {
            ps.setNull(5, Types.TIMESTAMP);
        }

        int rows = ps.executeUpdate();
        if (rows > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về paymentId
                }
            }
        }

    } catch (SQLException ex) {
        ex.printStackTrace();
    }
    return -1; // Lỗi
}

}
