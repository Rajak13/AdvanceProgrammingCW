package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.User;
import utils.DBUtil;

public class UserDAO {
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM User WHERE name = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        }
        return null;
    }

    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM User WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        }
        return null;
    }

    public Integer getUserIdByEmail(String email) throws SQLException {
        String sql = "SELECT User_ID FROM User WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("User_ID");
            }
        }
        return null;
    }

    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM User WHERE User_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUserFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO User (name, email, password, address, contact, picture) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getContact());
            stmt.setString(6, user.getPicture());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setUserId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE User SET name = ?, email = ?, address = ?, contact = ?, picture = ? WHERE User_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getAddress());
            stmt.setString(4, user.getContact());
            stmt.setString(5, user.getPicture());
            stmt.setInt(6, user.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE User SET password = ? WHERE User_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM User WHERE User_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);

            return stmt.executeUpdate() > 0;
        }
    }

    public List<User> getAllUsers() throws SQLException {
        String sql = "SELECT * FROM User";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }

        return users;
    }

    public List<User> getRecentUsers(int limit) throws SQLException {
        String sql = "SELECT * FROM User ORDER BY User_ID DESC LIMIT ?";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }

        return users;
    }

    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM User";
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<User> searchUsers(String keyword) throws SQLException {
        String sql = "SELECT * FROM User WHERE name LIKE ? OR email LIKE ?";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }

        return users;
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("User_ID"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setAddress(rs.getString("address"));
        user.setContact(rs.getString("contact"));
        user.setPicture(rs.getString("picture"));
        return user;
    }
}