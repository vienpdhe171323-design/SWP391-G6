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
            "SELECT o.OrderId, o.UserId, u.FullName, o.OrderDate, o.TotalAmount, o.Status " +
            "FROM Orders o " +
            "JOIN Users u ON o.UserId = u.UserId " +
            "WHERE 1=1 "
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
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status);
            if (fromDate != null && !fromDate.trim().isEmpty()) ps.setString(idx++, fromDate);
            if (toDate != null && !toDate.trim().isEmpty()) ps.setString(idx++, toDate);
            if (keyword != null && !keyword.trim().isEmpty()) ps.setString(idx++, "%" + keyword.trim() + "%");
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
            "SELECT COUNT(*) " +
            "FROM Orders o JOIN Users u ON o.UserId = u.UserId " +
            "WHERE 1=1 "
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
            if (status != null && !status.trim().isEmpty()) ps.setString(idx++, status);
            if (fromDate != null && !fromDate.trim().isEmpty()) ps.setString(idx++, fromDate);
            if (toDate != null && !toDate.trim().isEmpty()) ps.setString(idx++, toDate);
            if (keyword != null && !keyword.trim().isEmpty()) ps.setString(idx++, "%" + keyword.trim() + "%");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Test main
    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();

        System.out.println("===== TEST ORDER HISTORY (All) =====");
        List<Order> orders = dao.getOrderHistory("", "", "", "", 1);
        for (Order o : orders) {
            System.out.println(o);
        }

        System.out.println("\n===== TEST FILTER BY STATUS: Completed =====");
        List<Order> completedOrders = dao.getOrderHistory("Completed", "", "", "", 1);
        for (Order o : completedOrders) {
            System.out.println(o);
        }

        System.out.println("\n===== TEST FILTER BY DATE RANGE (Sep 2025) =====");
        List<Order> septOrders = dao.getOrderHistory("", "2025-09-01", "2025-09-30", "", 1);
        for (Order o : septOrders) {
            System.out.println(o);
        }

        System.out.println("\n===== TEST FILTER BY USER NAME (Tran) =====");
        List<Order> tranOrders = dao.getOrderHistory("", "", "", "Tran", 1);
        for (Order o : tranOrders) {
            System.out.println(o);
        }

        System.out.println("\n===== TEST COUNT =====");
        System.out.println("Tổng số đơn hàng: " + dao.countOrderHistory("", "", "", ""));
        System.out.println("Tổng số đơn Completed: " + dao.countOrderHistory("Completed", "", "", ""));
        System.out.println("Tổng số đơn của user Tran: " + dao.countOrderHistory("", "", "", "Tran"));
    }
}
