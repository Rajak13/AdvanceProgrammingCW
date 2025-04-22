package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Category;
import utils.DBUtil;

public class CategoryDAO {

    // Get a category by its slug (URL-friendly name)
    public Category getCategoryBySlug(String slug) throws SQLException {
        String sql = "SELECT * FROM Category WHERE category_name = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, slug);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
        }

        return null;
    }

    // Get a category by its ID
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT * FROM Category WHERE Category_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
        }

        return null;
    }

    // Get all categories
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();

        String sql = "SELECT * FROM Category ORDER BY category_name";

        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        }

        return categories;
    }

    // Create a new category
    public boolean createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO Category (category_name, description) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setCategoryId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }

            return false;
        }
    }

    // Update an existing category
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE Category SET category_name = ?, description = ? WHERE Category_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getCategoryId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Delete a category
    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM Category WHERE Category_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, categoryId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Get categories for a specific book
    public List<Category> getCategoriesForBook(int bookId) throws SQLException {
        List<Category> categories = new ArrayList<>();

        String sql = "SELECT c.* FROM Category c " +
                "JOIN Book_Category bc ON c.Category_ID = bc.Category_ID " +
                "WHERE bc.Book_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        }

        return categories;
    }

    // Helper method to extract a Category object from ResultSet
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("Category_ID"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        // Generate slug from category name
        return category;
    }
}