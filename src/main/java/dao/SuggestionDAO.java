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
    private static final String GET_SUGGESTION = "SELECT * FROM suggestionbooks WHERE Suggestion_ID = ?";
    private static final String GET_ALL_SUGGESTIONS = "SELECT * FROM suggestionbooks ORDER BY date DESC";
    private static final String GET_USER_SUGGESTIONS = "SELECT * FROM suggestionbooks WHERE User_ID = ? ORDER BY date DESC";
    private static final String CREATE_SUGGESTION = "INSERT INTO suggestionbooks (Suggested_book, writer, category, description, status, User_ID, date) VALUES (?, ?, ?, ?, ?, ?, NOW())";
    private static final String UPDATE_SUGGESTION = "UPDATE suggestionbooks SET status = ? WHERE Suggestion_ID = ?";
    private static final String DELETE_SUGGESTION = "DELETE FROM suggestionbooks WHERE Suggestion_ID = ?";

    public SuggestionBook getSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_SUGGESTION)) {
            stmt.setInt(1, suggestionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    SuggestionBook suggestion = new SuggestionBook();
                    suggestion.setSuggestionId(rs.getInt("Suggestion_ID"));
                    suggestion.setUserId(rs.getInt("User_ID"));
                    suggestion.setTitle(rs.getString("Suggested_book"));
                    suggestion.setAuthor(rs.getString("writer"));
                    suggestion.setCategory(rs.getString("category"));
                    suggestion.setDescription(rs.getString("description"));
                    suggestion.setStatus(rs.getString("status"));
                    suggestion.setDate(rs.getTimestamp("date"));
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
                suggestion.setSuggestionId(rs.getInt("Suggestion_ID"));
                suggestion.setUserId(rs.getInt("User_ID"));
                suggestion.setTitle(rs.getString("Suggested_book"));
                suggestion.setAuthor(rs.getString("writer"));
                suggestion.setCategory(rs.getString("category"));
                suggestion.setDescription(rs.getString("description"));
                suggestion.setStatus(rs.getString("status"));
                suggestion.setDate(rs.getTimestamp("date"));
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
                    suggestion.setSuggestionId(rs.getInt("Suggestion_ID"));
                    suggestion.setUserId(rs.getInt("User_ID"));
                    suggestion.setTitle(rs.getString("Suggested_book"));
                    suggestion.setAuthor(rs.getString("writer"));
                    suggestion.setCategory(rs.getString("category"));
                    suggestion.setDescription(rs.getString("description"));
                    suggestion.setStatus(rs.getString("status"));
                    suggestion.setDate(rs.getTimestamp("date"));
                    suggestions.add(suggestion);
                }
            }
        }
        return suggestions;
    }

    public boolean createSuggestion(SuggestionBook suggestion) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CREATE_SUGGESTION)) {
            stmt.setString(1, suggestion.getTitle());
            stmt.setString(2, suggestion.getAuthor());
            stmt.setString(3, suggestion.getCategory());
            stmt.setString(4, suggestion.getDescription());
            stmt.setString(5, suggestion.getStatus());
            stmt.setInt(6, suggestion.getUserId());
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