package controller;

import java.io.IOException;
import java.sql.SQLException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import utils.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.getUserByUsername(username);

            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
                // Create a new session and add user to it
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                // Handle "Remember Me" functionality
                if (remember != null) {
                    // Create a cookie with username - for security, we don't include sensitive data
                    Cookie userCookie = new Cookie("rememberedUser", username);
                    userCookie.setMaxAge(7 * 24 * 60 * 60); // 1 week
                    userCookie.setHttpOnly(true); // Security best practice
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                }

                // Check if user is admin and redirect accordingly
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    // Redirect to home page for regular users
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
        }
    }
}