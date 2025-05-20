package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Payment;
import utils.DBUtil;

public class PaymentDAO {
    private static final String GET_PAYMENT = "SELECT * FROM payment WHERE Payment_ID = ?";
    private static final String GET_USER_PAYMENTS = "SELECT * FROM payment WHERE User_ID = ? ORDER BY date DESC";
    private static final String GET_ORDER_PAYMENT = "SELECT * FROM payment WHERE Order_ID = ?";
    private static final String CREATE_PAYMENT = "INSERT INTO payment (date, method, status, User_ID, Order_ID, amount) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PAYMENT_STATUS = "UPDATE payment SET status = ? WHERE Payment_ID = ?";

    public Payment getPayment(int paymentId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_PAYMENT)) {
            stmt.setInt(1, paymentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("Payment_ID"));
                    payment.setDate(rs.getTimestamp("date"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getString("status"));
                    payment.setUserId(rs.getInt("User_ID"));
                    payment.setOrderId(rs.getInt("Order_ID"));
                    payment.setAmount(rs.getDouble("amount"));
                    return payment;
                }
            }
        }
        return null;
    }

    public List<Payment> getUserPayments(int userId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_USER_PAYMENTS)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("Payment_ID"));
                    payment.setDate(rs.getTimestamp("date"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getString("status"));
                    payment.setUserId(rs.getInt("User_ID"));
                    payment.setOrderId(rs.getInt("Order_ID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payments.add(payment);
                }
            }
        }
        return payments;
    }

    public Payment getOrderPayment(int orderId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_ORDER_PAYMENT)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentId(rs.getInt("Payment_ID"));
                    payment.setDate(rs.getTimestamp("date"));
                    payment.setMethod(rs.getString("method"));
                    payment.setStatus(rs.getString("status"));
                    payment.setUserId(rs.getInt("User_ID"));
                    payment.setOrderId(rs.getInt("Order_ID"));
                    payment.setAmount(rs.getDouble("amount"));
                    return payment;
                }
            }
        }
        return null;
    }

    public int createPayment(Payment payment) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CREATE_PAYMENT, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setTimestamp(1, payment.getDate());
            stmt.setString(2, payment.getMethod());
            stmt.setString(3, payment.getStatus());
            stmt.setInt(4, payment.getUserId());
            stmt.setInt(5, payment.getOrderId());
            stmt.setDouble(6, payment.getAmount());
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updatePaymentStatus(int paymentId, String status) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_PAYMENT_STATUS)) {
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payment ORDER BY date DESC";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentId(rs.getInt("Payment_id"));
                payment.setOrderId(rs.getInt("Order_id"));
                payment.setUserId(rs.getInt("User_ID"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setMethod(rs.getString("method"));
                payment.setStatus(rs.getString("status"));
                payment.setDate(rs.getTimestamp("date"));
                payments.add(payment);
            }
        }
        return payments;
    }

    public boolean updatePayment(Payment payment) throws SQLException {
        String sql = "UPDATE payment SET status = ? WHERE Payment_id = ?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, payment.getStatus());
            stmt.setInt(2, payment.getPaymentId());
            return stmt.executeUpdate() > 0;
        }
    }
}