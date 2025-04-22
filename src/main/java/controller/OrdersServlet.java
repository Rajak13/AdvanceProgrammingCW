package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.User;

/**
 * Servlet for handling customer order management
 */
@WebServlet("/orders/*")
public class OrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    /**
     * Handle GET requests for customer orders
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=orders");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // Show order history
                listUserOrders(request, response, user);
            } else if (pathInfo.startsWith("/details/")) {
                // Show specific order details
                showOrderDetails(request, response, pathInfo, user);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    /**
     * List all orders for a user
     */
    private void listUserOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws SQLException, ServletException, IOException {
        // Get user's orders
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

        // Set attributes for the JSP
        request.setAttribute("orders", orders);

        // Forward to the JSP
        request.getRequestDispatcher("/views/orders/history.jsp").forward(request, response);
    }

    /**
     * Show details for a specific order
     */
    private void showOrderDetails(HttpServletRequest request, HttpServletResponse response, String pathInfo, User user)
            throws SQLException, ServletException, IOException {
        try {
            // Extract order ID from path
            String orderIdStr = pathInfo.substring("/details/".length());
            int orderId = Integer.parseInt(orderIdStr);

            // Get order details
            Order order = orderDAO.getOrderById(orderId);

            // Check if order exists and belongs to the current user
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                return;
            }

            // Set attributes for the JSP
            request.setAttribute("order", order);

            // Forward to the JSP
            request.getRequestDispatcher("/views/orders/details.jsp").forward(request, response);

        } catch (NumberFormatException | IndexOutOfBoundsException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
        }
    }
}