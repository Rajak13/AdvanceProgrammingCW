package model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int quantity;
    private double price;
    private int bookId;
    private String bookName;
    private String picture;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int quantity, double price, int bookId) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.quantity = quantity;
        this.price = price;
        this.bookId = bookId;
    }

    // Getters and setters for database fields
    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    // Additional getters and setters for display purposes
    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public double getSubtotal() {
        return price * quantity;
    }

    @Override
    public String toString() {
        return "OrderItem [orderItemId=" + orderItemId + ", orderId=" + orderId + ", quantity=" + quantity + ", price="
                + price + ", bookId=" + bookId + ", bookName=" + bookName + ", picture=" + picture + "]";
    }
}