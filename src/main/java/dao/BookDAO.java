package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Book;
import utils.DBUtil;

public class BookDAO {

    // Get books for new releases page with pagination, sorting, and filtering
    public List<Book> getNewReleaseBooks(int page, int itemsPerPage, String sortBy, String categoryFilter)
            throws SQLException {

        List<Book> books = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT b.* FROM Book b");

        // Add join if category filter is applied
        if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
            sql.append(" JOIN Book_Category bc ON b.Book_ID = bc.Book_ID");
            sql.append(" JOIN Category c ON bc.Category_ID = c.Category_ID");
            sql.append(" WHERE c.category_name = ?");
        }

        // Add sorting
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
                default: // Default sorting is newest first (date-desc)
                    sql.append("b.Book_ID DESC");
            }
        } else {
            sql.append("b.Book_ID DESC"); // Default sorting
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set category filter parameter if exists
            if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
                stmt.setString(paramIndex++, categoryFilter);
            }

            // Set pagination parameters
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

        // Add join if category filter is applied
        if (categoryFilter != null && !categoryFilter.isEmpty() && !categoryFilter.equals("all")) {
            sql.append(" JOIN Book_Category bc ON b.Book_ID = bc.Book_ID");
            sql.append(" JOIN Category c ON bc.Category_ID = c.Category_ID");
            sql.append(" WHERE c.category_name = ?");
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set category filter parameter if exists
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
        sql.append(" JOIN Book_Category bc ON b.Book_ID = bc.Book_ID");
        sql.append(" WHERE bc.Category_ID = ?");

        // Add price range filter if exists
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

        // Add sorting
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
                default:
                    sql.append("b.Book_ID DESC"); // Default newest first
            }
        } else {
            sql.append("b.Book_ID DESC"); // Default sorting
        }

        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // Set category ID
            stmt.setInt(paramIndex++, categoryId);

            // Set price range parameters if exists
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

            // Set pagination parameters
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
        sql.append(" JOIN Book_Category bc ON b.Book_ID = bc.Book_ID");
        sql.append(" WHERE bc.Category_ID = ?");

        // Add price range filter if exists
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

            // Set category ID
            stmt.setInt(paramIndex++, categoryId);

            // Set price range parameters if exists
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
        // In a real application, this would be based on user's history, popular books,
        // etc.
        // For now, we'll just get some random books as recommendation

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

    // Get a book by ID
    public Book getBookById(int bookId) throws SQLException {
        String sql = "SELECT * FROM Book WHERE Book_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }
        }

        return null;
    }

    // Get all books
    public List<Book> getAllBooks() throws SQLException {
        String sql = "SELECT * FROM Book";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Get total number of books
    public int getTotalBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Book";
        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Get books by category
    public List<Book> getBooksByCategory(int categoryId) throws SQLException {
        String sql = "SELECT b.* FROM Book b JOIN Book_Category bc ON b.Book_ID = bc.Book_ID WHERE bc.Category_ID = ?";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
    }

    // Get top selling books
    public List<Book> getTopSellingBooks(int limit) throws SQLException {
        // In a real implementation, this would join with order items to get actual
        // sales data
        // For now, we'll just return some books
        String sql = "SELECT * FROM Book LIMIT ?";
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

    // Add a new book
    public boolean addBook(Book book) throws SQLException {
        String sql = "INSERT INTO Book (Book_name, price, writer_name, picture) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, book.getBookName());
            stmt.setDouble(2, book.getPrice());
            stmt.setString(3, book.getWriterName());
            stmt.setString(4, book.getPicture());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        book.setBookId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        }
        return false;
    }

    // Update an existing book
    public boolean updateBook(Book book) throws SQLException {
        String sql = "UPDATE Book SET Book_name = ?, price = ?, writer_name = ?, picture = ? WHERE Book_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getBookName());
            stmt.setDouble(2, book.getPrice());
            stmt.setString(3, book.getWriterName());
            stmt.setString(4, book.getPicture());
            stmt.setInt(5, book.getBookId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Delete a book
    public boolean deleteBook(int bookId) throws SQLException {
        String sql = "DELETE FROM Book WHERE Book_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Search books by title or author
    public List<Book> searchBooks(String keyword) throws SQLException {
        String sql = "SELECT * FROM Book WHERE Book_name LIKE ? OR writer_name LIKE ?";
        List<Book> books = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
        }
        return books;
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
}