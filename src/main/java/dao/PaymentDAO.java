package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Payment;

public class PaymentDAO {
    private Connection connection;

    public PaymentDAO(Connection connection) {
        this.connection = connection;
    }

    // Get a payment by its ID
    public Payment getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT * FROM payment WHERE Payment_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }
        return null;
    }

    // Get all payments
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payment ORDER BY Date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        }
        return payments;
    }

    // Create a new payment
    public boolean createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payment (User_ID, Order_ID, Method, status, amount) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, payment.getUserId());
            stmt.setInt(2, payment.getOrderId());
            stmt.setString(3, payment.getMethod());
            stmt.setString(4, payment.getStatus());
            stmt.setDouble(5, payment.getAmount());
            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        payment.setPaymentId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        }
    }

    // Update a payment
    public boolean updatePaymentStatus(int paymentId, String status) throws SQLException {
        String sql = "UPDATE payment SET status = ? WHERE Payment_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Get payments by user ID
    public List<Payment> getPaymentsByUserId(int userId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payment WHERE User_ID = ? ORDER BY Date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        }
        return payments;
    }

    // Get payments by order ID
    public List<Payment> getPaymentsByOrderId(int orderId) throws SQLException {
        List<Payment> payments = new ArrayList<>();

        String sql = "SELECT * FROM payment WHERE Order_ID = ? ORDER BY Date DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderId);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
        }

        return payments;
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("Payment_id"));
        payment.setUserId(rs.getInt("User_ID"));
        payment.setOrderId(rs.getInt("Order_ID"));
        payment.setDate(rs.getTimestamp("Date"));
        payment.setMethod(rs.getString("Method"));
        payment.setStatus(rs.getString("status"));
        payment.setAmount(rs.getDouble("amount"));
        return payment;
    }
}