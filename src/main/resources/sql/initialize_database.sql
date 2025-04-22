-- Database Initialization Script for BookStore
-- Drop tables if they exist to ensure clean setup
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS book_categories;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    status ENUM('ACTIVE', 'INACTIVE', 'BANNED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon_class VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create books table
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    publisher VARCHAR(100),
    publication_date DATE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0,
    cover_image VARCHAR(255),
    stock_quantity INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    is_bestseller BOOLEAN DEFAULT FALSE,
    units_sold INT DEFAULT 0,
    rating_avg DECIMAL(3, 2) DEFAULT 0,
    rating_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create book_categories join table
CREATE TABLE book_categories (
    book_id INT,
    category_id INT,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- Create reviews table
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create wishlist table
CREATE TABLE wishlist (
    user_id INT,
    book_id INT,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, book_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Create cart_items table
CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Create order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE SET NULL
);

-- Insert sample data for users
INSERT INTO users (first_name, last_name, email, password, phone, role, status) VALUES
('Admin', 'User', 'admin@bookstore.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '123-456-7890', 'ADMIN', 'ACTIVE'),
('John', 'Doe', 'john.doe@example.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '555-123-4567', 'USER', 'ACTIVE'),
('Alice', 'Smith', 'alice.smith@example.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '555-987-6543', 'USER', 'ACTIVE'),
('Robert', 'Johnson', 'robert.j@example.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '555-456-7890', 'USER', 'ACTIVE'),
('Michelle', 'Williams', 'michelle.w@example.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '555-789-0123', 'USER', 'ACTIVE'),
('David', 'Brown', 'david.brown@example.com', '$2a$10$8K1p/a7OyTSPSKoTnSbxkeSBBKLUFAc1ywiQKn46wxj4hCLMa4ps2', '555-234-5678', 'USER', 'ACTIVE');

-- Insert sample data for categories
INSERT INTO categories (name, description, icon_class, is_active) VALUES
('Fiction', 'Novels and short stories not based on real events', 'fas fa-book', TRUE),
('Non-Fiction', 'Books based on facts and real events', 'fas fa-book-open', TRUE),
('Science', 'Books about scientific principles and discoveries', 'fas fa-flask', TRUE),
('History', 'Books about past events and historical figures', 'fas fa-landmark', TRUE),
('Romance', 'Books centered around love stories', 'fas fa-heart', TRUE),
('Mystery', 'Books with suspense and puzzle-solving elements', 'fas fa-search', TRUE),
('Biography', 'Books about real people\'s lives', 'fas fa-user', TRUE);

-- Insert sample data for books
INSERT INTO books (title, author, isbn, publisher, publication_date, description, price, discount_percent, cover_image, stock_quantity, is_featured, is_bestseller, units_sold) VALUES
('The Art of Programming', 'John Smith', '9780123456789', 'Tech Publications', '2021-05-15', 'A comprehensive guide to programming principles and practices.', 29.99, 10.00, '/images/books/book1.jpg', 50, TRUE, TRUE, 120),
('Data Structures and Algorithms', 'Emily Johnson', '9781234567890', 'Code Publishing', '2020-08-22', 'An in-depth look at fundamental data structures and algorithms.', 35.50, 0.00, '/images/books/book2.jpg', 30, TRUE, FALSE, 95),
('Machine Learning Basics', 'Michael Brown', '9782345678901', 'AI Press', '2022-01-10', 'Introduction to machine learning concepts and applications.', 24.95, 15.00, '/images/books/book3.jpg', 25, FALSE, TRUE, 85),
('Web Development with Java', 'Sarah Wilson', '9783456789012', 'Dev Books', '2021-12-05', 'A guide to building web applications using Java.', 32.00, 5.00, '/images/books/book4.jpg', 20, TRUE, FALSE, 70),
('Database Design Patterns', 'David Lee', '9784567890123', 'Tech Solutions', '2022-03-20', 'Best practices and patterns for database design and implementation.', 27.75, 0.00, '/images/books/book5.jpg', 15, FALSE, FALSE, 65),
('The Last Summer', 'Jessica Parker', '9785678901234', 'Sunset Publishing', '2022-06-15', 'A touching novel about friendship and growing up.', 18.99, 0.00, '/images/books/book6.jpg', 40, TRUE, TRUE, 150),
('Mystery at Midnight', 'Thomas Wright', '9786789012345', 'Thriller Books', '2021-10-31', 'A gripping murder mystery set in a small town.', 21.50, 10.00, '/images/books/book7.jpg', 35, TRUE, TRUE, 130),
('Historical Journeys', 'Laura Martin', '9787890123456', 'History House', '2021-07-08', 'Exploring pivotal moments in world history.', 26.25, 5.00, '/images/books/book8.jpg', 25, FALSE, FALSE, 75),
('Love in Paris', 'Robert James', '9788901234567', 'Romance Publishers', '2022-02-14', 'A heartwarming love story set in the city of lights.', 19.95, 0.00, '/images/books/book9.jpg', 30, TRUE, FALSE, 90),
('The Science of Everything', 'Amanda Lewis', '9789012345678', 'Knowledge Press', '2022-04-22', 'Explaining complex scientific concepts in simple terms.', 28.50, 15.00, '/images/books/book10.jpg', 20, FALSE, TRUE, 110);

-- Associate books with categories
INSERT INTO book_categories (book_id, category_id) VALUES
(1, 2), -- The Art of Programming -> Non-Fiction
(1, 3), -- The Art of Programming -> Science
(2, 2), -- Data Structures and Algorithms -> Non-Fiction
(2, 3), -- Data Structures and Algorithms -> Science
(3, 2), -- Machine Learning Basics -> Non-Fiction
(3, 3), -- Machine Learning Basics -> Science
(4, 2), -- Web Development with Java -> Non-Fiction
(5, 2), -- Database Design Patterns -> Non-Fiction
(6, 1), -- The Last Summer -> Fiction
(7, 1), -- Mystery at Midnight -> Fiction
(7, 6), -- Mystery at Midnight -> Mystery
(8, 2), -- Historical Journeys -> Non-Fiction
(8, 4), -- Historical Journeys -> History
(9, 1), -- Love in Paris -> Fiction
(9, 5), -- Love in Paris -> Romance
(10, 2), -- The Science of Everything -> Non-Fiction
(10, 3); -- The Science of Everything -> Science

-- Insert sample reviews
INSERT INTO reviews (book_id, user_id, rating, comment) VALUES
(1, 2, 5, 'Excellent book for beginners and experienced programmers alike!'),
(1, 3, 4, 'Very comprehensive, though some sections could be more detailed.'),
(2, 4, 5, 'The best book on data structures I\'ve ever read.'),
(3, 2, 4, 'Great introduction to machine learning concepts.'),
(4, 5, 3, 'Good content but could use more examples.'),
(5, 3, 5, 'Extremely helpful for my database project.'),
(6, 4, 4, 'Couldn\'t put it down! Great summer read.'),
(7, 2, 5, 'Kept me guessing until the very end!'),
(8, 5, 4, 'Fascinating insights into historical events.'),
(9, 3, 5, 'Beautiful story that made me want to visit Paris.'),
(10, 4, 4, 'Complex science made accessible and interesting.');

-- Insert sample orders
INSERT INTO orders (user_id, total_amount, shipping_address, payment_method, status, order_date) VALUES
(2, 85.97, '123 Main St, Anytown, US 12345', 'CREDIT_CARD', 'DELIVERED', '2023-05-10 14:30:00'),
(3, 35.50, '456 Oak Ave, Somewhere, US 67890', 'PAYPAL', 'SHIPPED', '2023-05-15 09:45:00'),
(4, 52.95, '789 Pine Rd, Nowhere, US 10112', 'CREDIT_CARD', 'PROCESSING', '2023-05-20 16:20:00'),
(5, 19.95, '321 Elm St, Anyplace, US 13579', 'CREDIT_CARD', 'PENDING', '2023-05-25 11:10:00'),
(2, 74.25, '123 Main St, Anytown, US 12345', 'PAYPAL', 'DELIVERED', '2023-06-01 13:50:00');

-- Insert sample order items
INSERT INTO order_items (order_id, book_id, quantity, price_per_unit) VALUES
(1, 1, 1, 26.99), -- 10% discount on The Art of Programming
(1, 6, 1, 18.99), -- The Last Summer
(1, 9, 2, 19.99), -- Love in Paris
(2, 2, 1, 35.50), -- Data Structures and Algorithms
(3, 3, 1, 21.21), -- 15% discount on Machine Learning Basics
(3, 7, 1, 19.35), -- 10% discount on Mystery at Midnight
(3, 8, 0.5, 24.94), -- 5% discount on Historical Journeys
(4, 9, 1, 19.95), -- Love in Paris
(5, 4, 1, 30.40), -- 5% discount on Web Development with Java
(5, 5, 1, 27.75), -- Database Design Patterns
(5, 10, 0.5, 24.23); -- 15% discount on The Science of Everything

-- Insert sample wishlist items
INSERT INTO wishlist (user_id, book_id) VALUES
(2, 3),
(2, 5),
(3, 1),
(3, 7),
(4, 6),
(4, 10),
(5, 2),
(5, 8);

-- Insert sample cart items
INSERT INTO cart_items (user_id, book_id, quantity) VALUES
(2, 4, 1),
(2, 10, 1),
(3, 6, 1),
(4, 9, 2),
(5, 1, 1),
(5, 7, 1); 