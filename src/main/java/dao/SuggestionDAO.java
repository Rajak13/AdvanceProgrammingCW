package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.SuggestionBook;
import utils.DBUtil;

public class SuggestionDAO {
    private static final String GET_SUGGESTION = "SELECT * FROM suggestion WHERE Suggestion_id = ?";
    private static final String GET_ALL_SUGGESTIONS = "SELECT * FROM suggestion ORDER BY date DESC";
    private static final String GET_USER_SUGGESTIONS = "SELECT * FROM suggestion WHERE User_id = ? ORDER BY date DESC";
    private static final String CREATE_SUGGESTION = "INSERT INTO suggestion (User_id, title, author, description, status, date) VALUES (?, ?, ?, ?, ?, NOW())";
    private static final String UPDATE_SUGGESTION = "UPDATE suggestion SET status = ? WHERE Suggestion_id = ?";
    private static final String DELETE_SUGGESTION = "DELETE FROM suggestion WHERE Suggestion_id = ?";

    public SuggestionBook getSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_SUGGESTION)) {
            stmt.setInt(1, suggestionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    SuggestionBook suggestion = new SuggestionBook();
                    suggestion.setSuggestionId(rs.getInt("Suggestion_id"));
                    suggestion.setUserId(rs.getInt("User_id"));
                    suggestion.setTitle(rs.getString("title"));
                    suggestion.setAuthor(rs.getString("author"));
                    suggestion.setDescription(rs.getString("description"));
                    suggestion.setStatus(rs.getString("status"));
                    return suggestion;
                }
            }
        }
        return null;
    }

    public List<SuggestionBook> getAllSuggestions() throws SQLException {
        List<SuggestionBook> suggestions = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ALL_SUGGESTIONS);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                SuggestionBook suggestion = new SuggestionBook();
                suggestion.setSuggestionId(rs.getInt("Suggestion_id"));
                suggestion.setUserId(rs.getInt("User_id"));
                suggestion.setTitle(rs.getString("title"));
                suggestion.setAuthor(rs.getString("author"));
                suggestion.setDescription(rs.getString("description"));
                suggestion.setStatus(rs.getString("status"));
                suggestions.add(suggestion);
            }
        }
        return suggestions;
    }

    public List<SuggestionBook> getUserSuggestions(int userId) throws SQLException {
        List<SuggestionBook> suggestions = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_USER_SUGGESTIONS)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SuggestionBook suggestion = new SuggestionBook();
                    suggestion.setSuggestionId(rs.getInt("Suggestion_id"));
                    suggestion.setUserId(rs.getInt("User_id"));
                    suggestion.setTitle(rs.getString("title"));
                    suggestion.setAuthor(rs.getString("author"));
                    suggestion.setDescription(rs.getString("description"));
                    suggestion.setStatus(rs.getString("status"));
                    suggestions.add(suggestion);
                }
            }
        }
        return suggestions;
    }

    public boolean createSuggestion(SuggestionBook suggestion) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CREATE_SUGGESTION)) {
            stmt.setInt(1, suggestion.getUserId());
            stmt.setString(2, suggestion.getTitle());
            stmt.setString(3, suggestion.getAuthor());
            stmt.setString(4, suggestion.getDescription());
            stmt.setString(5, suggestion.getStatus());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateSuggestion(SuggestionBook suggestion) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_SUGGESTION)) {
            stmt.setString(1, suggestion.getStatus());
            stmt.setInt(2, suggestion.getSuggestionId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_SUGGESTION)) {
            stmt.setInt(1, suggestionId);
            return stmt.executeUpdate() > 0;
        }
    }
}