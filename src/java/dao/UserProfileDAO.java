package dao;

import entity.UserProfile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBContext;

public class UserProfileDAO extends DBContext {

    public UserProfile getProfileByUserId(int userId) {
        String sql = "SELECT * FROM UserProfiles WHERE UserId = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                UserProfile p = new UserProfile();
                p.setProfileId(rs.getInt("ProfileId"));
                p.setUserId(rs.getInt("UserId"));
                p.setPhone(rs.getString("Phone"));
                p.setAddress(rs.getString("Address"));
                p.setAvatarUrl(rs.getString("AvatarUrl"));
                p.setDateOfBirth(rs.getDate("DateOfBirth"));
                p.setGender(rs.getString("Gender"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
public void updateFullName(int userId, String fullName) {
    String sql = "UPDATE Users SET FullName = ? WHERE UserId = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, fullName);
        st.setInt(2, userId);
        st.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}



    public void updateProfile(UserProfile p) {
        String sql = """
            UPDATE UserProfiles
            SET Phone=?, Address=?, AvatarUrl=?, DateOfBirth=?, Gender=?
            WHERE UserId=?""";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getPhone());
            st.setString(2, p.getAddress());
            st.setString(3, p.getAvatarUrl());
            st.setDate(4, p.getDateOfBirth());
            st.setString(5, p.getGender());
            st.setInt(6, p.getUserId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
