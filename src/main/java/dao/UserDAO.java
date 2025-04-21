package dao;
import model.User;
import utils.DBUtil;
import utils.PasswordUtil;
import java.sql.*;

public class UserDAO {
    public User getUserByUsername(String email) throws SQLException {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                return user;
            }
        }
        return null;
    }

    public boolean createUser(User user) throws SQLException {
        String sql = "INSERT INTO Users (username, email, password_hash) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            return stmt.executeUpdate() > 0;
        }
    }
}