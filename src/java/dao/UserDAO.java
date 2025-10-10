package dao;

import util.DBContext;
import entity.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class UserDAO extends DBContext implements BaseDAO<User> {
    
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
        u.setStatus(rs.getString("Status")); // Thêm Status
        return u;
    }

    // ==== CRUD ====
    @Override
    public boolean add(User user) {
        String sql = "INSERT INTO Users(Email, PasswordHash, FullName, Role, CreatedAt, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, sha256Hex(user.getPasswordHash())); // hash trước khi lưu
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            ps.setDate(5, user.getCreatedAt());
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "Active"); // Mặc định Active
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE Users SET Email=?, PasswordHash=?, FullName=?, Role=?, CreatedAt=?, Status=? WHERE UserId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, sha256Hex(user.getPasswordHash())); // hash luôn khi update
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getRole());
            ps.setDate(5, user.getCreatedAt());
            ps.setString(6, user.getStatus());
            ps.setInt(7, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getById(int id) {
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
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
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
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
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
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
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
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

    // ==== Get All Users with Pagination (5 users per page) ====
    public List<User> getAllWithPagination(int page) {
        List<User> list = new ArrayList<>();
        int pageSize = 5;
        int offset = (page - 1) * pageSize; // Tính số bản ghi cần bỏ qua
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "ORDER BY u.UserId DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==== Get All Users with Sort and Pagination ====
    public List<User> getAllWithSort(String sortOrder, int page) {
        List<User> list = new ArrayList<>();
        int pageSize = 5;
        int offset = (page - 1) * pageSize;
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "ORDER BY u.CreatedAt " + (sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? "DESC" : "ASC")
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==== Get Total Users ====
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==== Delete User ====
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM Users WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==== Active/Deactive User ====
    public boolean setUserStatus(int id, String status) {
        String sql = "UPDATE Users SET Status = ? WHERE UserId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==== Search by Email with Pagination ====
    public List<User> searchByEmail(String email, int page) {
        List<User> list = new ArrayList<>();
        int pageSize = 5;
        int offset = (page - 1) * pageSize;
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE u.Email LIKE ? "
                + "ORDER BY u.UserId DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + email + "%"); // Tìm kiếm không phân biệt chính xác
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==== Get Total Users Matching Search ====
    public int getTotalUsersByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + email + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ==== Search by FullName, Role, and Status with Pagination ====
    public List<User> searchUsers(String fullName, String role, String status, int page) {
        List<User> list = new ArrayList<>();
        int pageSize = 5;
        int offset = (page - 1) * pageSize;
        String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
                + "COALESCE(r.RoleName, u.Role) AS RoleName "
                + "FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE 1=1 ";
        
        // Thêm điều kiện tìm kiếm
        if (fullName != null && !fullName.trim().isEmpty()) {
            sql += "AND u.FullName LIKE ? ";
        }
        if (role != null && !role.trim().isEmpty()) {
            sql += "AND COALESCE(r.RoleName, u.Role) = ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += "AND u.Status = ? ";
        }
        
        sql += "ORDER BY u.UserId DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (fullName != null && !fullName.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + fullName + "%");
            }
            if (role != null && !role.trim().isEmpty()) {
                ps.setString(paramIndex++, role);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==== Get Total Users Matching Search ====
    public int getTotalUsersBySearch(String fullName, String role, String status) {
        String sql = "SELECT COUNT(*) FROM Users u "
                + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
                + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
                + "WHERE 1=1 ";
        
        if (fullName != null && !fullName.trim().isEmpty()) {
            sql += "AND u.FullName LIKE ? ";
        }
        if (role != null && !role.trim().isEmpty()) {
            sql += "AND COALESCE(r.RoleName, u.Role) = ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += "AND u.Status = ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (fullName != null && !fullName.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + fullName + "%");
            }
            if (role != null && !role.trim().isEmpty()) {
                ps.setString(paramIndex++, role);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
                // Lấy danh sách user theo role
public List<User> getUsersByRole(String role) {
    List<User> list = new ArrayList<>();
    String sql = "SELECT u.UserId, u.Email, u.PasswordHash, u.FullName, u.CreatedAt, u.Status, "
               + "COALESCE(r.RoleName, u.Role) AS RoleName "
               + "FROM Users u "
               + "LEFT JOIN UserRoles ur ON ur.UserId = u.UserId "
               + "LEFT JOIN Roles r ON r.RoleId = ur.RoleId "
               + "WHERE COALESCE(r.RoleName, u.Role) = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, role);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(mapUserFromResultSet(rs));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
    public static void main(String[] args) {
        UserDAO o = new UserDAO();
        o.login("admin@example.com", "admin123");
    }
}