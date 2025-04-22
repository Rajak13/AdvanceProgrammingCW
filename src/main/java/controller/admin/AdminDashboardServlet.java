package controller.admin;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Order;
import model.User;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // For demonstration purposes, we'll generate sample data for the dashboard

        // Generate statistics
        Map<String, Object> statistics = generateSampleStatistics();

        // Generate chart data
        Map<String, Object> salesChartData = generateSampleSalesData();
        Map<String, Object> categoriesChartData = generateSampleCategoriesData();

        // Generate sample recent orders
        List<Order> recentOrders = generateSampleRecentOrders();

        // Generate sample top selling books
        List<Book> topBooks = generateSampleTopBooks();

        // Generate sample recent users
        List<User> recentUsers = generateSampleRecentUsers();

        // Set attributes for the JSP
        request.setAttribute("statistics", statistics);
        request.setAttribute("salesChartData", salesChartData);
        request.setAttribute("categoriesChartData", categoriesChartData);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("topBooks", topBooks);
        request.setAttribute("recentUsers", recentUsers);

        // Forward to the dashboard JSP
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    private Map<String, Object> generateSampleStatistics() {
        Map<String, Object> stats = new HashMap<>();

        // Set sample statistics
        stats.put("totalUsers", 156);
        stats.put("totalBooks", 237);
        stats.put("totalRevenue", 12458.75);
        stats.put("totalOrders", 342);

        // Set growth percentages (can be positive or negative)
        stats.put("userGrowth", 12.5);
        stats.put("bookGrowth", 8.3);
        stats.put("revenueGrowth", 15.7);
        stats.put("orderGrowth", 10.2);

        return stats;
    }

    private Map<String, Object> generateSampleSalesData() {
        Map<String, Object> chartData = new HashMap<>();

        // Create sample labels for the last 6 months
        List<String> labels = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("MMM yyyy");
        Calendar cal = Calendar.getInstance();

        for (int i = 5; i >= 0; i--) {
            cal.add(Calendar.MONTH, -1);
            labels.add(sdf.format(cal.getTime()));
        }
        // Reverse to get chronological order
        List<String> chronologicalLabels = new ArrayList<>();
        for (int i = labels.size() - 1; i >= 0; i--) {
            chronologicalLabels.add(labels.get(i));
        }

        // Create sample data for sales
        List<Double> data = Arrays.asList(1850.25, 2100.75, 1950.50, 2450.00, 2275.25, 2800.50);

        chartData.put("labels", chronologicalLabels);
        chartData.put("data", data);

        return chartData;
    }

    private Map<String, Object> generateSampleCategoriesData() {
        Map<String, Object> chartData = new HashMap<>();

        // Create sample category labels
        List<String> labels = Arrays.asList("Fiction", "Non-Fiction", "Science", "History", "Romance", "Mystery",
                "Biography");

        // Create sample data for category distribution
        List<Integer> data = Arrays.asList(35, 25, 15, 10, 8, 5, 2);

        // Create sample colors for the chart
        List<String> backgroundColors = Arrays.asList(
                "#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", "#9966FF", "#FF9F40", "#C9CBCF");

        chartData.put("labels", labels);
        chartData.put("data", data);
        chartData.put("backgroundColors", backgroundColors);

        return chartData;
    }

    private List<Order> generateSampleRecentOrders() {
        List<Order> orders = new ArrayList<>();
        Random random = new Random();
        String[] statuses = { "PENDING", "PROCESSING", "SHIPPED", "DELIVERED" };

        // Generate 5 sample orders
        for (int i = 0; i < 5; i++) {
            Order order = new Order();
            order.setId(1000 + i);

            User user = new User();
            user.setUserId(100 + i);
            user.setName("Customer " + (i + 1));
            user.setEmail("customer" + (i + 1) + "@example.com");
            order.setUser(user);

            // Create a date within the last 10 days
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, -random.nextInt(10));
            Timestamp orderDate = new Timestamp(cal.getTimeInMillis());
            order.setOrderDate(orderDate);

            order.setTotalAmount(25.0 + random.nextInt(100));
            order.setStatus(statuses[random.nextInt(statuses.length)]);

            orders.add(order);
        }

        return orders;
    }

    private List<Book> generateSampleTopBooks() {
        List<Book> books = new ArrayList<>();

        // Sample book titles and authors
        String[][] bookData = {
                { "The Art of Programming", "John Smith", "29.99", "120" },
                { "Data Structures and Algorithms", "Emily Johnson", "35.50", "95" },
                { "Machine Learning Basics", "Michael Brown", "24.95", "85" },
                { "Web Development with Java", "Sarah Wilson", "32.00", "70" },
                { "Database Design Patterns", "David Lee", "27.75", "65" }
        };

        // Generate 5 sample books
        for (int i = 0; i < 5; i++) {
            Book book = new Book();
            book.setBookId(i + 1);
            book.setBookName(bookData[i][0]);
            book.setWriterName(bookData[i][1]);
            book.setPrice(Double.parseDouble(bookData[i][2]));
            // Note: Book class doesn't have setUnitsSold method
            book.setPicture("/images/books/book" + (i + 1) + ".jpg");

            books.add(book);
        }

        return books;
    }

    private List<User> generateSampleRecentUsers() {
        List<User> users = new ArrayList<>();
        Random random = new Random();

        // Sample user data
        String[][] userData = {
                { "John Doe", "john.doe@example.com" },
                { "Alice Smith", "alice.smith@example.com" },
                { "Robert Johnson", "robert.j@example.com" },
                { "Michelle Williams", "michelle.w@example.com" },
                { "David Brown", "david.brown@example.com" }
        };

        // Generate 5 sample users
        for (int i = 0; i < 5; i++) {
            User user = new User();
            user.setUserId(i + 1);
            user.setName(userData[i][0]);
            user.setEmail(userData[i][1]);

            // User class doesn't have createdAt field, so not setting it

            users.add(user);
        }

        return users;
    }
}