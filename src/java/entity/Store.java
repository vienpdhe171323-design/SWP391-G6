package entity;

import java.util.Date;

public class Store {

    private int storeId;
    private int userId;
    private String storeName;
    private Date createdAt;
    private String ownerName;
    private String status; 

    public Store() {
    }

    public Store(int storeId, String storeName) {
        this.storeId = storeId;
        this.storeName = storeName;
    }

    public Store(int storeId, int userId, String storeName, Date createdAt, String ownerName, String status) {
        this.storeId = storeId;
        this.userId = userId;
        this.storeName = storeName;
        this.createdAt = createdAt;
        this.ownerName = ownerName;
        this.status = status;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Store{" +
                "storeId=" + storeId +
                ", storeName='" + storeName + '\'' +
                ", ownerName='" + ownerName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
