package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Category;
import utils.DBUtil;

public class CategoryDAO {
    private static final String GET_ALL_CATEGORIES = "SELECT * FROM category";
    private static final String GET_CATEGORY_BY_ID = "SELECT * FROM category WHERE Category_ID = ?";
    private static final String INSERT_CATEGORY = "INSERT INTO category (category_name, description) VALUES (?, ?)";
    private static final String UPDATE_CATEGORY = "UPDATE category SET category_name = ?, description = ? WHERE Category_ID = ?";
    private static final String DELETE_CATEGORY = "DELETE FROM category WHERE Category_ID = ?";

    // Get a category by its slug (URL-friendly name)
    public Category getCategoryBySlug(String slug) throws SQLException {
        String sql = "SELECT * FROM Category WHERE LOWER(REPLACE(REPLACE(REPLACE(category_name, ' ', '-'), '.', ''), ',', '')) = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, slug.toLowerCase());

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractCategoryFromResultSet(rs);
            }
        }

        return null;
    }

    // Get a category by its ID
    public Category getCategoryById(int categoryId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CATEGORY_BY_ID)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("Category_ID"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    return category;
                }
            }
        }
        return null;
    }

    // Get all categories
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ALL_CATEGORIES);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("Category_ID"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                categories.add(category);
            }
        }
        return categories;
    }

    // Create a new category
    public boolean createCategory(Category category) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_CATEGORY,
                        PreparedStatement.RETURN_GENERATED_KEYS)) {
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
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_CATEGORY)) {
            stmt.setString(1, category.getCategoryName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getCategoryId());
            return stmt.executeUpdate() > 0;
        }
    }

    // Delete a category
    public boolean deleteCategory(int categoryId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_CATEGORY)) {
            stmt.setInt(1, categoryId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get categories for a specific book
    public List<Category> getCategoriesForBook(int bookId) throws SQLException {
        List<Category> categories = new ArrayList<>();

        String sql = "SELECT c.* FROM category c " +
                "JOIN book_category bc ON c.Category_ID = bc.Category_ID " +
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