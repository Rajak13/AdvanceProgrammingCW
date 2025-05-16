package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import model.User;
import utils.DBUtil;
import utils.PasswordUtil;

public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());

    private static final String INSERT_USER = "INSERT INTO User (name, password, email, address, contact, picture, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_USER = "UPDATE User SET name = ?, password = ?, email = ?, address = ?, contact = ?, picture = ?, role = ? WHERE User_ID = ?";
    private static final String DELETE_USER = "DELETE FROM User WHERE User_ID = ?";
    private static final String GET_USER_BY_ID = "SELECT * FROM User WHERE User_ID = ?";
    private static final String GET_USER_BY_EMAIL = "SELECT * FROM User WHERE email = ?";
    private static final String GET_ALL_USERS = "SELECT * FROM User ORDER BY name";
    private static final String COUNT_USERS = "SELECT COUNT(*) FROM User";

    public UserDAO() {
    }

    public User getUserByName(String username) throws SQLException {
        String sql = "SELECT * FROM User WHERE name = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public User getUserById(int id) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_USER_BY_ID)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ALL_USERS);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    public boolean createUser(User user) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_USER)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, PasswordUtil.hashPassword(user.getPassword()));
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getContact());
            stmt.setString(6, user.getPicture());
            stmt.setString(7, user.getRole());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_USER)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getPassword()); // Password should already be hashed
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getContact());
            stmt.setString(6, user.getPicture());
            stmt.setString(7, user.getRole());
            stmt.setInt(8, user.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int id) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_USER)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("User_ID"));
        user.setName(rs.getString("name"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setAddress(rs.getString("address"));
        user.setContact(rs.getString("contact"));
        user.setPicture(rs.getString("picture"));
        user.setRole(rs.getString("role"));
        return user;
    }

    public User getUserByEmail(String email) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_USER_BY_EMAIL)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE User SET password = ? WHERE User_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, PasswordUtil.hashPassword(newPassword));
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public User authenticateUser(String email, String password) throws SQLException {
        User user = getUserByEmail(email);
        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public boolean verifyPassword(int userId, String currentPassword) throws SQLException {
        User user = getUserById(userId);
        return user != null && PasswordUtil.checkPassword(currentPassword, user.getPassword());
    }

    public Integer getUserIdByEmail(String email) throws SQLException {
        String sql = "SELECT User_ID FROM User WHERE email = ?";
        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("User_ID");
                }
            }
        }
        return null;
    }

    public boolean deleteUserByName(String name) throws SQLException {
        String sql = "DELETE FROM User WHERE name = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getRecentUsers(int limit) throws SQLException {
        String sql = "SELECT * FROM User ORDER BY User_ID DESC LIMIT ?";
        List<User> users = new ArrayList<>();

        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        }

        return users;
    }

    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM User";
        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<User> searchUsers(String keyword) throws SQLException {
        String sql = "SELECT * FROM User WHERE name LIKE ? OR email LIKE ?";
        List<User> users = new ArrayList<>();

        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        }

        return users;
    }

    public int getActiveUsersCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM User";
        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Map<String, Object>> getAllUsers(int offset, int limit) {
        List<Map<String, Object>> users = new ArrayList<>();
        String query = "SELECT * FROM User ORDER BY User_ID LIMIT ? OFFSET ?";
        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(query)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("userId", rs.getInt("User_ID"));
                    user.put("name", rs.getString("name"));
                    user.put("email", rs.getString("email"));
                    user.put("address", rs.getString("address"));
                    user.put("contact", rs.getString("contact"));
                    user.put("picture", rs.getString("picture"));
                    user.put("role", rs.getString("role"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public int getNoOfRecords() {
        String query = "SELECT COUNT(*) FROM User";
        try (PreparedStatement stmt = DBUtil.getConnection().prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}