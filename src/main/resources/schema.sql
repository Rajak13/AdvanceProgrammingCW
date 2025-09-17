CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- Table: user
CREATE TABLE `user` (
    User_ID INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact VARCHAR(20),
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    picture VARCHAR(255),
    role VARCHAR(20) DEFAULT 'USER',
    PRIMARY KEY (User_ID)
);

-- Table: book
CREATE TABLE `book` (
    Book_ID INT(11) NOT NULL AUTO_INCREMENT,
    Book_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    writer_name VARCHAR(100),
    picture VARCHAR(255),
    status VARCHAR(20) DEFAULT 'New',
    stock INT(11) DEFAULT 0,
    description TEXT,
    PRIMARY KEY (Book_ID)
);

-- Table: category
CREATE TABLE `category` (
    Category_ID INT(11) NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    PRIMARY KEY (Category_ID),
    UNIQUE KEY category_name (category_name)
);

-- Table: book_category
CREATE TABLE `book_category` (
    Book_ID INT(11) NOT NULL,
    Category_ID INT(11) NOT NULL,
    PRIMARY KEY (Book_ID, Category_ID),
    FOREIGN KEY (Book_ID) REFERENCES `book`(Book_ID) ON DELETE CASCADE,
    FOREIGN KEY (Category_ID) REFERENCES `category`(Category_ID) ON DELETE CASCADE
);

-- Table: cart
CREATE TABLE `cart` (
    Cart_id INT(11) NOT NULL AUTO_INCREMENT,
    quantity INT(11) NOT NULL DEFAULT 1,
    User_ID INT(11),
    Book_ID INT(11),
    PRIMARY KEY (Cart_id),
    FOREIGN KEY (User_ID) REFERENCES `user`(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES `book`(Book_ID) ON DELETE CASCADE
);

-- Table: order
CREATE TABLE `order` (
    Order_id INT(11) NOT NULL AUTO_INCREMENT,
    Order_date DATETIME NOT NULL DEFAULT current_timestamp(),
    Status ENUM('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    Shipping_address VARCHAR(255),
    Payment_method VARCHAR(50),
    Total_amount DECIMAL(10,2),
    User_ID INT(11),
    PRIMARY KEY (Order_id),
    FOREIGN KEY (User_ID) REFERENCES `user`(User_ID) ON DELETE SET NULL
);

-- Table: order_item
CREATE TABLE `order_item` (
    Order_Item_ID INT(11) NOT NULL AUTO_INCREMENT,
    Order_id INT(11),
    Quantity INT(11) NOT NULL DEFAULT 1,
    Price DECIMAL(10,2) NOT NULL,
    Book_ID INT(11),
    PRIMARY KEY (Order_Item_ID),
    FOREIGN KEY (Order_id) REFERENCES `order`(Order_id) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES `book`(Book_ID) ON DELETE SET NULL
);

-- Table: payment
CREATE TABLE `payment` (
    Payment_id INT(11) NOT NULL AUTO_INCREMENT,
    Date DATETIME NOT NULL DEFAULT current_timestamp(),
    Method ENUM('Credit Card','Debit Card','PayPal','Cash on Delivery') NOT NULL,
    status ENUM('Pending','Completed','Failed','Refunded') NOT NULL DEFAULT 'Pending',
    User_ID INT(11),
    Order_ID INT(11),
    amount DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (Payment_id),
    FOREIGN KEY (User_ID) REFERENCES `user`(User_ID) ON DELETE SET NULL,
    FOREIGN KEY (Order_ID) REFERENCES `order`(Order_id) ON DELETE CASCADE
);

-- Table: suggestionbooks
CREATE TABLE `suggestionbooks` (
    Suggestion_ID INT(11) NOT NULL AUTO_INCREMENT,
    Suggested_book VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    writer VARCHAR(100),
    description TEXT,
    date DATETIME NOT NULL DEFAULT current_timestamp(),
    User_ID INT(11),
    status ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    PRIMARY KEY (Suggestion_ID),
    FOREIGN KEY (User_ID) REFERENCES `user`(User_ID) ON DELETE SET NULL
); 