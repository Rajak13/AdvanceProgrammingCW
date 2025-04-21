package controller;

import model.User;
import dao.UserDAO;
import utils.PasswordUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = null;
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = new UserDAO().getUserByUsername(email);
            if (user != null && PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                // check if email ends with '@admin.com'
                HttpSession session = request.getSession();
                if (email != null && !email.endsWith("@admin.com")) {
                    role = "admin";
                    session.setAttribute("user", user);
                    session.setAttribute("role", role);
                    response.sendRedirect("admindashboard.jsp");
                } else {
                    role = "user";
                    session.setAttribute("user", user);
                    session.setAttribute("role", role);
                    response.sendRedirect("home.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("/WEB-INF/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}