package model;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private Timestamp date;
    private String method; // Credit Card, Debit Card, PayPal, Cash on Delivery
    private String status; // Pending, Completed, Failed, Refunded
    private int userId;
    private int orderId;
    private double amount;

    public Payment() {
    }

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", date=" + date +
                ", method='" + method + '\'' +
                ", status='" + status + '\'' +
                ", userId=" + userId +
                ", orderId=" + orderId +
                ", amount=" + amount +
                '}';
    }
}