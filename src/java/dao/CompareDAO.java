package dao;

import entity.ProductAttributeBox;
import entity.ProductBox;
import util.DBContext;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class CompareDAO extends DBContext {

    public List<ProductBox> getProductsForCompare(List<Integer> productIds) {
        List<ProductBox> products = new ArrayList<>();
        if (productIds == null || productIds.isEmpty()) {
            return products;
        }

        // Tạo placeholder: ?, ?, ?
        String placeholders = productIds.stream()
                .map(id -> "?")
                .collect(Collectors.joining(","));

        // === QUERY 1: Lấy thông tin sản phẩm ===
        String productSql = """
            SELECT 
                p.ProductId,
                p.ProductName,
                p.Price,
                p.Stock,
                p.ImageUrl,
                s.StoreName,
                c.CategoryName,
                CONVERT(varchar, s.CreatedAt, 103) AS StoreCreatedAt
            FROM Products p
            JOIN Stores s ON p.StoreId = s.StoreId
            JOIN Categories c ON p.CategoryId = c.CategoryId
            WHERE p.ProductId IN (%s)
            """.formatted(placeholders);

        // === QUERY 2: Lấy tất cả thuộc tính ===
        String attrSql = """
            SELECT 
                pa.ProductId,
                a.AttributeName,
                pa.Value
            FROM ProductAttributes pa
            JOIN Attributes a ON pa.AttributeId = a.AttributeId
            WHERE pa.ProductId IN (%s)
            """.formatted(placeholders);

        try {
            // === 1. Lấy sản phẩm ===
            Map<Integer, ProductBox> productMap = new LinkedHashMap<>();
            try (PreparedStatement psProduct = connection.prepareStatement(productSql)) {
                for (int i = 0; i < productIds.size(); i++) {
                    psProduct.setInt(i + 1, productIds.get(i));
                }

                try (ResultSet rs = psProduct.executeQuery()) {
                    while (rs.next()) {
                        ProductBox box = new ProductBox(
                                rs.getInt("ProductId"),
                                rs.getString("ProductName"),
                                rs.getBigDecimal("Price"),
                                rs.getInt("Stock"),
                                "Active",
                                rs.getString("ImageUrl"),
                                rs.getString("StoreName"),
                                rs.getString("CategoryName"),
                                null,
                                rs.getString("StoreCreatedAt")
                        );
                        box.setAttributes(new ArrayList<>());
                        productMap.put(box.getProductId(), box);
                    }
                }
            }

            // === 2. Lấy thuộc tính ===
            try (PreparedStatement psAttr = connection.prepareStatement(attrSql)) {
                for (int i = 0; i < productIds.size(); i++) {
                    psAttr.setInt(i + 1, productIds.get(i));
                }

                try (ResultSet rs = psAttr.executeQuery()) {
                    while (rs.next()) {
                        int pid = rs.getInt("ProductId");
                        ProductBox box = productMap.get(pid);
                        if (box != null) {
                            ProductAttributeBox attr = new ProductAttributeBox(
                                    rs.getString("AttributeName"),
                                    rs.getString("Value")
                            );
                            box.getAttributes().add(attr);
                        }
                    }
                }
            }

            products.addAll(productMap.values());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }
}