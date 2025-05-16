package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Payment;
import model.User;

@WebServlet("/payments/*")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;

    public void init() {
        paymentDAO = new PaymentDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/list":
                    listPayments(request, response);
                    break;
                case "/view":
                    viewPayment(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/create";
        }

        try {
            switch (action) {
                case "/create":
                    createPayment(request, response);
                    break;
                case "/update":
                    updatePayment(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        if (!"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("payments", paymentDAO.getAllPayments());
        request.getRequestDispatcher("/payments/list.jsp").forward(request, response);
    }

    private void viewPayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int paymentId = Integer.parseInt(request.getParameter("id"));
        Payment payment = paymentDAO.getPayment(paymentId);

        if (payment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Check if user has permission to view this payment
        if (!"admin".equals(user.getRole()) && payment.getUserId() != user.getUserId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/payments/view.jsp").forward(request, response);
    }

    private void createPayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String method = request.getParameter("method");
        double amount = Double.parseDouble(request.getParameter("amount"));

        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setUserId(user.getUserId());
        payment.setAmount(amount);
        payment.setMethod(method);
        payment.setStatus("pending");
        payment.setDate(new Timestamp(System.currentTimeMillis()));

        int paymentId = paymentDAO.createPayment(payment);
        if (paymentId == -1) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create payment");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/payments/view?id=" + paymentId);
    }

    private void updatePayment(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int paymentId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        Payment payment = paymentDAO.getPayment(paymentId);
        if (payment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        payment.setStatus(status);
        if (paymentDAO.updatePayment(payment)) {
            response.sendRedirect(request.getContextPath() + "/payments/view?id=" + paymentId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update payment");
        }
    }
}