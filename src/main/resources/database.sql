-- Creating database schema
CREATE DATABASE IF NOT EXISTS bookstore;
USE bookstore;

-- Users table
CREATE TABLE IF NOT EXISTS User (
    User_ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    picture VARCHAR(255)
);

-- Books table
CREATE TABLE IF NOT EXISTS Book (
    Book_ID INT AUTO_INCREMENT PRIMARY KEY,
    Book_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    writer_name VARCHAR(100),
    picture VARCHAR(255)
);

-- Categories table
CREATE TABLE IF NOT EXISTS Category (
    Category_ID INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Book-Category relationship table
CREATE TABLE IF NOT EXISTS Book_Category (
    Book_ID INT,
    Category_ID INT,
    PRIMARY KEY (Book_ID, Category_ID),
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID) ON DELETE CASCADE,
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID) ON DELETE CASCADE
);

-- Cart table
CREATE TABLE IF NOT EXISTS Cart (
    Cart_id INT AUTO_INCREMENT PRIMARY KEY,
    quantity INT NOT NULL DEFAULT 1,
    User_ID INT,
    Book_ID INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID) ON DELETE CASCADE
);

-- Orders table
CREATE TABLE IF NOT EXISTS `Order` (
    Order_id INT AUTO_INCREMENT PRIMARY KEY,
    Order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') NOT NULL DEFAULT 'Pending',
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID) ON DELETE SET NULL
);

-- Order Items table
CREATE TABLE IF NOT EXISTS Order_Item (
    Order_Item_ID INT AUTO_INCREMENT PRIMARY KEY,
    Order_id INT,
    Quantity INT NOT NULL DEFAULT 1,
    Price DECIMAL(10,2) NOT NULL,
    Book_ID INT,
    FOREIGN KEY (Order_id) REFERENCES `Order`(Order_id) ON DELETE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Book(Book_ID) ON DELETE SET NULL
);

-- Payment table
CREATE TABLE IF NOT EXISTS Payment (
    Payment_id INT AUTO_INCREMENT PRIMARY KEY,
    Date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed', 'Refunded') NOT NULL DEFAULT 'Pending',
    User_ID INT,
    Order_ID INT,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID) ON DELETE SET NULL,
    FOREIGN KEY (Order_ID) REFERENCES `Order`(Order_id) ON DELETE CASCADE
);

-- Suggestion Books table
CREATE TABLE IF NOT EXISTS SuggestionBooks (
    Suggestion_ID INT AUTO_INCREMENT PRIMARY KEY,
    Suggested_book VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    writer VARCHAR(100),
    description TEXT,
    date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    User_ID INT,
    FOREIGN KEY (User_ID) REFERENCES User(User_ID) ON DELETE SET NULL
);

-- Insert some sample data
INSERT INTO Category (category_name, description) VALUES
('Fiction', 'Fictional books including novels, short stories and more'),
('Non-Fiction', 'Non-fictional books including biographies, history and science'),
('Science Fiction', 'Books about futuristic science, space travel, time travel, etc.'),
('Mystery', 'Books about crime, detective work and mystery'),
('Romance', 'Books focused on romantic relationships'),
('Textbooks', 'Educational books for school and college'),
('Children', 'Books for children and young readers'),
('Nepali Literature', 'Books written in Nepali language or about Nepal');

-- Creating indexes for better performance
CREATE INDEX idx_book_name ON Book(Book_name);
CREATE INDEX idx_category_name ON Category(category_name);
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_order_date ON `Order`(Order_date);
CREATE INDEX idx_payment_status ON Payment(status); 