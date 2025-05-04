package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.OrderItem;
import utils.DBUtil;

public class OrderItemDAO {
    private static final String INSERT_ORDER_ITEM = "INSERT INTO order_item (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
    private static final String GET_ORDER_ITEMS = "SELECT oi.*, b.Book_name, b.picture FROM order_item oi " +
            "JOIN Book b ON oi.book_id = b.Book_ID " +
            "WHERE oi.order_id = ?";

    public OrderItemDAO() {
    }

    // Get an order item by its ID
    public OrderItem getOrderItemById(int orderItemId) throws SQLException {
        String sql = "SELECT * FROM order_item WHERE Order_Item_ID = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderItemId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractOrderItemFromResultSet(rs);
            }
        }

        return null;
    }

    // Get all order items for a specific order
    public List<OrderItem> getOrderItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> orderItems = new ArrayList<>();

        String sql = "SELECT * FROM order_item WHERE Order_id = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                orderItems.add(extractOrderItemFromResultSet(rs));
            }
        }

        return orderItems;
    }

    // Create a new order item
    public boolean createOrderItem(OrderItem orderItem) {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(INSERT_ORDER_ITEM)) {

            stmt.setInt(1, orderItem.getOrderId());
            stmt.setInt(2, orderItem.getBookId());
            stmt.setInt(3, orderItem.getQuantity());
            stmt.setDouble(4, orderItem.getPrice());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update an existing order item
    public boolean updateOrderItem(OrderItem orderItem) throws SQLException {
        String sql = "UPDATE order_item SET Quantity = ?, Price = ? WHERE Order_Item_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderItem.getQuantity());
            stmt.setDouble(2, orderItem.getPrice());
            stmt.setInt(3, orderItem.getOrderItemId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Delete an order item
    public boolean deleteOrderItem(int orderItemId) throws SQLException {
        String sql = "DELETE FROM order_item WHERE Order_Item_ID = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderItemId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to extract an OrderItem object from ResultSet
    private OrderItem extractOrderItemFromResultSet(ResultSet rs) throws SQLException {
        OrderItem orderItem = new OrderItem();
        orderItem.setOrderItemId(rs.getInt("Order_Item_ID"));
        orderItem.setOrderId(rs.getInt("Order_id"));
        orderItem.setQuantity(rs.getInt("Quantity"));
        orderItem.setPrice(rs.getDouble("Price"));
        orderItem.setBookId(rs.getInt("Book_ID"));
        return orderItem;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ORDER_ITEMS)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setBookName(rs.getString("Book_name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPicture(rs.getString("picture"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}