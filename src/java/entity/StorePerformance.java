package entity;

public class StorePerformance {

    private int storeId;
    private String storeName;
    private double totalRevenue;
    private int totalOrders;
    private int totalProductsSold;
    private double averageRating;

    public StorePerformance() {
    }

    public StorePerformance(int storeId, String storeName, double totalRevenue, int totalOrders, int totalProductsSold, double averageRating) {
        this.storeId = storeId;
        this.storeName = storeName;
        this.totalRevenue = totalRevenue;
        this.totalOrders = totalOrders;
        this.totalProductsSold = totalProductsSold;
        this.averageRating = averageRating;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalProductsSold() {
        return totalProductsSold;
    }

    public void setTotalProductsSold(int totalProductsSold) {
        this.totalProductsSold = totalProductsSold;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    @Override
    public String toString() {
        return "StorePerformance{"
                + "storeId=" + storeId
                + ", storeName='" + storeName + '\''
                + ", totalRevenue=" + totalRevenue
                + ", totalOrders=" + totalOrders
                + ", totalProductsSold=" + totalProductsSold
                + ", averageRating=" + averageRating
                + '}';
    }
}
