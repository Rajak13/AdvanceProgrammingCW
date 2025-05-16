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

        try {
            switch (action) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/users":
                    listUsers(request, response);
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
                case "/payments":
                    listPayments(request, response);
                    break;
                case "/suggestions":
                    listSuggestions(request, response);
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
        if (action == null) {
            action = "/dashboard";
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            switch (action) {
                case "/update-order-status":
                    updateOrderStatus(request, response);
                    break;
                case "/update-payment-status":
                    updatePaymentStatus(request, response);
                    break;
                case "/delete-suggestion":
                    deleteSuggestion(request, response);
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
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Set content type for all responses
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (path.equals("/admin/books")) {
            handleBookDelete(request, response);
            return;
        }

        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        response.getWriter().write("{\"error\":\"Invalid endpoint\"}");
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int totalUsers = userDAO.getTotalUsers();
            long totalBooks = bookDAO.getTotalBooks();
            int totalOrders = orderDAO.getTotalOrders();
            double totalRevenue = orderDAO.getTotalRevenue();

            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error loading dashboard data", e);
        }
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
            request.setAttribute("orders", orders);
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

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String status = request.getParameter("status");
            if (orderDAO.updateOrderStatus(orderId, status)) {
                response.sendRedirect(request.getContextPath() + "/admin/orders");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update order status");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error updating order status: " + e.getMessage());
        }
    }

    private void updatePaymentStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            String status = request.getParameter("status");
            if (paymentDAO.updatePaymentStatus(paymentId, status)) {
                response.sendRedirect(request.getContextPath() + "/admin/payments");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update payment status");
            }
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error updating payment status: " + e.getMessage());
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

    private void handleBookDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String bookIdStr = request.getParameter("id");
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
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid book ID format\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error deleting book: " + e.getMessage() + "\"}");
        }
    }
}