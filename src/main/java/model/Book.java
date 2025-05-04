package model;

import java.util.ArrayList;
import java.util.List;

public class Book {
    private int bookId;
    private String bookName;
    private double price;
    private String writerName;
    private String picture;
    private String status; // New, Deal, Bestseller
    private int stock;
    private String description;
    private List<Category> categories;

    // Constructor
    public Book() {
        this.categories = new ArrayList<>();
    }

    public Book(int bookId, String bookName, double price, String writerName, String picture,
            String status, int stock, String description) {
        this.bookId = bookId;
        this.bookName = bookName;
        this.price = price;
        this.writerName = writerName;
        this.picture = picture;
        this.status = status;
        this.stock = stock;
        this.description = description;
        this.categories = new ArrayList<>();
    }

    // Getters and Setters
    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getWriterName() {
        return writerName;
    }

    public void setWriterName(String writerName) {
        this.writerName = writerName;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    public void addCategory(Category category) {
        this.categories.add(category);
    }

    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", bookName='" + bookName + '\'' +
                ", price=" + price +
                ", writerName='" + writerName + '\'' +
                ", picture='" + picture + '\'' +
                ", status='" + status + '\'' +
                ", stock=" + stock +
                ", description='" + description + '\'' +
                ", categories=" + categories +
                '}';
    }
}