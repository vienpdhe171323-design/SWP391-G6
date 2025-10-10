package entity;

public class ProductAttribute {

    private int productAttributeId;
    private int productId;
    private int attributeId;
    private String value;

    public ProductAttribute() {
    }

    public ProductAttribute(int productId, int attributeId, String value) {
        this.productId = productId;
        this.attributeId = attributeId;
        this.value = value;
    }

    public int getProductAttributeId() {
        return productAttributeId;
    }

    public void setProductAttributeId(int productAttributeId) {
        this.productAttributeId = productAttributeId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(int attributeId) {
        this.attributeId = attributeId;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
