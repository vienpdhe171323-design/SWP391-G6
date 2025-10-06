package entity;

import java.math.BigDecimal;

public class Product {
    private int id;
    private int storeId;
    private int categoryId;
    private String productName;
    private BigDecimal price;
    private int stock;
    private String status;
    private String imageUrl;

    public Product() {}

    public Product(int id, int storeId, int categoryId, String productName,
                   BigDecimal price, int stock, String status, String imageUrl) {
        this.id = id;
        this.storeId = storeId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.price = price;
        this.stock = stock;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStoreId() { return storeId; }
    public void setStoreId(int storeId) { this.storeId = storeId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", productName='" + productName + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", status='" + status + '\'' +
                '}';
    }
}
