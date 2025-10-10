package entity;

import java.math.BigDecimal;
import java.util.List;

public class ProductBox {

    private int productId;
    private String productName;
    private BigDecimal price;
    private int stock;
    private String status;
    private String imageUrl;

    private String storeName;
    private String categoryName;
    private String parentCategoryName;
    private String storeCreatedAt;

    // Danh sách thuộc tính sản phẩm
    private List<ProductAttributeBox> attributes;

    public ProductBox() {
    }

    public ProductBox(int productId, String productName, BigDecimal price, int stock,
            String status, String imageUrl, String storeName,
            String categoryName, String parentCategoryName, String storeCreatedAt) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.stock = stock;
        this.status = status;
        this.imageUrl = imageUrl;
        this.storeName = storeName;
        this.categoryName = categoryName;
        this.parentCategoryName = parentCategoryName;
        this.storeCreatedAt = storeCreatedAt;
    }

    // Getters & Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getParentCategoryName() {
        return parentCategoryName;
    }

    public void setParentCategoryName(String parentCategoryName) {
        this.parentCategoryName = parentCategoryName;
    }

    public String getStoreCreatedAt() {
        return storeCreatedAt;
    }

    public void setStoreCreatedAt(String storeCreatedAt) {
        this.storeCreatedAt = storeCreatedAt;
    }

    public List<ProductAttributeBox> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<ProductAttributeBox> attributes) {
        this.attributes = attributes;
    }
}
