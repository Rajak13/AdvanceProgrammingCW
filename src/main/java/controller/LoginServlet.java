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
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = new UserDAO().getUserByUsername(username);
            if (user != null && PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect("home.jsp");
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("/WEB-INF/views/auth/auth.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}