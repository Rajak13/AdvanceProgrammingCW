package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null)
            path = "/";

        // Get or create session
        HttpSession session = request.getSession(true);

        // Check if user is already logged in
        if (session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        switch (path) {
            case "/":
                // Show login/register page with default panel
                request.setAttribute("activePanel",
                        request.getParameter("panel") != null ? request.getParameter("panel") : "login");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                break;
            case "/login":
                // Show login panel
                request.setAttribute("activePanel", "login");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                break;
            case "/register":
                // Show register panel
                request.setAttribute("activePanel", "register");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                break;
            case "/forgot-password":
                // Show forgot password form
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
                break;
            case "/reset-password":
                // Show reset password form
                String email = request.getParameter("email");
                if (email == null || email.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/auth/forgot-password");
                    return;
                }
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        if (path == null)
            path = "/";

        switch (path) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            case "/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/reset-password":
                handlePasswordReset(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.authenticateUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid email or password");
                request.setAttribute("activePanel", "login");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred");
            request.setAttribute("activePanel", "login");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.setAttribute("activePanel", "register");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        try {
            // Check if user already exists
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("errorMessage", "Email already registered");
                request.setAttribute("activePanel", "register");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                return;
            }

            // Create new user
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(password); // Will be hashed in UserDAO
            user.setContact(contact);
            user.setAddress(address);
            user.setRole("USER");
            user.setActive(true);

            if (userDAO.createUser(user)) {
                request.setAttribute("successMessage", "Registration successful! Please login.");
                request.setAttribute("activePanel", "login");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed");
                request.setAttribute("activePanel", "register");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred");
            request.setAttribute("activePanel", "register");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your email address");
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                // In a real application, you would send an email here
                // For now, we'll just redirect to the reset password page
                response.sendRedirect(request.getContextPath() + "/auth/reset-password?email=" +
                        URLEncoder.encode(email, StandardCharsets.UTF_8.toString()));
            } else {
                request.setAttribute("errorMessage", "No account found with that email address");
                request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
        }
    }

    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || newPassword == null || confirmPassword == null ||
                email.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            if (userDAO.resetPasswordByEmail(email, newPassword)) {
                request.setAttribute("successMessage",
                        "Password has been reset successfully. Please login with your new password.");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to reset password. Please try again.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
        }
    }
}