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
    private Connection conn;

    public OrderItemDAO() throws SQLException {
        this.conn = DBUtil.getConnection();
    }

    public OrderItemDAO(Connection conn) {
        this.conn = conn;
    }

    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_item WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToOrderItem(rs));
                }
            }
        }
        return items;
    }

    public OrderItem getOrderItem(int orderItemId) throws SQLException {
        String sql = "SELECT * FROM order_item WHERE order_item_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderItemId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToOrderItem(rs);
                }
            }
        }
        return null;
    }

    public boolean addOrderItem(OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_item (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getBookId());
            stmt.setInt(3, item.getQuantity());
            stmt.setDouble(4, item.getPrice());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateOrderItem(OrderItem item) throws SQLException {
        String sql = "UPDATE order_item SET quantity = ?, price = ? WHERE order_item_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getQuantity());
            stmt.setDouble(2, item.getPrice());
            stmt.setInt(3, item.getOrderItemId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteOrderItem(int orderItemId) throws SQLException {
        String sql = "DELETE FROM order_item WHERE order_item_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderItemId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteOrderItems(int orderId) throws SQLException {
        String sql = "DELETE FROM order_item WHERE order_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getDouble("price"));
        return item;
    }
}