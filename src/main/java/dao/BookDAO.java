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

    private static final String INSERT_BOOK = "INSERT INTO books (name, price, writer, image_url, status, stock, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_BOOK = "UPDATE books SET name = ?, price = ?, writer = ?, image_url = ?, status = ?, stock = ?, description = ? WHERE id = ?";
    private static final String DELETE_BOOK = "DELETE FROM books WHERE id = ?";
    private static final String GET_BOOK_BY_ID = "SELECT * FROM books WHERE id = ?";
    private static final String GET_ALL_BOOKS = "SELECT * FROM books ORDER BY name";
    private static final String COUNT_BOOKS = "SELECT COUNT(*) FROM book";
    private static final String GET_BOOKS_BY_CATEGORY = "SELECT b.* FROM book b JOIN book_category bc ON b.Book_ID = bc.Book_ID WHERE bc.Category_ID = ?";
    private static final String GET_BOOKS_BY_WRITER = "SELECT * FROM book WHERE writer_name = ?";
    private static final String GET_BOOKS_BY_STATUS = "SELECT * FROM book WHERE status = ?";
    private static final String GET_BOOKS_BY_PRICE_RANGE = "SELECT * FROM book WHERE price BETWEEN ? AND ?";
    private static final String GET_BOOKS_BY_STOCK = "SELECT * FROM book WHERE stock <= ?";
    private static final String GET_BOOKS_BY_SEARCH = "SELECT * FROM book WHERE Book_name LIKE ? OR writer_name LIKE ? OR description LIKE ?";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER = "SELECT * FROM books WHERE writer = ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_STATUS = "SELECT * FROM books WHERE status = ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_PRICE_RANGE = "SELECT * FROM books WHERE price BETWEEN ? AND ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_STOCK = "SELECT * FROM books WHERE stock <= ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_WRITER = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.writer = ? AND (b.name LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_STATUS = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.status = ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_PRICE_RANGE = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.price BETWEEN ? AND ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_STOCK = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.stock <= ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_STATUS = "SELECT * FROM books WHERE writer = ? AND status = ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_PRICE_RANGE = "SELECT * FROM books WHERE writer = ? AND price BETWEEN ? AND ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_STOCK = "SELECT * FROM books WHERE writer = ? AND stock <= ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_STATUS_AND_PRICE_RANGE = "SELECT * FROM books WHERE status = ? AND price BETWEEN ? AND ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_STATUS_AND_STOCK = "SELECT * FROM books WHERE status = ? AND stock <= ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_PRICE_RANGE_AND_STOCK = "SELECT * FROM books WHERE price BETWEEN ? AND ? AND stock <= ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_WRITER_AND_STATUS = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.writer = ? AND b.status = ? AND (b.name LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_WRITER_AND_PRICE_RANGE = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.writer = ? AND b.price BETWEEN ? AND ? AND (b.name LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_WRITER_AND_STOCK = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.writer = ? AND b.stock <= ? AND (b.name LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_STATUS_AND_PRICE_RANGE = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.status = ? AND b.price BETWEEN ? AND ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_STATUS_AND_STOCK = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.status = ? AND b.stock <= ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_CATEGORY_AND_PRICE_RANGE_AND_STOCK = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.price BETWEEN ? AND ? AND b.stock <= ? AND (b.name LIKE ? OR b.writer LIKE ? OR b.description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_STATUS_AND_PRICE_RANGE = "SELECT * FROM books WHERE writer = ? AND status = ? AND price BETWEEN ? AND ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_STATUS_AND_STOCK = "SELECT * FROM books WHERE writer = ? AND status = ? AND stock <= ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_WRITER_AND_PRICE_RANGE_AND_STOCK = "SELECT * FROM books WHERE writer = ? AND price BETWEEN ? AND ? AND stock <= ? AND (name LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_STATUS_AND_PRICE_RANGE_AND_STOCK = "SELECT * FROM books WHERE status = ? AND price BETWEEN ? AND ? AND stock <= ? AND (name LIKE ? OR writer LIKE ? OR description LIKE ?)";
    private static final String GET_BOOKS_BY_SEARCH_WITH_ALL = "SELECT b.* FROM books b JOIN book_category bc ON b.id = bc.book_id WHERE bc.category_id = ? AND b.writer = ? AND b.status = ? AND b.price BETWEEN ? AND ? AND b.stock <= ? AND (b.name LIKE ? OR b.description LIKE ?)";

    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public BookDAO() throws SQLException {
        this.conn = DBUtil.getConnection();
    }

    public BookDAO(Connection conn) {
        this.conn = conn;
    }

    public Book createBook(Book book) throws SQLException {
        String sql = "INSERT INTO book (Book_name, price, writer_name, picture, status, stock, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
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
                throw new SQLException("Creating book failed, no rows affected.");
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    book.setBookId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating book failed, no ID obtained.");
                }
            }
            return book;
        }
    }

    public Book getBook(int bookId) throws SQLException {
        String sql = "SELECT * FROM book WHERE Book_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    return book;
                }
            }
        }
        return null;
    }

    public boolean updateBook(Book book) throws SQLException {
        String sql = "UPDATE book SET Book_name = ?, price = ?, writer_name = ?, picture = ?, status = ?, stock = ?, description = ? WHERE Book_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    public boolean deleteBook(int bookId) throws SQLException {
        String sql = "DELETE FROM book WHERE Book_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Book> getAllBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book ORDER BY Book_name";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("Book_ID"));
                book.setBookName(rs.getString("Book_name"));
                book.setWriterName(rs.getString("writer_name"));
                book.setPrice(rs.getDouble("price"));
                book.setPicture(rs.getString("picture"));
                book.setStatus(rs.getString("status"));
                book.setStock(rs.getInt("stock"));
                book.setDescription(rs.getString("description"));
                books.add(book);
            }
        }
        return books;
    }

    public long getTotalBooks() throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(COUNT_BOOKS);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0;
    }

    public List<Book> getBooksByCategory(long categoryId) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_CATEGORY)) {
            stmt.setLong(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> getBooksByWriter(String writer) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_WRITER)) {
            stmt.setString(1, writer);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> getBooksByStatus(String status) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_STATUS)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> getBooksByPriceRange(double minPrice, double maxPrice) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_PRICE_RANGE)) {
            stmt.setDouble(1, minPrice);
            stmt.setDouble(2, maxPrice);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> getBooksByStock(int maxStock) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_STOCK)) {
            stmt.setInt(1, maxStock);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public List<Book> searchBooks(String keyword) throws SQLException {
        List<Book> books = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_BOOKS_BY_SEARCH)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
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

    public List<Book> getNewReleaseBooks(int page, int itemsPerPage, String sortBy, String categoryFilter)
            throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'new-release' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ? ";
        }

        sql += getSortClause(sortBy);
        sql += "LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
            }

            stmt.setInt(paramIndex++, itemsPerPage);
            stmt.setInt(paramIndex, (page - 1) * itemsPerPage);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    public int countNewReleaseBooks(String categoryFilter) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT b.Book_ID) FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'new-release' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ?";
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(1, Integer.parseInt(categoryFilter));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean createBook(Book book, List<Integer> categoryIds) throws SQLException {
        String sql = "INSERT INTO book (Book_name, price, writer_name, picture, status, stock, description) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, book.getBookName());
            stmt.setDouble(2, book.getPrice());
            stmt.setString(3, book.getWriterName());
            stmt.setString(4, book.getPicture());
            stmt.setString(5, book.getStatus());
            stmt.setInt(6, book.getStock());
            stmt.setString(7, book.getDescription());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int bookId = generatedKeys.getInt(1);
                        if (categoryIds != null && !categoryIds.isEmpty()) {
                            updateBookCategories(bookId, categoryIds);
                        }
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public void updateBookCategories(int bookId, List<Integer> categoryIds) throws SQLException {
        // First delete existing categories
        String deleteSql = "DELETE FROM book_category WHERE book_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
            stmt.setInt(1, bookId);
            stmt.executeUpdate();
        }

        // Then insert new categories
        if (categoryIds != null && !categoryIds.isEmpty()) {
            insertBookCategories(bookId, categoryIds);
        }
    }

    private void insertBookCategories(long bookId, List<Integer> categoryIds) throws SQLException {
        String sql = "INSERT INTO book_category (book_id, category_id) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (Integer categoryId : categoryIds) {
                stmt.setLong(1, bookId);
                stmt.setInt(2, categoryId);
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public List<Map<String, Object>> getRecentActivities() throws SQLException {
        List<Map<String, Object>> activities = new ArrayList<>();
        String sql = "SELECT name, status, stock FROM books ORDER BY id DESC LIMIT 5";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("bookName", rs.getString("name"));
                activity.put("status", rs.getString("status"));
                activity.put("stock", rs.getInt("stock"));
                activities.add(activity);
            }
        }
        return activities;
    }

    public List<Book> getAllBooks(int page, int pageSize, String sortBy, String priceRange) throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM book");

        if (priceRange != null && !priceRange.isEmpty()) {
            String[] range = priceRange.split("-");
            if (range.length == 2) {
                sql.append(" WHERE price BETWEEN ? AND ?");
            }
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY ").append(sortBy);
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (priceRange != null && !priceRange.isEmpty()) {
                String[] range = priceRange.split("-");
                if (range.length == 2) {
                    stmt.setDouble(paramIndex++, Double.parseDouble(range[0]));
                    stmt.setDouble(paramIndex++, Double.parseDouble(range[1]));
                }
            }
            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex, (page - 1) * pageSize);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public List<Book> getBooksByCategory(int categoryId, int page, int pageSize, String sortBy, String priceRange)
            throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.* FROM book b " +
                        "JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                        "WHERE bc.Category_ID = ?");

        if (priceRange != null && !priceRange.isEmpty()) {
            String[] range = priceRange.split("-");
            if (range.length == 2) {
                sql.append(" AND b.price BETWEEN ? AND ?");
            }
        }

        if (sortBy != null && !sortBy.isEmpty()) {
            sql.append(" ORDER BY b.").append(sortBy);
        }

        sql.append(" LIMIT ? OFFSET ?");

        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            stmt.setInt(paramIndex++, categoryId);

            if (priceRange != null && !priceRange.isEmpty()) {
                String[] range = priceRange.split("-");
                if (range.length == 2) {
                    stmt.setDouble(paramIndex++, Double.parseDouble(range[0]));
                    stmt.setDouble(paramIndex++, Double.parseDouble(range[1]));
                }
            }

            stmt.setInt(paramIndex++, pageSize);
            stmt.setInt(paramIndex, (page - 1) * pageSize);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public List<Book> getFeaturedBooks(int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book WHERE status = 'bestseller' LIMIT ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public List<Book> getNewArrivals(int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book WHERE status = 'New' ORDER BY Book_ID DESC LIMIT ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public List<Book> getBestSellers(int page, int itemsPerPage, String sortBy, String categoryFilter)
            throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'bestseller' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ? ";
        }

        sql += getSortClause(sortBy);
        sql += "LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
            }

            stmt.setInt(paramIndex++, itemsPerPage);
            stmt.setInt(paramIndex, (page - 1) * itemsPerPage);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public int countBestSellers(String categoryFilter) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT b.Book_ID) FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'bestseller' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ?";
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(1, Integer.parseInt(categoryFilter));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<Book> getDeals(int page, int itemsPerPage, String sortBy, String categoryFilter) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.* FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'deals' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ? ";
        }

        sql += getSortClause(sortBy);
        sql += "LIMIT ? OFFSET ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            int paramIndex = 1;
            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(categoryFilter));
            }

            stmt.setInt(paramIndex++, itemsPerPage);
            stmt.setInt(paramIndex, (page - 1) * itemsPerPage);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Book book = mapResultSetToBook(rs);
                    book.setCategories(getCategoriesForBook(book.getBookId()));
                    books.add(book);
                }
            }
        }
        return books;
    }

    public int countDeals(String categoryFilter) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT b.Book_ID) FROM book b " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "WHERE b.status = 'deals' ";

        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql += "AND bc.Category_ID = ?";
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (categoryFilter != null && !categoryFilter.isEmpty()) {
                stmt.setInt(1, Integer.parseInt(categoryFilter));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private String getSortClause(String sortBy) {
        if (sortBy == null)
            return "ORDER BY b.Book_ID DESC ";

        switch (sortBy) {
            case "price-low":
                return "ORDER BY b.price ASC ";
            case "price-high":
                return "ORDER BY b.price DESC ";
            case "name-asc":
                return "ORDER BY b.Book_name ASC ";
            case "name-desc":
                return "ORDER BY b.Book_name DESC ";
            case "date-desc":
                return "ORDER BY b.Book_ID DESC ";
            case "date-asc":
                return "ORDER BY b.Book_ID ASC ";
            case "discount":
                return "ORDER BY b.price ASC ";
            default:
                return "ORDER BY b.Book_ID DESC ";
        }
    }

    private List<Category> getCategoriesForBook(int bookId) throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT c.Category_ID, c.category_name, c.description FROM category c " +
                "JOIN book_category bc ON c.Category_ID = bc.Category_ID WHERE bc.Book_ID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getInt("Category_ID"));
                    category.setName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    categories.add(category);
                }
            }
        }
        return categories;
    }

    public int getNewBooksThisMonth() throws SQLException {
        String sql = "SELECT COUNT(*) FROM book WHERE date >= LAST_DAY(NOW()) + INTERVAL 1 DAY - INTERVAL 1 MONTH";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Get the count of books with stock below a certain threshold.
     * 
     * @param threshold The stock quantity below which a book is considered low
     *                  stock.
     * @return The number of low stock books.
     * @throws SQLException
     */
    public int getLowStockBooksCount(int threshold) throws SQLException {
        String sql = "SELECT COUNT(*) FROM book WHERE stock < ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, threshold);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<Book> getTopSellingBooks(int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, COUNT(oi.book_id) as sales_count, SUM(oi.quantity * oi.price) as revenue, c.category_name "
                +
                "FROM book b " +
                "LEFT JOIN order_item oi ON b.Book_ID = oi.Book_ID " +
                "LEFT JOIN book_category bc ON b.Book_ID = bc.Book_ID " +
                "LEFT JOIN category c ON bc.Category_ID = c.Category_ID " +
                "GROUP BY b.Book_ID, c.category_name " +
                "ORDER BY sales_count DESC " +
                "LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            Map<Integer, Book> bookMap = new HashMap<>();

            while (rs.next()) {
                int bookId = rs.getInt("Book_ID");
                Book book = bookMap.get(bookId);
                if (book == null) {
                    book = new Book();
                    book.setBookId(bookId);
                    book.setBookName(rs.getString("Book_name"));
                    book.setWriterName(rs.getString("writer_name"));
                    book.setPrice(rs.getDouble("price"));
                    book.setPicture(rs.getString("picture"));
                    book.setStatus(rs.getString("status"));
                    book.setStock(rs.getInt("stock"));
                    book.setDescription(rs.getString("description"));
                    book.setSalesCount(rs.getInt("sales_count"));
                    book.setRevenue(rs.getDouble("revenue"));
                    bookMap.put(bookId, book);
                }
                if (book.getCategoryName() == null) {
                    book.setCategoryName(rs.getString("category_name"));
                }
            }
            books.addAll(bookMap.values());
        }
        return books;
    }
}