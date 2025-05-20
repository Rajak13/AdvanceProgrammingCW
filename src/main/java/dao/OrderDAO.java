package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Order;
import model.OrderItem;
import model.User;
import utils.DBUtil;

/**
 * Data Access Object for Order-related database operations
 */
public class OrderDAO {

    private Connection conn;

    public OrderDAO() throws SQLException {
        this.conn = DBUtil.getConnection();
    }

    public OrderDAO(Connection conn) {
        this.conn = conn;
    }

    private static final String GET_ORDER = "SELECT * FROM `order` WHERE Order_ID = ?";
    private static final String GET_USER_ORDERS = "SELECT * FROM `order` WHERE User_ID = ? ORDER BY Order_date DESC";
    private static final String GET_ALL_ORDERS = "SELECT * FROM `order` ORDER BY Order_date DESC";
    private static final String CREATE_ORDER = "INSERT INTO `order` (User_ID, Order_date, Total_amount, Status, Shipping_address, Payment_method) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ORDER_STATUS = "UPDATE `order` SET Status = ? WHERE Order_ID = ?";

    public Order getOrder(int orderId) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(GET_ORDER)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("Order_ID"));
                    order.setUserId(rs.getInt("User_ID"));
                    order.setOrderDate(rs.getTimestamp("Order_date"));
                    order.setTotalAmount(rs.getDouble("Total_amount"));
                    order.setStatus(rs.getString("Status"));
                    order.setShippingAddress(rs.getString("Shipping_address"));
                    order.setPaymentMethod(rs.getString("Payment_method"));
                    return order;
                }
            }
        }
        return null;
    }

    public List<Order> getUserOrders(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement(GET_USER_ORDERS)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("Order_ID"));
                    order.setUserId(rs.getInt("User_ID"));
                    order.setOrderDate(rs.getTimestamp("Order_date"));
                    order.setTotalAmount(rs.getDouble("Total_amount"));
                    order.setStatus(rs.getString("Status"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.* FROM `order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "ORDER BY o.Order_date DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("Order_ID"));
                order.setUserId(rs.getInt("User_ID"));
                order.setOrderDate(rs.getTimestamp("Order_date"));
                order.setTotalAmount(rs.getDouble("Total_amount"));
                order.setStatus(rs.getString("Status"));
                order.setShippingAddress(rs.getString("Shipping_address"));
                order.setPaymentMethod(rs.getString("Payment_method"));

                // Set User object
                User user = new User();
                user.setUserId(rs.getInt("User_ID"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setContact(rs.getString("contact"));
                user.setPicture(rs.getString("picture"));
                user.setRole(rs.getString("role"));
                order.setUser(user);

                // Get order items
                OrderItemDAO orderItemDAO = new OrderItemDAO();
                List<OrderItem> orderItems = orderItemDAO.getOrderItems(order.getOrderId());
                order.setOrderItems(orderItems);

                orders.add(order);
            }
        }
        return orders;
    }

    public int createOrder(Order order) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(CREATE_ORDER, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setTimestamp(2, order.getOrderDate());
            stmt.setDouble(3, order.getTotalAmount());
            stmt.setString(4, order.getStatus());
            stmt.setString(5, order.getShippingAddress());
            stmt.setString(6, order.getPaymentMethod());

            if (stmt.executeUpdate() > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
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

    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(Total_amount) as total FROM `order`";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total");
            }
        }
        return 0.0;
    }

    /**
     * Get all orders with pagination
     */
    public List<Map<String, Object>> getAllOrders(int offset, int limit) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String query = "SELECT o.*, u.Name as customer_name, u.Email as customer_email, p.status as payment_status " +
                "FROM `order` o " +
                "JOIN User u ON o.User_ID = u.User_ID " +
                "LEFT JOIN payment p ON o.Order_id = p.order_id " +
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
                    order.put("status", rs.getString("Status"));
                    order.put("orderDate", rs.getTimestamp("Order_date"));
                    order.put("shippingAddress", rs.getString("Shipping_address"));
                    order.put("paymentMethod", rs.getString("Payment_method"));
                    order.put("totalAmount", rs.getDouble("Total_amount"));
                    order.put("paymentStatus", rs.getString("payment_status"));
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
        String query = "SELECT o.*, u.Name as customer_name, u.Email as customer_email, " +
                "u.Address as customer_address, u.Contact as customer_contact " +
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
                    order.put("status", rs.getString("Status"));
                    order.put("orderDate", rs.getTimestamp("Order_date"));
                    order.put("shippingAddress", rs.getString("Shipping_address"));
                    order.put("paymentMethod", rs.getString("Payment_method"));
                    order.put("totalAmount", rs.getDouble("Total_amount"));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteOrder(int orderId) {
        // Delete order items first due to FK constraint
        String deleteItemsSql = "DELETE FROM order_item WHERE Order_id = ?";
        String deleteOrderSql = "DELETE FROM `order` WHERE Order_id = ?";
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement psItems = conn.prepareStatement(deleteItemsSql)) {
                psItems.setInt(1, orderId);
                psItems.executeUpdate();
            }
            try (PreparedStatement psOrder = conn.prepareStatement(deleteOrderSql)) {
                psOrder.setInt(1, orderId);
                int affected = psOrder.executeUpdate();
                return affected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getRevenueThisMonth() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Total_amount), 0) FROM `order` ";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public double getLastMonthRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Total_amount), 0) FROM `order` " +
                "WHERE status != 'Cancelled'";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public List<Order> getRecentOrders(int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name as customer_name, u.email as customer_email " +
                "FROM `order` o " +
                "JOIN user u ON o.user_id = u.user_id " +
                "ORDER BY o.Order_date DESC " +
                "LIMIT ?";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("Order_ID"));
                order.setOrderDate(rs.getTimestamp("Order_date"));
                order.setTotalAmount(rs.getDouble("Total_amount"));
                order.setStatus(rs.getString("status"));

                User user = new User();
                user.setName(rs.getString("customer_name"));
                user.setEmail(rs.getString("customer_email"));
                order.setUser(user);

                orders.add(order);
            }
        }
        return orders;
    }

    public List<Double> getMonthlyRevenue() throws SQLException {
        List<Double> monthlyRevenue = new ArrayList<>();
        String sql = "SELECT COALESCE(SUM(Total_amount), 0) as revenue " +
                "FROM `order` ";

        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                monthlyRevenue.add(rs.getDouble("revenue"));
            }
        }
        return monthlyRevenue;
    }
}