package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;

@WebServlet("/deals")
public class DealsServlet extends HttpServlet {
    private static final int ITEMS_PER_PAGE = 12; // Number of books to display per page

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BookDAO bookDAO = new BookDAO();

            // Pagination parameters
            int page = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1)
                        page = 1;
                } catch (NumberFormatException e) {
                    // Invalid page number, use default
                }
            }

            // Sorting and filtering parameters
            String sortBy = request.getParameter("sort");
            String categoryFilter = request.getParameter("category");

            // In a real application, you would implement a method in BookDAO to get deals
            // and offers
            // For now, we'll use the same method as new releases
            List<Book> books = bookDAO.getNewReleaseBooks(page, ITEMS_PER_PAGE, sortBy, categoryFilter);
            int totalBooks = bookDAO.countNewReleaseBooks(categoryFilter);
            int totalPages = (int) Math.ceil((double) totalBooks / ITEMS_PER_PAGE);

            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Set attributes for the page template
            request.setAttribute("pageTitle", "Deals & Offers");
            request.setAttribute("currentPage", "deals");
            request.setAttribute("mainContent", "/views/pages/deals.jsp");

            // Forward to the page template
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}