package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Cart;
import utils.DBUtil;

public class CartDAO {
    private static final String INSERT_CART = "INSERT INTO cart (quantity, User_ID, Book_ID) VALUES (?, ?, ?)";
    private static final String UPDATE_CART = "UPDATE cart SET quantity = ? WHERE Cart_id = ?";
    private static final String DELETE_CART = "DELETE FROM cart WHERE Cart_id = ?";
    private static final String GET_CART_BY_ID = "SELECT * FROM cart WHERE Cart_id = ?";
    private static final String GET_CART_BY_USER = "SELECT * FROM cart WHERE User_ID = ?";
    private static final String GET_CART_BY_USER_AND_BOOK = "SELECT * FROM cart WHERE User_ID = ? AND Book_ID = ?";

    public CartDAO() {
    }

    public int createCart(Cart cart) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_CART, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, cart.getQuantity());
            stmt.setInt(2, cart.getUserId());
            stmt.setInt(3, cart.getBookId());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateCart(Cart cart) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_CART)) {

            stmt.setInt(1, cart.getQuantity());
            stmt.setInt(2, cart.getCartId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCart(int cartId) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_CART)) {

            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Cart getCartById(int cartId) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CART_BY_ID)) {

            stmt.setInt(1, cartId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("Cart_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setUserId(rs.getInt("User_ID"));
                cart.setBookId(rs.getInt("Book_ID"));
                return cart;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Cart> getCartByUser(int userId) {
        List<Cart> cartItems = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CART_BY_USER)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("Cart_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setUserId(rs.getInt("User_ID"));
                cart.setBookId(rs.getInt("Book_ID"));
                cartItems.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartItems;
    }

    public Cart getCartByUserAndBook(int userId, int bookId) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_CART_BY_USER_AND_BOOK)) {

            stmt.setInt(1, userId);
            stmt.setInt(2, bookId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Cart cart = new Cart();
                cart.setCartId(rs.getInt("Cart_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setUserId(rs.getInt("User_ID"));
                cart.setBookId(rs.getInt("Book_ID"));
                return cart;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}