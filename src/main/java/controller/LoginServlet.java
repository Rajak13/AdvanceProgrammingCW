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
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            User user = userDAO.getUserByUsername(username);

            if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                if (remember != null) {
                    Cookie userCookie = new Cookie("rememberedUser", username);
                    userCookie.setMaxAge(7 * 24 * 60 * 60);
                    userCookie.setHttpOnly(true);
                    userCookie.setPath("/");
                    response.addCookie(userCookie);
                }

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/views/pages/home.jsp");
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