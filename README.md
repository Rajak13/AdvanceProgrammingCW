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

| S.N | Member Name | Member Tasks |
|-----|-------------|--------------|
| 1. | Abdul Razzaq Ansari (Leader) | • Created the repository and project structure<br>• Developed login/register UI and wireframe<br>• Implemented role-based authentication and authorization<br>• Developed admin dashboard UI and functionality<br>• Implemented CRUD operations for admin and user management<br>• Developed book management system (admin side)<br>• Implemented suggestion management system<br>• Created database schema and relationships<br>• Implemented error handling and validation<br>• Developed admin profile management |
| 2. | Diamond Baruwal | • Implemented session management and cookies<br>• Developed UI and wireframes for home page<br>• Developed shopping cart functionality<br>• Implemented order management system<br>• Developed payment processing system<br>• Created order tracking functionality<br>• Implemented user order history<br>• Developed cart persistence across sessions<br>• Created order status management<br>• Implemented order notifications |
| 3. | Krish Adhikari | • Developed UI and wireframe for about us page<br>• Implemented admin dashboard design<br>• Developed book search functionality<br>• Implemented book filtering system<br>• Created book category management<br>• Developed book status management (Bestseller, New Release, Deal)<br>• Implemented responsive design for all pages<br>• Created book image handling system<br>• Developed book recommendation system<br>• Implemented book rating system |
| 4. | Nishant Shakya | • Developed UI and wireframes for all product pages<br>• Implemented book creation functionality (admin)<br>• Developed user creation system (admin)<br>• Created book listing and pagination<br>• Implemented book details page<br>• Developed book image upload system<br>• Created book inventory management<br>• Implemented book price management<br>• Developed book category pages<br>• Created book status management UI |
| 5. | Saurab Basnet | • Developed wireframe for Contact Us page<br>• Implemented user profile management<br>• Developed user profile editing functionality<br>• Created book suggestion system<br>• Implemented contact form functionality<br>• Developed email notification system<br>• Created user feedback system<br>• Implemented password reset functionality<br>• Developed user account settings<br>• Created user activity logging |

### Additional Collaborative Efforts
The following functionalities were developed collaboratively by the team:
- Database connection utilities and connection pooling
- Common UI components (header, footer, navigation)
- Input validation and sanitization
- Security measures and best practices
- Documentation and code comments
- Testing and bug fixes
- Performance optimization
- Cross-browser compatibility
- Mobile responsiveness
- Accessibility features

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