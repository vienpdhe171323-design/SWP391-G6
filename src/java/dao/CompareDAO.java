package dao;

import entity.ProductBox;
import util.DBContext;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class CompareDAO extends DBContext {

    public List<ProductBox> getProductsForCompare(List<Integer> ids) {
        List<ProductBox> list = new ArrayList<>();

        if (ids == null || ids.isEmpty()) return list;

        String params = ids.stream().map(i -> "?").collect(Collectors.joining(","));
        String sql = """
            SELECT 
                p.ProductId,
                p.ProductName,
                p.Price,
                p.Stock,
                p.ImageUrl,
                c.CategoryName,
                s.StoreName
            FROM Products p
            LEFT JOIN Categories c ON p.CategoryId = c.CategoryId
            LEFT JOIN Stores s ON p.StoreId = s.StoreId
            WHERE p.ProductId IN ( %s )
        """.formatted(params);

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            for (Integer id : ids) ps.setInt(idx++, id);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductBox p = new ProductBox();
                p.setProductId(rs.getInt("ProductId"));
                p.setProductName(rs.getString("ProductName"));
                p.setPrice(rs.getBigDecimal("Price"));
                p.setStock(rs.getInt("Stock"));
                p.setImageUrl(rs.getString("ImageUrl"));
                p.setCategoryName(rs.getString("CategoryName"));
                p.setStoreName(rs.getString("StoreName"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
