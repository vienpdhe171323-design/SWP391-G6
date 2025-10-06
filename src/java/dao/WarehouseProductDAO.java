package dao;

import entity.Product;
import util.DBContext;
import util.PagedResult;

import java.sql.*;
import java.util.*;

public class WarehouseProductDAO extends DBContext {

    private Product map(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("ProductId"));
        p.setProductName(rs.getString("ProductName"));
        p.setPrice(rs.getBigDecimal("Price"));
        p.setStock(rs.getInt("Stock"));
        return p;
    }

    /** Lấy danh sách sản phẩm trong 1 kho */
    public PagedResult<Product> getProductsByWarehouse(int warehouseId, String keyword, int page, int pageSize) {
        String base = " FROM Products p "
                + "JOIN StockMovements s ON p.ProductId = s.ProductId "
                + "WHERE s.WarehouseId = ? ";
        List<Object> params = new ArrayList<>();
        params.add(warehouseId);

        if (keyword != null && !(keyword = keyword.trim()).isEmpty()) {
            base += " AND p.ProductName LIKE ? ";
            params.add("%" + keyword + "%");
        }

        // Count
        int total = 0;
        String sqlCount = "SELECT COUNT(DISTINCT p.ProductId) " + base;
        try (PreparedStatement ps = connection.prepareStatement(sqlCount)) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) total = rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Data
        String sqlData = "SELECT DISTINCT p.ProductId, p.ProductName, p.Price, p.Stock "
                + base + " ORDER BY p.ProductId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Product> items = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sqlData)) {
            int idx = 1;
            for (Object p : params) ps.setObject(idx++, p);
            int offset = (Math.max(page, 1) - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) items.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }

        return new PagedResult<>(items, total, page, pageSize);
    }
}
