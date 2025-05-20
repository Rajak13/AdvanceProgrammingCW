package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Book;
import model.CartItem;
import model.User;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        try {
            cartDAO = new CartDAO();
            bookDAO = new BookDAO();
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        System.out.println("CartServlet doGet - action: " + action); // Debug log

        if (action == null) {
            action = "/";
        }

        switch (action) {
            case "/":
            case "/view":
                // Return cart as JSON for AJAX
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user == null) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json");
                    response.getWriter().write("[]");
                    return;
                }
                try {
                    List<CartItem> cartItems = cartDAO.getCartItems(user.getUserId());
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    StringBuilder json = new StringBuilder("[");
                    for (int i = 0; i < cartItems.size(); i++) {
                        CartItem item = cartItems.get(i);
                        Book book = item.getBook();
                        json.append("{\"cartId\":").append(item.getCartId())
                                .append(",\"bookId\":").append(item.getBookId())
                                .append(",\"quantity\":").append(item.getQuantity())
                                .append(",\"book\":{")
                                .append("\"bookId\":").append(book.getBookId()).append(",")
                                .append("\"bookName\":\"").append(book.getBookName().replace("\"", "\\\""))
                                .append("\",")
                                .append("\"writerName\":\"").append(book.getWriterName().replace("\"", "\\\""))
                                .append("\",")
                                .append("\"price\":").append(book.getPrice()).append(",")
                                .append("\"picture\":\"")
                                .append(book.getPicture() != null ? book.getPicture().replace("\"", "\\\"") : "")
                                .append("\",")
                                .append("\"stock\":").append(book.getStock()).append(",")
                                .append("\"status\":\"")
                                .append(book.getStatus() != null ? book.getStatus().replace("\"", "\\\"") : "")
                                .append("\",")
                                .append("\"description\":\"")
                                .append(book.getDescription() != null ? book.getDescription().replace("\"", "\\\"")
                                        : "")
                                .append("\"")
                                .append("}");
                        json.append("}");
                        if (i < cartItems.size() - 1)
                            json.append(",");
                    }
                    json.append("]");
                    response.getWriter().write(json.toString());
                } catch (SQLException e) {
                    System.err.println("Error getting cart items: " + e.getMessage()); // Debug log
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.setContentType("application/json");
                    response.getWriter().write("[]");
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/add";
        }

        try {
            switch (action) {
                case "/add":
                    addToCart(request, response);
                    break;
                case "/update":
                    updateCartItem(request, response);
                    break;
                case "/remove":
                    removeFromCart(request, response);
                    break;
                case "/clear":
                    clearCart(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            System.err.println("Error in CartServlet doPost: " + e.getMessage()); // Debug log
            throw new ServletException(e);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Book book = bookDAO.getBook(bookId);
        if (book == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
            return;
        }

        CartItem cartItem = new CartItem();
        cartItem.setUserId(user.getUserId());
        cartItem.setBookId(bookId);
        cartItem.setQuantity(quantity);
        cartItem.setBook(book);

        boolean added = cartDAO.addToCart(cartItem);
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (added) {
                response.getWriter().write("{\"success\":true,\"message\":\"Added to cart!\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Failed to add item to cart\"}");
            }
        } else {
            if (added) {
                response.sendRedirect(request.getContextPath() + "/cart/view");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to add item to cart");
            }
        }
    }

    private void updateCartItem(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            String cartIdStr = request.getParameter("cartId");
            String quantityStr = request.getParameter("quantity");
            System.out.println("updateCartItem: cartId param: " + cartIdStr + ", quantity param: " + quantityStr);
            if (cartIdStr == null || cartIdStr.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"Missing cart ID or quantity\"}");
                return;
            }
            int cartId = Integer.parseInt(cartIdStr);
            int quantity = Integer.parseInt(quantityStr);

            boolean updated = cartDAO.updateCartItem(cartId, user.getUserId(), quantity);
            String accept = request.getHeader("Accept");
            if (accept != null && accept.contains("application/json")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (updated) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Cart updated successfully\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to update cart item\"}");
                }
            } else {
                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/cart/view");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update cart item");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid cart ID or quantity\"}");
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            String cartIdStr = request.getParameter("cartId");
            System.out.println("removeFromCart: cartId param: " + cartIdStr);
            if (cartIdStr == null || cartIdStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"Missing cart ID\"}");
                return;
            }
            int cartId = Integer.parseInt(cartIdStr);
            boolean removed = cartDAO.removeFromCart(cartId, user.getUserId());
            String accept = request.getHeader("Accept");
            if (accept != null && accept.contains("application/json")) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                if (removed) {
                    response.getWriter().write("{\"success\":true,\"message\":\"Item removed from cart!\"}");
                } else {
                    response.getWriter().write("{\"success\":false,\"message\":\"Failed to remove item from cart\"}");
                }
            } else {
                if (removed) {
                    response.sendRedirect(request.getContextPath() + "/cart/view");
                } else {
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to remove item from cart");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid cart ID\"}");
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        if (cartDAO.clearCart(user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/cart/view");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to clear cart");
        }
    }
}