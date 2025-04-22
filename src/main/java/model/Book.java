package model;

public class Book {
    private int bookId;
    private String bookName;
    private double price;
    private String writerName;
    private String picture;

    // Default constructor
    public Book() {
    }

    // Constructor with essential fields
    public Book(String bookName, double price, String writerName) {
        this.bookName = bookName;
        this.price = price;
        this.writerName = writerName;
    }

    // Full constructor
    public Book(int bookId, String bookName, double price, String writerName, String picture) {
        this.bookId = bookId;
        this.bookName = bookName;
        this.price = price;
        this.writerName = writerName;
        this.picture = picture;
    }

    // Getters and setters
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

    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", bookName='" + bookName + '\'' +
                ", price=" + price +
                ", writerName='" + writerName + '\'' +
                '}';
    }

	public void setUserId(int i) {
		// TODO Auto-generated method stub
		
	}
}