package controller.admin;

import java.io.IOException;
import java.io.PrintWriter;
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
import model.OrderItem;
import model.User;

/**
 * Servlet for handling admin order management operations
 */
@WebServlet("/admin/orders/*")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAO();
    }

    /**
     * Handle GET requests for order management
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !((User) session.getAttribute("user")).isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("")) {
                // Show order listing page
                listOrders(request, response);
            } else if (pathInfo.equals("/get")) {
                // Get single order details as JSON
                getOrderDetails(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    /**
     * Handle POST requests for order management
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !((User) session.getAttribute("user")).isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if (pathInfo != null && pathInfo.equals("/updateStatus")) {
                // Update order status
                updateOrderStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    /**
     * List all orders with pagination and filtering
     */
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        // Get pagination parameters
        int page = 1;
        int recordsPerPage = 10;
        String searchTerm = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException | NullPointerException e) {
            // Use default page 1
        }

        // Get orders from database
        List<Order> orders = orderDAO.getAllOrders(page, recordsPerPage, searchTerm, statusFilter);
        int totalOrders = orderDAO.countOrders(searchTerm, statusFilter);
        int totalPages = (int) Math.ceil((double) totalOrders / recordsPerPage);

        // Set attributes for the JSP
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("recordsPerPage", recordsPerPage);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);

        // Forward to the JSP
        request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
    }

    /**
     * Get details for a single order and return as JSON
     */
    private void getOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int orderId = 0;

        try {
            orderId = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Invalid order ID");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            sendJsonError(response, "Order not found");
            return;
        }

        // Manually create JSON string for order details
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{");
        jsonBuilder.append("\"orderId\":" + order.getId() + ",");
        jsonBuilder.append("\"orderDate\":\"" + order.getOrderDate() + "\",");
        jsonBuilder.append("\"status\":\"" + order.getStatus() + "\",");
        jsonBuilder.append("\"totalAmount\":" + order.getTotalAmount() + ",");
        jsonBuilder.append("\"shippingAddress\":\"" + escapeJsonString(order.getShippingAddress()) + "\",");
        jsonBuilder.append("\"paymentMethod\":\"" + escapeJsonString(order.getPaymentMethod()) + "\",");

        // Add customer info
        jsonBuilder.append("\"customer\":{");
        if (order.getUser() != null) {
            jsonBuilder.append("\"name\":\"" + escapeJsonString(order.getUser().getName()) + "\",");
            jsonBuilder.append("\"email\":\"" + escapeJsonString(order.getUser().getEmail()) + "\",");
            jsonBuilder.append("\"contact\":\"" + escapeJsonString(order.getUser().getContact()) + "\"");
        }
        jsonBuilder.append("},");

        // Add order items
        jsonBuilder.append("\"items\":[");
        if (order.getOrderItems() != null && !order.getOrderItems().isEmpty()) {
            for (int i = 0; i < order.getOrderItems().size(); i++) {
                OrderItem item = order.getOrderItems().get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"id\":" + item.getId() + ",");
                jsonBuilder.append("\"quantity\":" + item.getQuantity() + ",");
                jsonBuilder.append("\"pricePerUnit\":" + item.getPricePerUnit() + ",");

                // Add book details if available
                if (item.getBook() != null) {
                    jsonBuilder.append("\"book\":{");
                    jsonBuilder.append("\"id\":" + item.getBook().getBookId() + ",");
                    jsonBuilder.append("\"title\":\"" + escapeJsonString(item.getBook().getBookName()) + "\",");
                    jsonBuilder.append("\"author\":\"" + escapeJsonString(item.getBook().getWriterName()) + "\",");
                    jsonBuilder.append("\"coverImage\":\"" + escapeJsonString(item.getBook().getPicture()) + "\"");
                    jsonBuilder.append("}");
                }

                jsonBuilder.append("}");

                // Add comma if not the last item
                if (i < order.getOrderItems().size() - 1) {
                    jsonBuilder.append(",");
                }
            }
        }
        jsonBuilder.append("]");

        jsonBuilder.append("}");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(jsonBuilder.toString());
        out.flush();
    }

    /**
     * Update order status
     */
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int orderId = 0;

        try {
            orderId = Integer.parseInt(request.getParameter("orderId"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Invalid order ID");
            return;
        }

        String status = request.getParameter("status");
        String trackingNumber = request.getParameter("trackingNumber");
        String notes = request.getParameter("notes");

        if (status == null || status.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            sendJsonError(response, "Status cannot be empty");
            return;
        }

        boolean updated = orderDAO.updateOrderStatus(orderId, status, trackingNumber, notes);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?success=Order status updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders?error=Failed to update order status");
        }
    }

    /**
     * Send an error message as JSON response
     */
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        String jsonError = "{\"error\":\"" + escapeJsonString(message) + "\"}";
        out.print(jsonError);
        out.flush();
    }

    /**
     * Escape special characters for JSON string values
     */
    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}