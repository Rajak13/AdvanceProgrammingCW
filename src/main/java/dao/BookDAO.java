package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Book;
import model.Category;
import utils.DBUtil;

public class BookDAO {

    private static final String INSERT_BOOK = "INSERT INTO Book (Book_name, price, writer_name, picture) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_BOOK = "UPDATE Book SET Book_name = ?, price = ?, writer_name = ?, picture = ?, status = ?, stock = ?, description = ? WHERE Book_ID = ?";
    private static final String DELETE_BOOK = "DELETE FROM Book WHERE Book_ID = ?";
    private static final String GET_BOOK_BY_ID = "SELECT * FROM Book WHERE Book_ID = ?";
    private static final String GET_ALL_BOOKS = "SELECT * FROM Book ORDER BY Book_name";
    private static final String SEARCH_BOOKS = "SELECT * FROM Book WHERE Book_name LIKE ? OR writer_name LIKE ?";

    public BookDAO() {
    }

    public boolean createBook(Book book, List<Integer> categoryIds) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // Insert book
            String sql = "INSERT INTO Book (Book_name, price, writer_name, picture, status, stock, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, book.getBookName());
                stmt.setDouble(2, book.getPrice());
                stmt.setString(3, book.getWriterName());
                stmt.setString(4, book.getPicture());
                stmt.setString(5, book.getStatus());
                stmt.setInt(6, book.getStock());
                stmt.setString(7, book.getDescription());

                int affectedRows = stmt.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                // Get the generated book ID
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int bookId = generatedKeys.getInt(1);
                        book.setBookId(bookId);

                        // Insert book-category relationships
                        if (categoryIds != null && !categoryIds.isEmpty()) {
                            String categorySql = "INSERT INTO book_category (Book_ID, Category_ID) VALUES (?, ?)";
                            try (PreparedStatement categoryStmt = conn.prepareStatement(categorySql)) {
                                for (int categoryId : categoryIds) {
                                    categoryStmt.setInt(1, bookId);
                                    categoryStmt.setInt(2, categoryId);
                                    categoryStmt.addBatch();
                                }
                                categoryStmt.executeBatch();
                            }
                        }
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public boolean updateBook(Book book) throws SQLException {
        String sql = "UPDATE Book SET Book_name = ?, price = ?, writer_name = ?, picture = ?, status = ?, stock = ?, description = ? WHERE Book_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getBookName());
            stmt.setDouble(2, book.getPrice());
            stmt.setString(3, book.getWriterName());
            stmt.setString(4, book.getPicture());
            stmt.setString(5, book.getStatus());
            stmt.setInt(6, book.getStock());
            stmt.setString(7, book.getDescription());
            stmt.setInt(8, book.getBookId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBook(int bookId) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_BOOK)) {

            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Book getBookById(int bookId) throws SQLException {
        String sql = "SELECT * FROM Book WHERE Book_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Book book = new Book();
                    book.setBookId(rs.getInt("Book_ID"));
                    book.setBookName(rs.getString("Book_name"));
                    book.setPrice(rs.getDouble("price"));
                    book.setWriterName(rs.getString("writer_name"));
                    book.setPicture(rs.getString("picture"));
                    book.setStatus(rs.getString("status"));
                    book.setStock(rs.getInt("stock"));
                    book.setDescription(rs.getString("description"));
                    return book;
                }
            }
        }
        return null;
    }

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ALL_BOOKS)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("Book_ID"));
                book.setBookName(rs.getString("Book_name"));
                book.setPrice(rs.getDouble("price"));
                book.setWriterName(rs.getString("writer_name"));
                book.setPicture(rs.getString("picture"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public List<Book> searchBooks(String query) {
        List<Book> books = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SEARCH_BOOKS)) {

            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("Book_ID"));
                book.setBookName(rs.getString("Book_name"));
                book.setPrice(rs.getDouble("price"));
                book.setWriterName(rs.getString("writer_name"));
                book.setPicture(rs.getString("picture"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // Get books for new releases page with pagination, sorting, and filtering
    public List<Book> getNewReleaseBooks(int page, int itemsPerPage, String sortBy, String categoryFilter)
            throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.* FROM Book b");

        if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
            sql.append(" JOIN Book_Category bc ON b.Book_ID = bc.Book_ID");
            sql.append(" JOIN Category c ON bc.Category_ID = c.Category_ID");
            sql.append(" WHERE c.category_name = ?");
        }

        sql.append(" ORDER BY ");
        if (sortBy != null) {
            switch (sortBy) {
                case "price-low":
                    sql.append("b.price ASC");
                    break;
                case "price-high":
                    sql.append("b.price DESC");
                    break;
                case "name-asc":
                    sql.append("b.Book_name ASC");
                    break;
                case "name-desc":
                    sql.append("b.Book_name DESC");
                    break;
                case "date-asc":
                    sql.append("b.Book_ID ASC");
                    break;
                default:
                    sql.append("b.Book_ID DESC");
            }
        } else {
            sql.append("b.Book_ID DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
                stmt.setString(paramIndex++, categoryFilter);
            }

            stmt.setInt(paramIndex++, itemsPerPage);
            stmt.setInt(paramIndex, (page - 1) * itemsPerPage);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Count total number of books for new releases page with filtering
    public int countNewReleaseBooks(String categoryFilter) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM Book b");

        if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
            sql.append(" JOIN Book_Category bc ON b.book_id = bc.book_id");
            sql.append(" JOIN Category c ON bc.category_id = c.category_id");
            sql.append(" WHERE c.category_name = ?");
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
                stmt.setString(1, categoryFilter);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Get books by category with pagination, sorting, and price filtering
    public List<Book> getBooksByCategory(int categoryId, int page, int itemsPerPage, String sortBy, String priceRange)
            throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT b.* FROM Book b");
        sql.append(" JOIN Book_Category bc ON b.book_id = bc.book_id");
        sql.append(" WHERE bc.category_id = ?");

        if (priceRange != null && !priceRange.isEmpty()) {
            String[] prices = priceRange.split("-");
            if (prices.length == 2) {
                try {
                    double minPrice = Double.parseDouble(prices[0]);
                    double maxPrice = Double.parseDouble(prices[1]);
                    sql.append(" AND b.price BETWEEN ? AND ?");
                } catch (NumberFormatException e) {
                    // Invalid price format, ignore filter
                }
            }
        }

        sql.append(" ORDER BY ");
        if (sortBy != null) {
            switch (sortBy) {
                case "price-low":
                    sql.append("b.price ASC");
                    break;
                case "price-high":
                    sql.append("b.price DESC");
                    break;
                case "name-asc":
                    sql.append("b.book_name ASC");
                    break;
                case "name-desc":
                    sql.append("b.book_name DESC");
                    break;
                default:
                    sql.append("b.book_id DESC");
            }
        } else {
            sql.append("b.book_id DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, categoryId);

            if (priceRange != null && !priceRange.isEmpty()) {
                String[] prices = priceRange.split("-");
                if (prices.length == 2) {
                    try {
                        double minPrice = Double.parseDouble(prices[0]);
                        double maxPrice = Double.parseDouble(prices[1]);
                        stmt.setDouble(paramIndex++, minPrice);
                        stmt.setDouble(paramIndex++, maxPrice);
                    } catch (NumberFormatException e) {
                        // Invalid price format, ignore filter
                    }
                }
            }

            stmt.setInt(paramIndex++, itemsPerPage);
            stmt.setInt(paramIndex, (page - 1) * itemsPerPage);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Count total number of books by category with price filtering
    public int countBooksByCategory(int categoryId, String priceRange) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM Book b");
        sql.append(" JOIN Book_Category bc ON b.book_id = bc.book_id");
        sql.append(" WHERE bc.category_id = ?");

        if (priceRange != null && !priceRange.isEmpty()) {
            String[] prices = priceRange.split("-");
            if (prices.length == 2) {
                try {
                    double minPrice = Double.parseDouble(prices[0]);
                    double maxPrice = Double.parseDouble(prices[1]);
                    sql.append(" AND b.price BETWEEN ? AND ?");
                } catch (NumberFormatException e) {
                    // Invalid price format, ignore filter
                }
            }
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, categoryId);

            if (priceRange != null && !priceRange.isEmpty()) {
                String[] prices = priceRange.split("-");
                if (prices.length == 2) {
                    try {
                        double minPrice = Double.parseDouble(prices[0]);
                        double maxPrice = Double.parseDouble(prices[1]);
                        stmt.setDouble(paramIndex++, minPrice);
                        stmt.setDouble(paramIndex++, maxPrice);
                    } catch (NumberFormatException e) {
                        // Invalid price format, ignore filter
                    }
                }
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }

    // Get recommended books
    public List<Book> getRecommendedBooks(int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM Book ORDER BY RAND() LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Get total number of books
    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM Book";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get top selling books
    public List<Book> getTopSellingBooks(int limit) throws SQLException {
        String sql = "SELECT b.*, COUNT(oi.order_id) as sales_count " +
                "FROM Book b " +
                "LEFT JOIN Order_Item oi ON b.Book_ID = oi.Book_ID " +
                "GROUP BY b.Book_ID " +
                "ORDER BY sales_count DESC " +
                "LIMIT ?";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Helper method to add book categories
    private void addBookCategories(int bookId, String categories) throws SQLException {
        String[] categoryNames = categories.split(",");
        String sql = "INSERT INTO Book_Category (Book_ID, Category_ID) " +
                "SELECT ?, Category_ID FROM Category WHERE category_name = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (String categoryName : categoryNames) {
                stmt.setInt(1, bookId);
                stmt.setString(2, categoryName.trim());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    // Helper method to delete book categories
    private void deleteBookCategories(int bookId) throws SQLException {
        String sql = "DELETE FROM Book_Category WHERE Book_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            stmt.executeUpdate();
        }
    }

    // Helper method to extract a Book object from ResultSet
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("Book_ID"));
        book.setBookName(rs.getString("Book_name"));
        book.setPrice(rs.getDouble("price"));
        book.setWriterName(rs.getString("writer_name"));
        book.setPicture(rs.getString("picture"));
        return book;
    }

    public List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        String query = "SELECT b.*, c.category_name FROM Book b " +
                "JOIN Category c ON b.category_id = c.category_id " +
                "ORDER BY b.created_at DESC LIMIT 5";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("bookId", rs.getInt("book_id"));
                activity.put("title", rs.getString("title"));
                activity.put("category", rs.getString("category_name"));
                activity.put("createdAt", rs.getTimestamp("created_at"));
                activities.add(activity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    public List<Map<String, Object>> getAllBooks(int offset, int limit) {
        List<Map<String, Object>> books = new ArrayList<>();
        String query = "SELECT b.*, GROUP_CONCAT(c.category_name) as categories " +
                "FROM Book b " +
                "LEFT JOIN Book_Category bc ON b.Book_ID = bc.Book_ID " +
                "LEFT JOIN Category c ON bc.Category_ID = c.Category_ID " +
                "GROUP BY b.Book_ID " +
                "ORDER BY b.Book_ID LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> book = new HashMap<>();
                    book.put("id", rs.getInt("Book_ID"));
                    book.put("title", rs.getString("Book_name"));
                    book.put("price", rs.getDouble("price"));
                    book.put("writer", rs.getString("writer_name"));
                    book.put("picture", rs.getString("picture"));
                    book.put("categories", rs.getString("categories"));
                    books.add(book);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public int getNoOfRecords() {
        String query = "SELECT COUNT(*) FROM Book";
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getAllCategories() {
        List<Map<String, Object>> categories = new ArrayList<>();
        String query = "SELECT c.*, COUNT(bc.Book_ID) as book_count " +
                "FROM Category c " +
                "LEFT JOIN Book_Category bc ON c.Category_ID = bc.Category_ID " +
                "GROUP BY c.Category_ID";
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("id", rs.getInt("Category_ID"));
                category.put("name", rs.getString("category_name"));
                category.put("description", rs.getString("description"));
                category.put("bookCount", rs.getInt("book_count"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String query = "SELECT b.*, c.name as categoryName FROM Book b " +
                "JOIN Category c ON b.categoryId = c.id " +
                "WHERE b.categoryId = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(extractBookFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public List<Category> getCategoriesForBook(int bookId) throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.* FROM category c JOIN book_category bc ON c.Category_ID = bc.Category_ID WHERE bc.Book_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("Category_ID"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    categories.add(category);
                }
            }
        }
        return categories;
    }

    public void updateBookCategories(int bookId, List<Integer> categoryIds) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // First, delete all existing category associations for this book
            String deleteSql = "DELETE FROM book_category WHERE Book_ID = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, bookId);
                deleteStmt.executeUpdate();
            }

            // Then, insert the new category associations
            if (categoryIds != null && !categoryIds.isEmpty()) {
                String insertSql = "INSERT INTO book_category (Book_ID, Category_ID) VALUES (?, ?)";
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    for (int categoryId : categoryIds) {
                        insertStmt.setInt(1, bookId);
                        insertStmt.setInt(2, categoryId);
                        insertStmt.addBatch();
                    }
                    insertStmt.executeBatch();
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
}