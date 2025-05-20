package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.google.gson.Gson;

import dao.BookDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.SuggestionDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.Category;
import model.Order;
import model.Payment;
import model.SuggestionBook;
import model.User;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;
    private CategoryDAO categoryDAO;
    private SuggestionDAO suggestionDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        try {
            bookDAO = new BookDAO();
            orderDAO = new OrderDAO();
            userDAO = new UserDAO();
            categoryDAO = new CategoryDAO();
            paymentDAO = new PaymentDAO();
            suggestionDAO = new SuggestionDAO();
            gson = new Gson();
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/dashboard";
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // --- Book JSON for edit modal ---
        if ("/books".equals(action) && request.getParameter("bookId") != null) {
            try {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                Book book = bookDAO.getBook(bookId);
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(book));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid book ID\"}");
            }
            return;
        }

        try {
            switch (action) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/books":
                    listBooks(request, response);
                    break;
                case "/categories":
                    listCategories(request, response);
                    break;
                case "/orders":
                    listOrders(request, response);
                    break;
                case "/suggestions":
                    listSuggestions(request, response);
                    break;
                case "/users":
                    listUsers(request, response);
                    break;
                case "/profile":
                    // Get the current admin user's details
                    User adminUser = (User) session.getAttribute("user");
                    if (adminUser != null) {
                        // Get updated user data from database
                        User updatedUser = userDAO.getUserById(adminUser.getUserId());
                        if (updatedUser != null) {
                            session.setAttribute("user", updatedUser);
                        }
                    }
                    request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException("Error processing request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            switch (action) {
                case "/update-order-status":
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String status = request.getParameter("status");
                    boolean success = orderDAO.updateOrderStatus(orderId, status);
                    if (success) {
                        response.getWriter()
                                .write("{\"success\":true, \"message\":\"Order status updated successfully\"}");
                    } else {
                        response.getWriter().write("{\"success\":false, \"error\":\"Failed to update order status\"}");
                    }
                    break;
                case "/update-payment-status":
                    updatePaymentStatus(request, response);
                    break;
                case "/settings/general":
                    // Handle general settings update
                    response.setContentType("application/json");
                    response.getWriter()
                            .write("{\"success\":true, \"message\":\"General settings updated successfully\"}");
                    break;
                case "/settings/payment":
                    // Handle payment settings update
                    response.setContentType("application/json");
                    response.getWriter()
                            .write("{\"success\":true, \"message\":\"Payment settings updated successfully\"}");
                    break;
                case "/settings/shipping":
                    // Handle shipping settings update
                    response.setContentType("application/json");
                    response.getWriter()
                            .write("{\"success\":true, \"message\":\"Shipping settings updated successfully\"}");
                    break;
                case "/settings/email":
                    // Handle email settings update
                    response.setContentType("application/json");
                    response.getWriter()
                            .write("{\"success\":true, \"message\":\"Email settings updated successfully\"}");
                    break;
                case "/delete-suggestion":
                    deleteSuggestion(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false, \"error\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // --- Book delete ---
        if ("/books".equals(action)) {
            String bookIdStr = request.getParameter("bookId");
            try {
                if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Book ID is required\"}");
                    return;
                }
                int bookId = Integer.parseInt(bookIdStr);
                if (bookDAO.deleteBook(bookId)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"message\":\"Book deleted successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\":\"Failed to delete book\"}");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid book ID\"}");
            }
            return;
        }
        // --- Order delete ---
        if ("/orders".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            try {
                if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Order ID is required\"}");
                    return;
                }
                int orderId = Integer.parseInt(orderIdStr);
                boolean deleted = orderDAO.deleteOrder(orderId);
                if (deleted) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"message\":\"Order deleted successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"error\":\"Failed to delete order\"}");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid order ID\"}");
            }
            return;
        }
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.getWriter().write("{\"error\":\"Invalid endpoint\"}");
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Fetch dashboard data
        long totalBooks = bookDAO.getTotalBooks();
        int totalCustomers = userDAO.getTotalUsers(); // Or userDAO.getActiveUsersCount() if that's preferred
        double totalRevenue = orderDAO.getTotalRevenue();
        int totalOrders = orderDAO.getTotalOrders();

        // Fetch stats requiring new DAO methods
        double averageOrderValue = orderDAO.getAverageOrderValue();
        int booksSoldToday = orderDAO.getBooksSoldToday();
        int pendingOrders = orderDAO.getPendingOrdersCount();
        int lowStockBooks = bookDAO.getLowStockBooksCount(10); // Threshold set to 10

        // Fetch lists of books and orders
        List<model.Book> topSellingBooks = bookDAO.getTopSellingBooks(10); // Fetch top 10
        List<model.Order> recentOrders = orderDAO.getRecentOrders(5); // Fetch recent 5

        // Set attributes for JSP
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);

        request.setAttribute("averageOrderValue", averageOrderValue);
        request.setAttribute("booksSoldToday", booksSoldToday);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("lowStockBooks", lowStockBooks);

        request.setAttribute("topSellingBooks", topSellingBooks);
        request.setAttribute("recentOrders", recentOrders);

        // Forward to dashboard JSP
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading users", e);
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<Book> books = bookDAO.getAllBooks();
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/admin/books.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading books", e);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading categories", e);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<Order> orders = orderDAO.getAllOrders();
            // Build payment status map
            java.util.Map<Integer, String> orderPaymentStatus = new java.util.HashMap<>();
            for (Order order : orders) {
                String status = paymentDAO.getOrderPayment(order.getOrderId()) != null
                        ? paymentDAO.getOrderPayment(order.getOrderId()).getStatus()
                        : "N/A";
                orderPaymentStatus.put(order.getOrderId(), status);
            }
            request.setAttribute("orders", orders);
            request.setAttribute("orderPaymentStatus", orderPaymentStatus);
            request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading orders", e);
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<Payment> payments = paymentDAO.getUserPayments(0); // Get all payments
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/views/admin/payments.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading payments", e);
        }
    }

    private void listSuggestions(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            List<SuggestionBook> suggestions = suggestionDAO.getAllSuggestions();
            request.setAttribute("suggestions", suggestions);
            request.getRequestDispatcher("/views/admin/suggestions.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading suggestions", e);
        }
    }

    private void deleteSuggestion(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            int suggestionId = Integer.parseInt(request.getParameter("suggestionId"));
            if (suggestionDAO.deleteSuggestion(suggestionId)) {
                response.sendRedirect(request.getContextPath() + "/admin/suggestions");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete suggestion");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error deleting suggestion: " + e.getMessage());
        }
    }

    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            String orderIdParam = request.getParameter("orderId");
            String status = request.getParameter("status");

            System.out.println("Updating payment status - Order ID: " + orderIdParam + ", Status: " + status);

            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"error\":\"Order ID is required\"}");
                return;
            }

            int orderId;
            try {
                orderId = Integer.parseInt(orderIdParam);
            } catch (NumberFormatException e) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"error\":\"Invalid Order ID format\"}");
                return;
            }

            if (status == null || status.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"error\":\"Payment status is required\"}");
                return;
            }

            // First get the payment for this order
            Payment payment = paymentDAO.getOrderPayment(orderId);
            if (payment == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"error\":\"No payment found for this order\"}");
                return;
            }

            System.out.println("Found payment - Payment ID: " + payment.getPaymentId() + ", Current Status: "
                    + payment.getStatus());

            // Update the payment status
            boolean success = paymentDAO.updatePaymentStatus(payment.getPaymentId(), status);
            System.out.println("Update result: " + (success ? "Success" : "Failed"));

            response.setContentType("application/json");
            if (success) {
                response.getWriter().write("{\"success\":true, \"message\":\"Payment status updated successfully\"}");
            } else {
                response.getWriter().write("{\"success\":false, \"error\":\"Failed to update payment status\"}");
            }
        } catch (SQLException e) {
            System.err.println("SQL Error updating payment status: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":false, \"error\":\"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            System.err.println("Error updating payment status: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter()
                    .write("{\"success\":false, \"error\":\"An unexpected error occurred: " + e.getMessage() + "\"}");
        }
    }
}