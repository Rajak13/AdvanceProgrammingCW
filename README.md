# BookStore Web Application

A Java-based web application for an online bookstore built with JSP, Servlet, and MySQL/MariaDB.

## Features

- User authentication and authorization
- Book browsing and searching
- Shopping cart functionality
- Order management
- Payment processing
- Admin dashboard for inventory management

## Technology Stack

- Java
- JSP (JavaServer Pages)
- Servlets
- MySQL/MariaDB
- HTML5
- CSS3
- JavaScript
- Bootstrap

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── bookstore/
│   │           ├── controller/
│   │           ├── dao/
│   │           ├── model/
│   │           └── util/
│   ├── resources/
│   └── webapp/
│       ├── WEB-INF/
│       ├── css/
│       ├── js/
│       └── views/
└── test/
```

## Setup Instructions

1. Clone the repository
2. Import the project into Eclipse/IDE
3. Configure your database connection in `src/main/resources/db.properties`
4. Build and deploy the project to your servlet container (e.g., Tomcat)

## Database Schema

The application uses the following main tables:
- users
- books
- orders
- order_items
- cart
- payments

## Contributing

This is a private repository. Please contact the repository owner for contribution guidelines.

## License

Private - All rights reserved 