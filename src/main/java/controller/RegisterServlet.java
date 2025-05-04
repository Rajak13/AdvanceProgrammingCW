package controller;

import java.io.IOException;
import java.sql.SQLException;

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
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setAddress(address);
        user.setContact(contact);
        user.setRole("USER");

        try {
            if (userDAO.createUser(user)) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
            } else {
                request.setAttribute("error", "Failed to create account");
                request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}