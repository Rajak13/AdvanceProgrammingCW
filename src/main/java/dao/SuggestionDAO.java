package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.SuggestionBook;
import utils.DBUtil;

public class SuggestionDAO {
    private static final String INSERT_SUGGESTION = "INSERT INTO suggestionbooks (Suggested_book, category, writer, description, date, User_ID) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String SELECT_ALL_SUGGESTIONS = "SELECT * FROM suggestionbooks ORDER BY date DESC";
    private static final String SELECT_SUGGESTION_BY_ID = "SELECT * FROM suggestionbooks WHERE Suggestion_ID = ?";
    private static final String DELETE_SUGGESTION = "DELETE FROM suggestionbooks WHERE Suggestion_ID = ?";
    private static final String UPDATE_STATUS = "UPDATE suggestionbooks SET status = ? WHERE Suggestion_ID = ?";

    public SuggestionDAO() {
    }

    public boolean createSuggestion(SuggestionBook suggestion) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_SUGGESTION, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, suggestion.getSuggestedBook());
            stmt.setString(2, suggestion.getCategory());
            stmt.setString(3, suggestion.getWriter());
            stmt.setString(4, suggestion.getDescription());
            stmt.setTimestamp(5, suggestion.getDate());
            stmt.setInt(6, suggestion.getUserId());

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

    public List<SuggestionBook> getAllSuggestions() throws SQLException {
        List<SuggestionBook> suggestions = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_SUGGESTIONS);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                suggestions.add(mapResultSetToSuggestion(rs));
            }
        }
        return suggestions;
    }

    public SuggestionBook getSuggestionById(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_SUGGESTION_BY_ID)) {
            stmt.setInt(1, suggestionId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSuggestion(rs);
                }
            }
        }
        return null;
    }

    public boolean deleteSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_SUGGESTION)) {
            stmt.setInt(1, suggestionId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean approveSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_STATUS)) {
            stmt.setString(1, "approved");
            stmt.setInt(2, suggestionId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean rejectSuggestion(int suggestionId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_STATUS)) {
            stmt.setString(1, "rejected");
            stmt.setInt(2, suggestionId);
            return stmt.executeUpdate() > 0;
        }
    }

    private SuggestionBook mapResultSetToSuggestion(ResultSet rs) throws SQLException {
        SuggestionBook suggestion = new SuggestionBook();
        suggestion.setSuggestionId(rs.getInt("Suggestion_ID"));
        suggestion.setSuggestedBook(rs.getString("Suggested_book"));
        suggestion.setCategory(rs.getString("category"));
        suggestion.setWriter(rs.getString("writer"));
        suggestion.setDescription(rs.getString("description"));
        suggestion.setDate(rs.getTimestamp("date"));
        suggestion.setUserId(rs.getInt("User_ID"));
        return suggestion;
    }
}