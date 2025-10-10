package entity;

import java.sql.Date;

public class UserProfile {
    private int profileId;
    private int userId;
    private String phone;
    private String address;
    private String avatarUrl;
    private Date dateOfBirth;
    private String gender;

    public UserProfile() {}

    public UserProfile(int profileId, int userId, String phone, String address, String avatarUrl, Date dateOfBirth, String gender) {
        this.profileId = profileId;
        this.userId = userId;
        this.phone = phone;
        this.address = address;
        this.avatarUrl = avatarUrl;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
    }

    public int getProfileId() { return profileId; }
    public void setProfileId(int profileId) { this.profileId = profileId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
}
