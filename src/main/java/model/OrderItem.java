package model;

/**
 * Model class representing an Order Item in the bookstore system.
 */
public class OrderItem {
    private int id;
    private int orderId;
    private int bookId;
    private Book book; // Associated book object
    private int quantity;
    private double pricePerUnit;

    // Default constructor
    public OrderItem() {
    }

    // Constructor with parameters
    public OrderItem(int id, int orderId, int bookId, int quantity, double pricePerUnit) {
        this.id = id;
        this.orderId = orderId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
    }

    // Constructor with book object
    public OrderItem(int id, int orderId, Book book, int quantity, double pricePerUnit) {
        this.id = id;
        this.orderId = orderId;
        this.book = book;
        if (book != null) {
            this.bookId = book.getBookId();
        }
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
        if (book != null) {
            this.bookId = book.getBookId();
        }
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(double pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public double getSubtotal() {
        return quantity * pricePerUnit;
    }

    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", bookId=" + bookId +
                ", quantity=" + quantity +
                ", pricePerUnit=" + pricePerUnit +
                ", subtotal=" + getSubtotal() +
                '}';
    }
}