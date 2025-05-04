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

import model.Order;
import model.OrderItem;
import utils.DBUtil;

/**
 * Data Access Object for Order-related database operations
 */
public class OrderDAO {

    private static final String INSERT_ORDER = "INSERT INTO `order` (Order_date, Status, User_ID) VALUES (?, ?, ?)";
    private static final String INSERT_ORDER_ITEM = "INSERT INTO order_item (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM `order` WHERE Order_id = ?";
    private static final String SELECT_ORDERS_BY_USER = "SELECT * FROM `order` WHERE User_ID = ?";
    private static final String SELECT_ORDER_ITEMS = "SELECT oi.*, b.Book_name, b.picture FROM order_item oi JOIN book b ON oi.Book_ID = b.Book_ID WHERE oi.Order_id = ?";
    private static final String UPDATE_ORDER_STATUS = "UPDATE `order` SET Status = ? WHERE Order_id = ?";

    public OrderDAO() {
    }

    /**
     * Create a new order in the database
     */
    public boolean createOrder(Order order) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement orderStmt = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setTimestamp(1, order.getOrderDate());
                orderStmt.setString(2, order.getStatus());
                orderStmt.setInt(3, order.getUserId());

                int affectedRows = orderStmt.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }

                try (ResultSet generatedKeys = orderStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        order.setOrderId(generatedKeys.getInt(1));
                        conn.commit();
                        return true;
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get an order by ID with all details
     */
    public Order getOrderById(int id) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(id));
                    return order;
                }
            }
        }
        return null;
    }

    /**
     * Get all order items for an order
     */
    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ORDER_ITEMS)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getInt("Order_Item_ID"));
                    item.setOrderId(rs.getInt("Order_id"));
                    item.setBookId(rs.getInt("Book_ID"));
                    item.setQuantity(rs.getInt("Quantity"));
                    item.setPrice(rs.getDouble("Price"));
                    item.setBookName(rs.getString("Book_name"));
                    item.setPicture(rs.getString("picture"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    /**
     * Get all orders with optional pagination, search, and filtering
     */
    public List<Order> getAllOrders(int page, int pageSize, String searchTerm, String statusFilter)
            throws SQLException {
        List<Order> orders = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT o.*, u.* FROM `order` o " +
                        "JOIN users u ON o.User_ID = u.id");

        List<Object> params = new ArrayList<>();

        // Add search condition
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" WHERE (o.Order_id LIKE ? OR u.name LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            if (params.isEmpty()) {
                sql.append(" WHERE");
            } else {
                sql.append(" AND");
            }
            sql.append(" o.Status = ?");
            params.add(statusFilter);
        }

        // Add sorting and pagination
        sql.append(" ORDER BY o.Order_date DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);

                    // Get order items count (without fetching details)
                    int itemCount = getOrderItemCount(order.getOrderId());
                    orders.add(order);
                }
            }
        }

        return orders;
    }

    /**
     * Get the count of items in an order
     */
    private int getOrderItemCount(int orderId) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM order_item WHERE order_id = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Count total orders for pagination
     */
    public int countOrders(String searchTerm, String statusFilter) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM `order` o JOIN users u ON o.User_ID = u.id");

        List<Object> params = new ArrayList<>();

        // Add search condition
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" WHERE (o.Order_id LIKE ? OR u.name LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }

        // Add status filter
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            if (params.isEmpty()) {
                sql.append(" WHERE");
            } else {
                sql.append(" AND");
            }
            sql.append(" o.Status = ?");
            params.add(statusFilter);
        }

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    /**
     * Update order status
     */
    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Get orders for a specific user
     */
    public List<Order> getOrdersByUser(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(SELECT_ORDERS_BY_USER)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderItems(order.getOrderId()));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    /**
     * Map a result set to an Order object
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("Order_id"));
        order.setOrderDate(rs.getTimestamp("Order_date"));
        order.setStatus(rs.getString("Status"));
        order.setUserId(rs.getInt("User_ID"));
        return order;
    }

    public int getTotalOrders() {
        String query = "SELECT COUNT(*) FROM `order`";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public double getTotalRevenue() {
        String query = "SELECT SUM(total_amount) FROM `order` WHERE Status = 'completed'";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * Get all orders with pagination
     */
    public List<Map<String, Object>> getAllOrders(int offset, int limit) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String query = "SELECT o.*, u.name as customer_name, u.email as customer_email " +
                "FROM `order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "ORDER BY o.Order_date DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("id", rs.getInt("Order_id"));
                    order.put("customerName", rs.getString("customer_name"));
                    order.put("customerEmail", rs.getString("customer_email"));
                    order.put("totalAmount", rs.getDouble("total_amount"));
                    order.put("status", rs.getString("Status"));
                    order.put("orderDate", rs.getTimestamp("Order_date"));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public int getNoOfRecords() {
        String query = "SELECT COUNT(*) FROM `order`";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Object> getOrderDetails(int orderId) {
        String query = "SELECT o.*, u.name as customer_name, u.email as customer_email, " +
                "u.address as customer_address, u.contact as customer_contact " +
                "FROM `order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "WHERE o.Order_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("id", rs.getInt("Order_id"));
                    order.put("customerName", rs.getString("customer_name"));
                    order.put("customerEmail", rs.getString("customer_email"));
                    order.put("customerAddress", rs.getString("customer_address"));
                    order.put("customerContact", rs.getString("customer_contact"));
                    order.put("totalAmount", rs.getDouble("total_amount"));
                    order.put("status", rs.getString("Status"));
                    order.put("orderDate", rs.getTimestamp("Order_date"));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private OrderItem mapResultSetToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(rs.getInt("Order_Item_ID"));
        item.setOrderId(rs.getInt("Order_id"));
        item.setBookId(rs.getInt("Book_ID"));
        item.setQuantity(rs.getInt("Quantity"));
        item.setPrice(rs.getDouble("Price"));
        return item;
    }
}