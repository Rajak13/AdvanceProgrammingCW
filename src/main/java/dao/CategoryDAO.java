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
    private Connection conn;

    public CategoryDAO() throws SQLException {
        this.conn = DBUtil.getConnection();
    }

    public CategoryDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY Category_name";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("Category_ID"));
                category.setName(rs.getString("Category_name"));
                categories.add(category);
            }
        }
        return categories;
    }

    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT * FROM category WHERE Category_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        }
        return null;
    }

    public boolean createCategory(Category category) throws SQLException {
        String sql = "INSERT INTO category (category_name, description) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE category SET category_name = ?, description = ? WHERE Category_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setString(2, category.getDescription());
            stmt.setInt(3, category.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM category WHERE Category_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Category> getTopCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.Category_ID, c.category_name, c.description, " +
                "COUNT(bc.Book_ID) as book_count, " +
                "ROUND(COUNT(bc.Book_ID) * 100.0 / (SELECT COUNT(*) FROM book), 1) as percentage " +
                "FROM category c " +
                "LEFT JOIN book_category bc ON c.Category_ID = bc.Category_ID " +
                "GROUP BY c.Category_ID " +
                "ORDER BY book_count DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("Category_ID"));
                category.setName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                categories.add(category);
            }
        }
        return categories;
    }

    public int getTotalCategories() throws SQLException {
        String sql = "SELECT COUNT(*) FROM category";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("Category_ID"));
        category.setName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        return category;
    }
}