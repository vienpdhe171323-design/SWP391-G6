package dao;

import entity.StockReport;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockReportDAO extends DBContext {

    // Đếm tổng số record sau filter
    public int countStockReport(String search, Integer storeId, Integer categoryId) {
        String sql = """
            SELECT COUNT(*)
            FROM Products p
            JOIN Stores s ON p.StoreId = s.StoreId
            JOIN Categories c ON p.CategoryId = c.CategoryId
            WHERE 1=1
        """;

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND p.ProductName LIKE ? ";
            params.add("%" + search.trim() + "%");
        }
        if (storeId != null && storeId > 0) {
            sql += " AND p.StoreId = ? ";
            params.add(storeId);
        }
        if (categoryId != null && categoryId > 0) {
            sql += " AND p.CategoryId = ? ";
            params.add(categoryId);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++)
                ps.setObject(i + 1, params.get(i));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Lấy danh sách theo trang + filter
    public List<StockReport> getStockReport(
            String search,
            Integer storeId,
            Integer categoryId,
            String sort,
            int pageIndex,
            int pageSize
    ) {
        List<StockReport> list = new ArrayList<>();

        String sql = """
            SELECT 
                p.ProductId,
                p.ProductName,
                s.StoreName,
                c.CategoryName,
                p.Stock AS CurrentStock
            FROM Products p
            JOIN Stores s ON p.StoreId = s.StoreId
            JOIN Categories c ON p.CategoryId = c.CategoryId
            WHERE 1=1
        """;

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql += " AND p.ProductName LIKE ? ";
            params.add("%" + search.trim() + "%");
        }
        if (storeId != null && storeId > 0) {
            sql += " AND p.StoreId = ? ";
            params.add(storeId);
        }
        if (categoryId != null && categoryId > 0) {
            sql += " AND p.CategoryId = ? ";
            params.add(categoryId);
        }

        // Sort
        if ("asc".equals(sort)) {
            sql += " ORDER BY p.Stock ASC ";
        } else if ("desc".equals(sort)) {
            sql += " ORDER BY p.Stock DESC ";
        } else {
            sql += " ORDER BY p.ProductId ASC ";
        }

        // Pagination
        sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int idx = 1;
            for (Object obj : params) {
                ps.setObject(idx++, obj);
            }

            ps.setInt(idx++, (pageIndex - 1) * pageSize);
            ps.setInt(idx, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                StockReport sr = new StockReport();
                sr.setProductId(rs.getInt("ProductId"));
                sr.setProductName(rs.getString("ProductName"));
                sr.setStoreName(rs.getString("StoreName"));
                sr.setCategoryName(rs.getString("CategoryName"));
                sr.setCurrentStock(rs.getInt("CurrentStock"));
                list.add(sr);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
