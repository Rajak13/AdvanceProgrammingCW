package model;

public class User {
    private int userId;
    private String name;
    private String address;
    private String contact;
    private String email;
    private String password;
    private String picture;
    private String role;
    private boolean active = true;

    // Default constructor
    public User() {
        this.role = "USER";
    }

    // Constructor with essential fields
    public User(String name, String email, String password) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = "USER";
    }

    // Full constructor
    public User(int userId, String name, String address, String contact, String email, String password,
            String picture, String role) {
        this.userId = userId;
        this.name = name;
        this.address = address;
        this.contact = contact;
        this.email = email;
        this.password = password;
        this.picture = picture;
        this.role = role;
    }

    // Getters and setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    @Override
    public String toString() {
        return "User [userId=" + userId + ", name=" + name + ", email=" + email + ", role=" + role + "]";
    }
}