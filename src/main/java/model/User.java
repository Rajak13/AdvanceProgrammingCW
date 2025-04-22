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

    // Default constructor
    public User() {
    }

    // Constructor with essential fields
    public User(String name, String email, String password) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = determineRole(email);
    }

    // Full constructor
    public User(int userId, String name, String address, String contact, String email, String password,
            String picture) {
        this.userId = userId;
        this.name = name;
        this.address = address;
        this.contact = contact;
        this.email = email;
        this.password = password;
        this.picture = picture;
        this.role = determineRole(email);
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
        // Update role when email changes
        this.role = determineRole(email);
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

    // Determine role based on email domain
    private String determineRole(String email) {
        if (email != null && email.endsWith("@panna.bs.com")) {
            return "ADMIN";
        }
        return "USER";
    }

    // Check if user is admin
    public boolean isAdmin() {
        return "ADMIN".equals(this.role);
    }

    // Helper methods for backwards compatibility with existing code
    public String getUsername() {
        return name;
    }

    public void setUsername(String username) {
        this.name = username;
    }

    public String getPasswordHash() {
        return password;
    }

    public void setPasswordHash(String passwordHash) {
        this.password = passwordHash;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}