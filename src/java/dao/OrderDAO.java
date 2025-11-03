package dao;

import entity.Order;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    // Lấy danh sách đơn hàng (filter theo status, date range, keyword (user name), phân trang 5 đơn/trang)
    public List<Order> getOrderHistory(String status, String fromDate, String toDate, String keyword, int pageIndex) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.OrderId, o.UserId, u.FullName, o.OrderDate, o.TotalAmount, o.Status "
                + "FROM Orders o "
                + "JOIN Users u ON o.UserId = u.UserId "
                + "WHERE 1=1 "
        );

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND o.Status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND o.OrderDate >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND o.OrderDate <= ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND u.FullName LIKE ? ");
        }

        sql.append(" ORDER BY o.OrderDate DESC OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(idx++, toDate);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }
            ps.setInt(idx, (pageIndex - 1) * 5);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("OrderId"));
                o.setUserId(rs.getInt("UserId"));
                o.setUserName(rs.getString("FullName"));
                o.setOrderDate(rs.getTimestamp("OrderDate"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setStatus(rs.getString("Status"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số đơn hàng (dùng cho phân trang + filter)
    public int countOrderHistory(String status, String fromDate, String toDate, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Orders o JOIN Users u ON o.UserId = u.UserId "
                + "WHERE 1=1 "
        );

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND o.Status = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND o.OrderDate >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND o.OrderDate <= ? ");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND u.FullName LIKE ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(idx++, toDate);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getOrderHistoryByUser(int userId, String status, String fromDate, String toDate, String keyword, int page) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.OrderId, o.UserId, u.FullName as UserName, o.TotalAmount, o.Status, o.OrderDate "
                + "FROM Orders o JOIN Users u ON o.UserId = u.UserId "
                + "WHERE o.UserId = ?"
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.Status = ?");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND o.OrderDate >= ?");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND o.OrderDate <= ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND u.FullName LIKE ?");
        }

        sql.append(" ORDER BY o.OrderDate DESC OFFSET ? ROWS FETCH NEXT 5 ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, userId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(idx++, toDate);
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
            }

            ps.setInt(idx, (page - 1) * 5);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("OrderId"));
                o.setUserId(rs.getInt("UserId"));
                o.setUserName(rs.getString("UserName"));
                o.setTotalAmount(rs.getInt("TotalAmount"));
                o.setStatus(rs.getString("Status"));
                o.setOrderDate(rs.getTimestamp("OrderDate"));
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countOrderHistoryByUser(int userId, String status, String fromDate, String toDate, String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Orders o JOIN Users u ON o.UserId = u.UserId WHERE o.UserId = ?"
        );

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.Status = ?");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND o.OrderDate >= ?");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND o.OrderDate <= ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND u.FullName LIKE ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(idx++, toDate);
            }
            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(idx++, "%" + keyword + "%");
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
// Tìm kiếm các đơn CHƯA có shipment, có keyword + phân trang

    public List<Order> searchOrdersWithoutShipment(String keyword, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.OrderId, o.UserId, u.FullName, o.OrderDate, o.TotalAmount, o.Status "
                + "FROM Orders o JOIN Users u ON o.UserId = u.UserId "
                + "WHERE (o.Status IN ('Completed','Confirmed', 'Pending')) "
                + "AND NOT EXISTS (SELECT 1 FROM Shipments s WHERE s.OrderId = o.OrderId) "
        );
        if (keyword != null && !(keyword = keyword.trim()).isEmpty()) {
            sql.append(" AND (u.FullName LIKE ? OR CAST(o.OrderId AS NVARCHAR(20)) LIKE ?) ");
        }
        sql.append(" ORDER BY o.OrderDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String like = "%" + keyword + "%";
                ps.setString(idx++, like);
                ps.setString(idx++, like);
            }
            int offset = (Math.max(page, 1) - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("OrderId"));
                    o.setUserId(rs.getInt("UserId"));
                    o.setUserName(rs.getString("FullName"));
                    o.setOrderDate(rs.getTimestamp("OrderDate"));
                    o.setTotalAmount(rs.getDouble("TotalAmount"));
                    o.setStatus(rs.getString("Status"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

// Đếm tổng số đơn CHƯA có shipment (có keyword)
    public int countOrdersWithoutShipment(String keyword) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Orders o JOIN Users u ON o.UserId = u.UserId "
                + "WHERE (o.Status IN ('Completed','Confirmed')) "
                + "AND NOT EXISTS (SELECT 1 FROM Shipments s WHERE s.OrderId = o.OrderId) "
        );
        try (PreparedStatement ps = connection.prepareStatement(
                (keyword != null && !keyword.trim().isEmpty())
                ? sql.append(" AND (u.FullName LIKE ? OR CAST(o.OrderId AS NVARCHAR(20)) LIKE ?) ").toString()
                : sql.toString())) {
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(idx++, like);
                ps.setString(idx, like);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

// Cập nhật trạng thái order
    public boolean updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

// Tạo đơn hàng mới khi người dùng thanh toán
    public int createOrder(Order order) {
        String sql = "INSERT INTO Orders (UserId, OrderDate, TotalAmount, Status) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUserId());
            ps.setTimestamp(2, order.getOrderDate());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = """
        SELECT o.OrderId, o.UserId, u.FullName AS UserName,
               o.OrderDate, o.TotalAmount, o.Status
        FROM Orders o
        JOIN Users u ON o.UserId = u.UserId
        WHERE o.UserId = ?
        ORDER BY o.OrderDate DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("OrderId"));
                o.setUserId(rs.getInt("UserId"));
                o.setUserName(rs.getString("UserName"));
                o.setOrderDate(rs.getTimestamp("OrderDate"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setStatus(rs.getString("Status"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByUserAndDateRange(int userId, String fromDate, String toDate) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT o.OrderId, o.UserId, u.FullName AS UserName,
               o.OrderDate, o.TotalAmount, o.Status
        FROM Orders o
        JOIN Users u ON o.UserId = u.UserId
        WHERE o.UserId = ?
    """);

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND o.OrderDate >= ? ");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND o.OrderDate <= ? ");
        }
        sql.append(" ORDER BY o.OrderDate DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setString(idx++, fromDate + " 00:00:00");
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setString(idx++, toDate + " 23:59:59");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("OrderId"));
                o.setUserId(rs.getInt("UserId"));
                o.setUserName(rs.getString("UserName"));
                o.setOrderDate(rs.getTimestamp("OrderDate"));
                o.setTotalAmount(rs.getDouble("TotalAmount"));
                o.setStatus(rs.getString("Status"));
                list.add(o);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Lọc đơn hàng theo khoảng giá tiền 
public List<Order> getOrdersByUserAndPriceRange(int userId, Double minPrice, Double maxPrice) {
    List<Order> list = new ArrayList<>();
    StringBuilder sql = new StringBuilder("""
        SELECT o.OrderId, o.UserId, u.FullName AS UserName,
               o.OrderDate, o.TotalAmount, o.Status
        FROM Orders o
        JOIN Users u ON o.UserId = u.UserId
        WHERE o.UserId = ?
    """);

    if (minPrice != null) {
        sql.append(" AND o.TotalAmount >= ? ");
    }
    if (maxPrice != null) {
        sql.append(" AND o.TotalAmount <= ? ");
    }

    sql.append(" ORDER BY o.TotalAmount DESC");

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        int idx = 1;
        ps.setInt(idx++, userId);

        if (minPrice != null) ps.setDouble(idx++, minPrice);
        if (maxPrice != null) ps.setDouble(idx++, maxPrice);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Order o = new Order();
            o.setOrderId(rs.getInt("OrderId"));
            o.setUserId(rs.getInt("UserId"));
            o.setUserName(rs.getString("UserName"));
            o.setOrderDate(rs.getTimestamp("OrderDate"));
            o.setTotalAmount(rs.getDouble("TotalAmount"));
            o.setStatus(rs.getString("Status"));
            list.add(o);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}


}
