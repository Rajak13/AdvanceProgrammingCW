package model;

public class Cart {
    private int cartId;
    private int quantity;
    private int userId;
    private int bookId;

    public Cart() {
        this.quantity = 1;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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