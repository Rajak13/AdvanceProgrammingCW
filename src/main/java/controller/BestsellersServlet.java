package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Category;

@WebServlet("/bestsellers")
public class BestsellersServlet extends HttpServlet {
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
            List<Book> books = bookDAO.getBestSellers(page, itemsPerPage, sortBy, categoryFilter);
            int totalBooks = bookDAO.countBestSellers(categoryFilter);

            // Get categories for filter
            List<Category> categories = categoryDAO.getAllCategories();

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalBooks / itemsPerPage);

            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("categories", categories);
            request.setAttribute("currentPage", "bestsellers");
            request.setAttribute("page", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("categoryFilter", categoryFilter);

            // Forward to JSP
            request.getRequestDispatcher("/views/pages/bestsellers.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}