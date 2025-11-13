package entity;

import java.util.Date;

public class FollowStore {

    private int followId;
    private int userId;
    private int storeId;
    private Date createdAt;

    public FollowStore() {
    }

    public FollowStore(int followId, int userId, int storeId, Date createdAt) {
        this.followId = followId;
        this.userId = userId;
        this.storeId = storeId;
        this.createdAt = createdAt;
    }

    public int getFollowId() {
        return followId;
    }

    public void setFollowId(int followId) {
        this.followId = followId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getStoreId() {
        return storeId;
    }

    public void setStoreId(int storeId) {
        this.storeId = storeId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "FollowStore{" +
                "followId=" + followId +
                ", userId=" + userId +
                ", storeId=" + storeId +
                ", createdAt=" + createdAt +
                '}';
    }
}
