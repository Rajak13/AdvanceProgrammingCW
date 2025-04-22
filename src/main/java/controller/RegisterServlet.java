package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import utils.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");

    // Password minimum requirements
    private static final int MIN_PASSWORD_LENGTH = 8;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");

        // Basic validation
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username is required");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        if (username.length() < 3) {
            request.setAttribute("errorMessage", "Username must be at least 3 characters long");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        // Email validation
        if (email == null || email.trim().isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("errorMessage", "Please enter a valid email address");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        // Password validation
        if (password == null || password.length() < MIN_PASSWORD_LENGTH) {
            request.setAttribute("errorMessage",
                    "Password must be at least " + MIN_PASSWORD_LENGTH + " characters long");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        // Password strength check
        if (!passwordMeetsRequirements(password)) {
            request.setAttribute("errorMessage",
                    "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        // Password confirmation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(username);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setContact(contact);
        user.setAddress(address);

        UserDAO userDAO = new UserDAO();

        try {
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("errorMessage", "Email already registered");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                return;
            }

            if (userDAO.getUserByUsername(username) != null) {
                request.setAttribute("errorMessage", "Username already taken");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                return;
            }

            boolean success = userDAO.createUser(user);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/auth?registered=true");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }

    /**
     * Checks if the password meets security requirements
     * 
     * @param password The password to check
     * @return true if the password meets requirements, false otherwise
     */
    private boolean passwordMeetsRequirements(String password) {
        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            } else if (Character.isLowerCase(c)) {
                hasLowercase = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }

        return hasUppercase && hasLowercase && hasDigit && hasSpecial;
    }
}