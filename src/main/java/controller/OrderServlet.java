package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() throws ServletException {
        super.init();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                    showOrderDetails(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/create":
                    createOrder(request, response);
                    break;
                case "/update":
                    updateOrderStatus(request, response);
                    break;
                default:
                    listOrders(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            page = Integer.parseInt(pageParam);
        }

        String searchTerm = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        List<Order> orders = orderDAO.getAllOrders(page, PAGE_SIZE, searchTerm, statusFilter);
        int totalOrders = orderDAO.countOrders(searchTerm, statusFilter);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
    }

    private void showOrderDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Map<String, Object> orderDetails = orderDAO.getOrderDetails(orderId);
        request.setAttribute("order", orderDetails);
        request.getRequestDispatcher("/views/admin/order-details.jsp").forward(request, response);
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setStatus("Pending");

        // TODO: Add order items from cart
        // For now, just redirect to order list
        response.sendRedirect("list");
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        orderDAO.updateOrderStatus(orderId, status);
        response.sendRedirect("list");
    }
}