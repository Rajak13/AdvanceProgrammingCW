-- Create user table if not exists
CREATE TABLE IF NOT EXISTS user (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact VARCHAR(20),
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    picture VARCHAR(255),
    role VARCHAR(20) DEFAULT 'USER'
);

-- Create book table if not exists
CREATE TABLE IF NOT EXISTS book (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Book_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    writer_name VARCHAR(100),
    picture VARCHAR(255),
    status VARCHAR(20) DEFAULT 'New',
    stock INT DEFAULT 0,
    description TEXT
);

-- Create cart table if not exists
CREATE TABLE IF NOT EXISTS cart (
    Cart_id INT PRIMARY KEY AUTO_INCREMENT,
    quantity INT NOT NULL DEFAULT 1,
    User_ID INT,
    Book_ID INT,
    FOREIGN KEY (User_ID) REFERENCES user(User_ID),
    FOREIGN KEY (Book_ID) REFERENCES book(Book_ID)
);

-- Create order table if not exists
CREATE TABLE IF NOT EXISTS `order` (
    Order_id INT PRIMARY KEY AUTO_INCREMENT,
    Order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending','Processing','Shipped','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
    Shipping_address VARCHAR(255),
    Payment_method VARCHAR(50),
    Total_amount DECIMAL(10,2),
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES user(User_ID)
);

-- Create order_item table if not exists
CREATE TABLE IF NOT EXISTS order_item (
    Order_Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_id INT,
    Quantity INT NOT NULL DEFAULT 1,
    Price DECIMAL(10,2) NOT NULL,
    Book_ID INT,
    FOREIGN KEY (Order_id) REFERENCES `order`(Order_id),
    FOREIGN KEY (Book_ID) REFERENCES book(Book_ID)
);

-- Create category table if not exists
CREATE TABLE IF NOT EXISTS category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create book_category table if not exists
CREATE TABLE IF NOT EXISTS book_category (
    Book_ID INT NOT NULL,
    Category_ID INT NOT NULL,
    PRIMARY KEY (Book_ID, Category_ID),
    FOREIGN KEY (Book_ID) REFERENCES book(Book_ID),
    FOREIGN KEY (Category_ID) REFERENCES category(Category_ID)
);

-- Create payment table if not exists
CREATE TABLE IF NOT EXISTS payment (
    Payment_id INT PRIMARY KEY AUTO_INCREMENT,
    Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Method ENUM('Credit Card','Debit Card','PayPal','Cash on Delivery') NOT NULL,
    status ENUM('Pending','Completed','Failed','Refunded') NOT NULL DEFAULT 'Pending',
    User_ID INT,
    Order_ID INT,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES user(User_ID),
    FOREIGN KEY (Order_ID) REFERENCES `order`(Order_id)
);

-- Create suggestionbooks table if not exists
CREATE TABLE IF NOT EXISTS suggestionbooks (
    Suggestion_ID INT PRIMARY KEY AUTO_INCREMENT,
    Suggested_book VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    writer VARCHAR(100),
    description TEXT,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES user(User_ID)
); 