package controller;

import java.io.IOException;
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
        String action = request.getPathInfo();

        // Get or create session
        HttpSession session = request.getSession(true);

        // Check if user is already logged in
        if (session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (action == null) {
            // Show the combined auth page with login panel active by default
            request.setAttribute("activePanel", "login");
            request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "/login":
                // Show the combined auth page with login panel active
                request.setAttribute("activePanel", "login");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                break;
            case "/register":
                // Show the combined auth page with register panel active
                request.setAttribute("activePanel", "register");
                request.getRequestDispatcher("/views/auth/auth.jsp").forward(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "/login":
                login(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
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
}