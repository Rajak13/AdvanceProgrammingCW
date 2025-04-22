package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.Book;
import model.Order;
import model.OrderItem;
import model.User;
import utils.DBUtil;

/**
 * Data Access Object for Order-related database operations
 */
public class OrderDAO {

    /**
     * Create a new order in the database
     */
    public int createOrder(Order order) throws SQLException {
        int orderId = 0;

        try (Connection conn = DBUtil.getConnection()) {
            // Set auto-commit to false for transaction
            conn.setAutoCommit(false);

            try {
                // Insert the order
                String sql = "INSERT INTO `Order` (User_ID, Order_date, Status, shipping_address, payment_method) " +
                        "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    pstmt.setInt(1, order.getUserId());

                    // Use current timestamp if not provided
                    if (order.getOrderDate() == null) {
                        pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                    } else {
                        pstmt.setTimestamp(2, order.getOrderDate());
                    }

                    pstmt.setString(3, order.getStatus());
                    pstmt.setString(4, order.getShippingAddress());
                    pstmt.setString(5, order.getPaymentMethod());

                    pstmt.executeUpdate();

                    // Get the generated order ID
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            orderId = rs.getInt(1);
                            order.setId(orderId);

                            // Insert order items
                            insertOrderItems(conn, order.getOrderItems(), orderId);

                            // Update total amount (can be calculated or provided)
                            updateOrderTotal(conn, orderId, order.getTotalAmount());
                        }
                    }
                }

                // Commit transaction
                conn.commit();

            } catch (SQLException e) {
                // Rollback transaction on error
                conn.rollback();
                throw e;
            } finally {
                // Restore auto-commit
                conn.setAutoCommit(true);
            }
        }

        return orderId;
    }

    /**
     * Insert order items for an order
     */
    private void insertOrderItems(Connection conn, List<OrderItem> items, int orderId) throws SQLException {
        if (items == null || items.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO Order_Item (Order_id, Book_ID, Quantity, Price) VALUES (?, ?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            for (OrderItem item : items) {
                pstmt.setInt(1, orderId);
                pstmt.setInt(2, item.getBookId());
                pstmt.setInt(3, item.getQuantity());
                pstmt.setDouble(4, item.getPricePerUnit());
                pstmt.addBatch();

                item.setOrderId(orderId);
            }

            pstmt.executeBatch();

            // Get generated IDs
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                int i = 0;
                while (rs.next() && i < items.size()) {
                    items.get(i).setId(rs.getInt(1));
                    i++;
                }
            }
        }
    }

    /**
     * Update the total amount for an order
     */
    private void updateOrderTotal(Connection conn, int orderId, double totalAmount) throws SQLException {
        String sql = "UPDATE `Order` SET totalAmount = ? WHERE Order_id = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDouble(1, totalAmount);
            pstmt.setInt(2, orderId);
            pstmt.executeUpdate();
        }
    }

    /**
     * Get an order by ID with all details
     */
    public Order getOrderById(int orderId) throws SQLException {
        Order order = null;

        // Join with User table to get customer information
        String sql = "SELECT o.*, u.* FROM `Order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "WHERE o.Order_id = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    order = mapResultSetToOrder(rs);

                    // Get order items
                    order.setOrderItems(getOrderItems(orderId));
                }
            }
        }

        return order;
    }

    /**
     * Get all order items for an order
     */
    private List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();

        // Join with Book table to get book information
        String sql = "SELECT oi.*, b.* FROM Order_Item oi " +
                "JOIN Book b ON oi.Book_ID = b.Book_ID " +
                "WHERE oi.Order_id = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, orderId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("oi.id"));
                    item.setOrderId(rs.getInt("oi.Order_id"));
                    item.setBookId(rs.getInt("oi.Book_ID"));
                    item.setQuantity(rs.getInt("oi.Quantity"));
                    item.setPricePerUnit(rs.getDouble("oi.Price"));

                    // Set book
                    Book book = new Book();
                    book.setBookId(rs.getInt("b.Book_ID"));
                    book.setBookName(rs.getString("b.Book_name"));
                    book.setWriterName(rs.getString("b.writer_name"));
                    book.setPrice(rs.getDouble("b.price"));
                    book.setPicture(rs.getString("b.picture"));

                    item.setBook(book);

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
                "SELECT o.*, u.* FROM `Order` o " +
                        "JOIN User u ON o.User_ID = u.User_ID");

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
                    int itemCount = getOrderItemCount(order.getId());
                    order.setOrderItems(new ArrayList<>()); // Empty list with correct size

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
        String sql = "SELECT SUM(Quantity) FROM Order_Item WHERE Order_id = ?";

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
                "SELECT COUNT(*) FROM `Order` o JOIN User u ON o.User_ID = u.User_ID");

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
    public boolean updateOrderStatus(int orderId, String status, String trackingNumber, String notes)
            throws SQLException {
        String sql = "UPDATE `Order` SET Status = ?, tracking_number = ?, notes = ?, updated_at = NOW() WHERE Order_id = ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, trackingNumber);
            pstmt.setString(3, notes);
            pstmt.setInt(4, orderId);

            int updated = pstmt.executeUpdate();
            return updated > 0;
        }
    }

    /**
     * Get orders for a specific user
     */
    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT o.*, u.* FROM `Order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "WHERE o.User_ID = ? " +
                "ORDER BY o.Order_date DESC";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);

                    // Get order items (we'll load items for user orders)
                    order.setOrderItems(getOrderItems(order.getId()));

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
        order.setId(rs.getInt("o.Order_id"));
        order.setUserId(rs.getInt("o.User_ID"));
        order.setTotalAmount(rs.getDouble("o.totalAmount"));
        order.setStatus(rs.getString("o.Status"));
        order.setShippingAddress(rs.getString("o.shipping_address"));
        order.setPaymentMethod(rs.getString("o.payment_method"));
        order.setOrderDate(rs.getTimestamp("o.Order_date"));
        order.setUpdatedAt(rs.getTimestamp("o.updated_at"));

        // Set user
        User user = new User();
        user.setUserId(rs.getInt("u.User_ID"));
        user.setName(rs.getString("u.name"));
        user.setEmail(rs.getString("u.email"));
        user.setContact(rs.getString("u.contact"));
        user.setAddress(rs.getString("u.address"));
        user.setPicture(rs.getString("u.picture"));

        order.setUser(user);

        return order;
    }
}