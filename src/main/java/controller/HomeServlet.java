package controller;

import java.io.IOException;
import java.sql.SQLException;

import dao.BookDAO;
import dao.CategoryDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        try {
            bookDAO = new BookDAO();
            categoryDAO = new CategoryDAO();
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Set attributes for the page template
        request.setAttribute("pageTitle", "Home");
        request.setAttribute("currentPage", "home");
        request.setAttribute("mainContent", "/views/pages/home_content.jsp");

        // Forward to the page template
        request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
    }
}
