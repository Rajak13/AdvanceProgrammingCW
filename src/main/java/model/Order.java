package model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int orderId;
    private Timestamp orderDate;
    private String status;
    private int userId;
    private List<OrderItem> items;

    public Order() {
    }

    public Order(int orderId, Timestamp orderDate, String status, int userId) {
        this.orderId = orderId;
        this.orderDate = orderDate;
        this.status = status;
        this.userId = userId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
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

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }

    @Override
    public String toString() {
        return "Order [orderId=" + orderId + ", orderDate=" + orderDate + ", status=" + status + ", userId=" + userId
                + "]";
    }
}