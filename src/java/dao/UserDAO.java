package dao;

import util.DBContext;
import entity.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class UserDAO extends DBContext implements BaseDAO<User> {

    // ==== SHA-256 Helper ====
    private static String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // ==== Map User ====
    private User mapUserFromResultSet(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("UserId"));
        u.setEmail(rs.getString("Email"));
        u.setPasswordHash(rs.getString("PasswordHash"));
        u.setFullName(rs.getString("FullName"));
        u.setRole(rs.getString("RoleName")); // nếu không có RoleName thì sẽ null
        u.setCreatedAt(rs.getDate("CreatedAt"));
        return u;
    }

    // ==== CRUD ====
    @Override
    public boolean add(User user) {
        String sql = "INSERT INTO Users(Email, PasswordHash, FullName, Role, CreatedAt) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, sha256Hex(user.getPasswordHash())); // hash trước khi lưu
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            ps.setDate(5, user.getCreatedAt());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE Users SET Email=?, PasswordHash=?, FullName=?, Role=?, CreatedAt=? WHERE UserId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, sha256Hex(user.getPasswordHash())); // hash luôn khi update
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            ps.setDate(5, user.getCreatedAt());
            ps.setInt(6, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getById(int id) {
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE u.UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==== Login ====
    public User login(String email, String password) {
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE u.Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String storedHash = rs.getString("PasswordHash");
                if (storedHash != null && storedHash.equalsIgnoreCase(sha256Hex(password))) {
                    return mapUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM Users WHERE Email=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getByEmail(String email) {
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE u.Email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordByEmail(String email, String newPlainPassword) {
        String sql = "UPDATE Users SET PasswordHash=? WHERE Email=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, sha256Hex(newPlainPassword));
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();

        // Tạo user mới
        User admin = new User();
        admin.setEmail("user@gmail.com");
        admin.setPasswordHash("123"); // sẽ được hash SHA-256 trong hàm add()
        admin.setFullName("System Manager");
        admin.setRole("8"); // role manager id = 8 (nếu bạn lưu trong cột Role)
        admin.setCreatedAt(new java.sql.Date(System.currentTimeMillis()));

        boolean ok = dao.add(admin);

        if (ok) {
            System.out.println("Thêm user admin thành công!");
        } else {
            System.out.println("Thêm user thất bại!");
        }
    }
    
            // Lấy danh sách user theo role
    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User(
                        rs.getInt("UserId"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("FullName"),
                        rs.getString("Role"),
                        rs.getDate("CreatedAt")
                );
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

}
