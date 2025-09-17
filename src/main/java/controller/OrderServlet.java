package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.google.gson.Gson;

import dao.CartDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.PaymentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.Payment;
import model.User;

@WebServlet("/orders/*")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private CartDAO cartDAO;
    private PaymentDAO paymentDAO;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        try {
            orderDAO = new OrderDAO();
            orderItemDAO = new OrderItemDAO();
            cartDAO = new CartDAO();
            paymentDAO = new PaymentDAO();
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Order JSON for admin modal/details ---
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                Order order = orderDAO.getOrder(orderId);
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(order));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid order ID\"}");
            }
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/list":
                    listOrders(request, response);
                    break;
                case "/view":
                    viewOrder(request, response);
                    break;
                case "/api/view":
                    apiViewOrder(request, response);
                    break;
                case "/api/user":
                    apiUserOrders(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");

        String orderIdParam = request.getParameter("orderId");
        try {
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"error\":\"Order ID is required\"}");
                return;
            }
            int orderId = Integer.parseInt(orderIdParam);
            boolean success = orderDAO.deleteOrder(orderId);
            if (success) {
                response.getWriter().write("{\"success\":true,\"message\":\"Order deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"success\":false,\"error\":\"Order not found or could not be deleted\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter()
                    .write("{\"success\":false,\"error\":\"Error deleting order: " + e.getMessage() + "\"}");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");

        // Handle order status update
        String orderIdParam = request.getParameter("orderId");
        String orderStatus = request.getParameter("orderStatus");
        String status = request.getParameter("status");
        if (orderIdParam != null && (orderStatus != null || status != null)) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                String newStatus = orderStatus != null ? orderStatus : status;
                boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
                if (success) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Order status updated successfully\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\":false,\"error\":\"Failed to update order status\"}");
                }
                return;
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter()
                        .write("{\"success\":false,\"error\":\"Error updating order status: " + e.getMessage() + "\"}");
                return;
            }
        }

        // Handle other POST requests
        String action = request.getPathInfo();
        if (action == null) {
            action = "/create";
        }

        try {
            switch (action) {
                case "/create":
                    createOrder(request, response);
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"success\":false,\"error\":\"Invalid action\"}");
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Accept");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        List<Order> orders;
        if ("admin".equals(user.getRole())) {
            orders = orderDAO.getAllOrders();
        } else {
            orders = orderDAO.getUserOrders(user.getUserId());
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/views/pages/order_view.jsp").forward(request, response);
    }

    private void viewOrder(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrder(orderId);

        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Check if user has permission to view this order
        if (!"admin".equals(user.getRole()) && order.getUserId() != user.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        List<OrderItem> orderItems = orderItemDAO.getOrderItems(orderId);
        Payment payment = paymentDAO.getOrderPayment(orderId);

        order.setOrderItems(orderItems);

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/views/pages/order_view.jsp").forward(request, response);
    }

    private void apiViewOrder(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.equals("null")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"No order ID specified\"}");
            return;
        }
        int orderId = Integer.parseInt(idParam);
        Order order = orderDAO.getOrder(orderId);
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Order not found\"}");
            return;
        }
        if (!"admin".equals(user.getRole()) && order.getUserId() != user.getUserId()) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Forbidden\"}");
            return;
        }
        // Attach order items
        List<OrderItem> orderItems = orderItemDAO.getOrderItems(orderId);
        // Build a simple JSON structure
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"orderId\":").append(order.getOrderId()).append(",");
        json.append("\"orderDate\":\"").append(order.getOrderDate()).append("\",");
        json.append("\"status\":\"").append(order.getStatus() != null ? order.getStatus() : "").append("\",");
        json.append("\"shippingAddress\":\"")
                .append(order.getShippingAddress() != null ? order.getShippingAddress().replace("\"", "\\\"") : "")
                .append("\",");
        json.append("\"paymentMethod\":\"")
                .append(order.getPaymentMethod() != null ? order.getPaymentMethod().replace("\"", "\\\"") : "")
                .append("\",");
        json.append("\"totalAmount\":").append(order.getTotalAmount()).append(",");
        json.append("\"orderItems\":[");
        for (int i = 0; i < orderItems.size(); i++) {
            OrderItem item = orderItems.get(i);
            // Book details
            model.Book book = item.getBook();
            json.append("{");
            json.append("\"quantity\":").append(item.getQuantity()).append(",");
            json.append("\"price\":").append(item.getPrice()).append(",");
            json.append("\"book\":{");
            json.append("\"bookId\":").append(book.getBookId()).append(",");
            json.append("\"bookName\":\"").append(book.getBookName().replace("\"", "\\\"")).append("\",");
            json.append("\"writerName\":\"").append(book.getWriterName().replace("\"", "\\\"")).append("\",");
            json.append("\"price\":").append(book.getPrice()).append(",");
            json.append("\"picture\":\"")
                    .append(book.getPicture() != null ? book.getPicture().replace("\"", "\\\"") : "").append("\"");
            json.append("}");
            json.append("}");
            if (i < orderItems.size() - 1)
                json.append(",");
        }
        json.append("]}");
        response.setContentType("application/json");
        response.getWriter().write(json.toString());
    }

    private void apiUserOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }
        List<Order> orders = orderDAO.getUserOrders(user.getUserId());
        // Attach items to each order
        for (Order order : orders) {
            List<OrderItem> orderItems = orderItemDAO.getOrderItems(order.getOrderId());
            order.setOrderItems(orderItems);
        }
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(orders));
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        boolean wantsJson = false;
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            wantsJson = true;
        }

        try {
            // Get cart items
            List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
            if (cartItems.isEmpty()) {
                if (wantsJson) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":false,\"error\":\"Cart is empty\"}");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cart is empty");
                }
                return;
            }

            // Calculate total amount
            double totalAmount = cartItems.stream()
                    .mapToDouble(item -> item.getBook().getPrice() * item.getQuantity())
                    .sum();

            // Create order
            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setOrderDate(new Timestamp(System.currentTimeMillis()));
            order.setTotalAmount(totalAmount);
            order.setStatus("Pending");
            order.setShippingAddress(request.getParameter("shippingAddress"));
            order.setPaymentMethod(request.getParameter("paymentMethod"));

            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                if (wantsJson) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":false,\"error\":\"Failed to create order\"}");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create order");
                }
                return;
            }

            // Create order items
            for (CartItem cartItem : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(orderId);
                orderItem.setBookId(cartItem.getBookId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(cartItem.getBook().getPrice());
                orderItemDAO.addOrderItem(orderItem);
            }

            // Create payment
            Payment payment = new Payment();
            payment.setDate(new Timestamp(System.currentTimeMillis()));
            payment.setMethod(request.getParameter("paymentMethod"));
            payment.setStatus("Pending");
            payment.setUserId(user.getUserId());
            payment.setOrderId(orderId);
            payment.setAmount(totalAmount);
            paymentDAO.createPayment(payment);

            // Clear cart
            cartDAO.clearCart(user.getUserId());

            if (wantsJson) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true,\"orderId\":" + orderId + "}");
            } else {
                response.sendRedirect(request.getContextPath() + "/orders/view?id=" + orderId);
            }
        } catch (SQLException e) {
            if (wantsJson) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"error\":\"Error processing order: "
                        + e.getMessage().replace("\"", "'") + "\"}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Error processing order: " + e.getMessage());
            }
        }
    }
}