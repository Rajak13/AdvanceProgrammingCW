package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import dao.CategoryDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Book;
import model.Category;

@WebServlet("/new-releases")
public class NewReleasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    public void init() throws ServletException {
        try {
            bookDAO = new BookDAO();
            categoryDAO = new CategoryDAO();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get pagination parameters
            int page = 1;
            int itemsPerPage = 12;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }

            // Get sorting and filtering parameters
            String sortBy = request.getParameter("sort");
            String categoryFilter = request.getParameter("category");

            // Get books and total count
            List<Book> books = bookDAO.getNewReleaseBooks(page, itemsPerPage, sortBy, categoryFilter);
            int totalBooks = bookDAO.countNewReleaseBooks(categoryFilter);

            // Get categories for filter
            List<Category> categories = categoryDAO.getAllCategories();

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalBooks / itemsPerPage);

            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", "new-releases");
            request.setAttribute("page", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("categoryFilter", categoryFilter);

            // Forward to JSP
            request.getRequestDispatcher("/views/pages/new_releases.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}