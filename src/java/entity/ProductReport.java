package entity;

public class ProductReport {

    private int productId;
    private String productName;
    private int quantitySold;
    private double totalRevenue;

    public ProductReport() {
    }

    public ProductReport(int productId, String productName, int quantitySold, double totalRevenue) {
        this.productId = productId;
        this.productName = productName;
        this.quantitySold = quantitySold;
        this.totalRevenue = totalRevenue;
    }

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

    public int getQuantitySold() {
        return quantitySold;
    }

    public void setQuantitySold(int quantitySold) {
        this.quantitySold = quantitySold;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    @Override
    public String toString() {
        return "ProductReport{"
                + "productId=" + productId
                + ", productName='" + productName + '\''
                + ", quantitySold=" + quantitySold
                + ", totalRevenue=" + totalRevenue
                + '}';
    }
}
