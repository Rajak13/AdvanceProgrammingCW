package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Model class representing an Order in the bookstore system.
 */
public class Order {
    private int id;
    private int userId;
    private User user;
    private double totalAmount;
    private String shippingAddress;
    private String paymentMethod;
    private String status;
    private Timestamp orderDate;
    private Timestamp updatedAt;
    private List<OrderItem> orderItems;

    // Default constructor
    public Order() {
        this.orderItems = new ArrayList<>();
    }

    // Constructor with parameters
    public Order(int id, int userId, double totalAmount, String shippingAddress,
            String paymentMethod, String status, Timestamp orderDate, Timestamp updatedAt) {
        this.id = id;
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
        this.updatedAt = updatedAt;
        this.orderItems = new ArrayList<>();
    }

    // Constructor with user object
    public Order(int id, User user, double totalAmount, String shippingAddress,
            String paymentMethod, String status, Timestamp orderDate, Timestamp updatedAt) {
        this.id = id;
        this.user = user;
        if (user != null) {
            this.userId = user.getUserId();
        }
        this.totalAmount = totalAmount;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
        this.updatedAt = updatedAt;
        this.orderItems = new ArrayList<>();
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getUserId();
        }
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date date) {
        this.orderDate = (Timestamp) date;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    public void addOrderItem(OrderItem item) {
        this.orderItems.add(item);
    }

    public int getItemCount() {
        int count = 0;
        for (OrderItem item : orderItems) {
            count += item.getQuantity();
        }
        return count;
    }

    public double calculateTotal() {
        double total = 0;
        for (OrderItem item : orderItems) {
            total += item.getSubtotal();
        }
        return total;
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", userId=" + userId +
                ", totalAmount=" + totalAmount +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", status='" + status + '\'' +
                ", orderDate=" + orderDate +
                ", updatedAt=" + updatedAt +
                ", itemCount=" + getItemCount() +
                '}';
    }
}