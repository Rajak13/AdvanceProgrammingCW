package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import model.SuggestionBook;
import utils.DBUtil;

public class SuggestionDAO {

    // Create a new book suggestion
    public boolean createSuggestion(SuggestionBook suggestion, String email) throws SQLException {
        String sql = "INSERT INTO SuggestionBooks (Suggested_book, category, writer, description, date, User_ID) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, suggestion.getSuggestedBook());
            stmt.setString(2, suggestion.getCategory());
            stmt.setString(3, suggestion.getWriter());
            stmt.setString(4, suggestion.getDescription());
            stmt.setTimestamp(5, new Timestamp(suggestion.getDate().getTime()));

            if (suggestion.getUserId() != null) {
                stmt.setInt(6, suggestion.getUserId());
            } else {
                // If user is not logged in, try to find user by email
                if (email != null && !email.isEmpty()) {
                    UserDAO userDAO = new UserDAO();
                    Integer userId = userDAO.getUserIdByEmail(email);
                    if (userId != null) {
                        stmt.setInt(6, userId);
                    } else {
                        stmt.setNull(6, java.sql.Types.INTEGER);
                    }
                } else {
                    stmt.setNull(6, java.sql.Types.INTEGER);
                }
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        suggestion.setSuggestionId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }

            return false;
        }
    }

    // Get all book suggestions
    public List<SuggestionBook> getAllSuggestions() throws SQLException {
        List<SuggestionBook> suggestions = new ArrayList<>();

        String sql = "SELECT * FROM SuggestionBooks ORDER BY date DESC";

        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                suggestions.add(extractSuggestionFromResultSet(rs));
            }
        }

        return suggestions;
    }

    // Get book suggestions by user ID
    public List<SuggestionBook> getSuggestionsByUserId(int userId) throws SQLException {
        List<SuggestionBook> suggestions = new ArrayList<>();

        String sql = "SELECT * FROM SuggestionBooks WHERE User_ID = ? ORDER BY date DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                suggestions.add(extractSuggestionFromResultSet(rs));
            }
        }

        return suggestions;
    }

    // Get suggestion by ID
    public SuggestionBook getSuggestionById(int suggestionId) throws SQLException {
        String sql = "SELECT * FROM SuggestionBooks WHERE Suggestion_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, suggestionId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractSuggestionFromResultSet(rs);
            }
        }

        return null;
    }

    // Delete a suggestion
    public boolean deleteSuggestion(int suggestionId) throws SQLException {
        String sql = "DELETE FROM SuggestionBooks WHERE Suggestion_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, suggestionId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to extract a SuggestionBook object from ResultSet
    private SuggestionBook extractSuggestionFromResultSet(ResultSet rs) throws SQLException {
        SuggestionBook suggestion = new SuggestionBook();
        suggestion.setSuggestionId(rs.getInt("Suggestion_ID"));
        suggestion.setSuggestedBook(rs.getString("Suggested_book"));
        suggestion.setCategory(rs.getString("category"));
        suggestion.setWriter(rs.getString("writer"));
        suggestion.setDescription(rs.getString("description"));
        suggestion.setDate(new Date(rs.getTimestamp("date").getTime()));

        int userId = rs.getInt("User_ID");
        if (!rs.wasNull()) {
            suggestion.setUserId(userId);
        }

        return suggestion;
    }
}