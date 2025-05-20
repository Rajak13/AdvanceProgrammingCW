# BookStore Web Application

A Java-based web application for an online bookstore built with JSP, Servlet, and MySQL/MariaDB.

This project provides a complete online platform for browsing, purchasing, and managing books, featuring user authentication, a shopping cart, order processing, and an administrative dashboard for efficient management of books, users, and orders.

## Features

- **User Authentication & Authorization:** Secure login and registration for users and administrators.
- **Book Catalog:** Browse and search for books with details, including cover images, authors, and descriptions.
- **Dynamic Book Pages:** Explore curated lists like Bestsellers, New Releases, and Deals.
- **Shopping Cart:** Add, update, and remove items from the cart.
- **Order Management:** Place orders and track their status.
- **Payment Processing:** Integrate various payment methods (currently simulated).
- **Admin Dashboard:** Comprehensive overview and management of books, users, orders, and suggestions.
- **User Profile Management:** Users can view and update their profile information.
- **Book Suggestions:** Users can suggest new books.
- **Responsive Design:** Adapts to various screen sizes for a seamless user experience.

## Technology Stack

- Java (JDK 8 or higher)
- JSP (JavaServer Pages)
- Servlets
- MySQL/MariaDB
- HTML5, CSS3, JavaScript
- JSTL (JSP Standard Tag Library)
- Apache Tomcat (or any Servlet container)

## Project Members and Contributions

Here's a breakdown of contributions by the team members:

*   **Abdul Razzaq Ansari (Leader):** Led the project development. Primarily responsible for the design and functionality of all administrative pages (Dashboard, Books, Orders, Suggestions, Profile), ensuring a comprehensive and user-friendly admin interface.
*   **Diamond Baruwal:** Developed and implemented the core shopping cart and order processing functionalities. Designed the user-facing pages related to the cart and orders, ensuring a smooth purchasing experience.
*   **Nishant Shakya:** Focused on the frontend design and implementation of the main book browsing sections. Created the Home page and category-specific pages (Bestsellers, Deals, New Releases), ensuring books are displayed dynamically based on their status.
*   **Krish Adhikari:** Developed the About Us page and played a key role in identifying and fixing errors across the application, with a particular focus on resolving issues within the administrative pages.
*   **Saurab Basnet:** Created the Contact Page and implemented the functionality for book suggestions, ensuring suggestions are successfully stored in the database. Also contributed to integrating the contact form with email functionality.

*(Other functionalities such as user registration/login flow, database connection utilities, error handling across the application, common header/sidebar components, basic styling and JavaScript interactions not specifically mentioned above were collaboratively developed and shared among the team members.)*

## Setup Instructions

### Prerequisites

*   Java Development Kit (JDK) 8 or higher
*   Apache Maven
*   MySQL or MariaDB database server
*   A Servlet Container like Apache Tomcat
*   An IDE such as Eclipse or IntelliJ IDEA

### Database Setup

1.  Ensure your MySQL or MariaDB server is running.
2.  Open a database client (like MySQL command-line client, DBeaver, or phpMyAdmin).
3.  Execute the SQL script located at `database/schema.sql` to create the `bookstore` database and all necessary tables:

    ```bash
    mysql -u your_username -p < database/schema.sql
    ```
    Replace `your_username` with your database username. You will be prompted to enter your password.
4.  Update the database connection properties in `src/main/resources/db.properties` with your database credentials and connection details.

### IDE Setup (Eclipse/IntelliJ IDEA)

1.  **Clone the Repository:**
    ```bash
    git clone <repository_url>
    cd BookStore
    ```
2.  **Import Project:**
    *   **Eclipse:** Go to `File > Import > Maven > Existing Maven Projects`, navigate to the cloned project directory, and click `Finish`.
    *   **IntelliJ IDEA:** Go to `File > Open`, navigate to the cloned project directory, and select the `pom.xml` file. Click `Open`.
3.  **Configure Server:**
    *   Add your Tomcat server to the IDE.
    *   Configure the project to deploy to your Tomcat server.
4.  **Build and Run:**
    *   Clean and build the project using Maven (usually `mvn clean install` or through the IDE's Maven integration).
    *   Deploy the project to your configured Tomcat server.
    *   Start the Tomcat server.

### Accessing the Application

Once the server is started and the application is deployed, you can access it through your web browser, typically at `http://localhost:8080/BookStore` (the exact URL might vary depending on your server configuration and project deployment name).

## License

Private - All rights reserved. 