package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int cartId;
    private int userId;
    private int bookId;
    private int quantity;
    private Timestamp createdAt;
    private Book book; // For display purposes
    private List<OrderItem> cartItems;

    public Cart() {
        this.cartItems = new ArrayList<>();
    }

    public Cart(int userId, int bookId, int quantity) {
        this.userId = userId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.cartItems = new ArrayList<>();
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public List<OrderItem> getCartItems() {
        return cartItems;
    }

    public void setCartItems(List<OrderItem> cartItems) {
        this.cartItems = cartItems;
    }

    @Override
    public String toString() {
        return "Cart{" +
                "cartId=" + cartId +
                ", quantity=" + quantity +
                ", userId=" + userId +
                ", bookId=" + bookId +
                '}';
    }
}