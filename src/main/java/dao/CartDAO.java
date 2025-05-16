package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Book;
import model.CartItem;
import utils.DBUtil;

public class CartDAO {
    private static final String GET_CART_ITEMS = "SELECT c.*, b.* FROM cart c " +
            "JOIN book b ON c.Book_ID = b.Book_ID " +
            "WHERE c.User_ID = ?";
    private static final String GET_CART_ITEM = "SELECT c.*, b.* FROM cart c JOIN book b ON c.Book_ID = b.Book_ID WHERE c.User_ID = ? AND c.Book_ID = ?";
    private static final String ADD_TO_CART = "INSERT INTO cart (User_ID, Book_ID, quantity) VALUES (?, ?, ?)";
    private static final String UPDATE_QUANTITY = "UPDATE cart SET quantity = ? WHERE Cart_id = ? AND User_ID = ?";
    private static final String REMOVE_FROM_CART = "DELETE FROM cart WHERE Cart_id = ? AND User_ID = ?";
    private static final String CLEAR_CART = "DELETE FROM cart WHERE User_ID = ?";

    public List<CartItem> getCartItems(int userId) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CART_ITEMS)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem cartItem = new CartItem();
                    cartItem.setCartId(rs.getInt("Cart_id"));
                    cartItem.setQuantity(rs.getInt("quantity"));
                    cartItem.setBookId(rs.getInt("Book_ID"));
                    cartItem.setUserId(rs.getInt("User_ID"));

                    Book book = new Book();
                    book.setBookId(rs.getInt("Book_ID"));
                    book.setBookName(rs.getString("Book_name"));
                    book.setWriterName(rs.getString("writer_name"));
                    book.setPrice(rs.getDouble("price"));
                    book.setPicture(rs.getString("picture"));
                    book.setStock(rs.getInt("stock"));

                    cartItem.setBook(book);
                    cartItems.add(cartItem);
                }
            }
        }
        return cartItems;
    }

    public CartItem getCartItem(int userId, int bookId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CART_ITEM)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    CartItem cartItem = new CartItem();
                    cartItem.setCartId(rs.getInt("Cart_id"));
                    cartItem.setQuantity(rs.getInt("quantity"));
                    cartItem.setBookId(rs.getInt("Book_ID"));
                    cartItem.setUserId(rs.getInt("User_ID"));

                    Book book = new Book();
                    book.setBookId(rs.getInt("Book_ID"));
                    book.setBookName(rs.getString("Book_name"));
                    book.setWriterName(rs.getString("writer_name"));
                    book.setPrice(rs.getDouble("price"));
                    book.setPicture(rs.getString("picture"));

                    cartItem.setBook(book);
                    return cartItem;
                }
            }
        }
        return null;
    }

    public boolean addToCart(CartItem cartItem) throws SQLException {
        try (Connection conn = DBUtil.getConnection()) {
            // Check if the item already exists
            PreparedStatement checkStmt = conn.prepareStatement(GET_CART_ITEM);
            checkStmt.setInt(1, cartItem.getUserId());
            checkStmt.setInt(2, cartItem.getBookId());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                // Item exists, update quantity
                int cartId = rs.getInt("Cart_id");
                int existingQty = rs.getInt("quantity");
                int newQty = existingQty + cartItem.getQuantity();
                PreparedStatement updateStmt = conn.prepareStatement(UPDATE_QUANTITY);
                updateStmt.setInt(1, newQty);
                updateStmt.setInt(2, cartId);
                updateStmt.setInt(3, cartItem.getUserId());
                return updateStmt.executeUpdate() > 0;
            } else {
                // Item does not exist, insert new row
                PreparedStatement insertStmt = conn.prepareStatement(ADD_TO_CART);
                insertStmt.setInt(1, cartItem.getUserId());
                insertStmt.setInt(2, cartItem.getBookId());
                insertStmt.setInt(3, cartItem.getQuantity());
                return insertStmt.executeUpdate() > 0;
            }
        }
    }

    public boolean updateCartItem(int cartId, int userId, int quantity) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_QUANTITY)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            stmt.setInt(3, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean removeFromCart(int cartId, int userId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(REMOVE_FROM_CART)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean clearCart(int userId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CLEAR_CART)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }
}