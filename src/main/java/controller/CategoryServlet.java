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

@WebServlet("/category/*")
public class CategoryServlet extends HttpServlet {
    private static final int ITEMS_PER_PAGE = 12; // Number of books to display per page

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String categorySlug = pathInfo != null ? pathInfo.substring(1) : "";

        try {
            CategoryDAO categoryDAO = new CategoryDAO();
            BookDAO bookDAO = new BookDAO();

            // Get category by slug
            Category category = categoryDAO.getCategoryBySlug(categorySlug);

            if (category == null) {
                // If category doesn't exist, redirect to categories list page
                response.sendRedirect(request.getContextPath() + "/categories");
                return;
            }

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

            // Sorting parameters
            String sortBy = request.getParameter("sort");
            String priceRange = request.getParameter("price");

            // Get books for this category with pagination and filters
            List<Book> books = bookDAO.getBooksByCategory(category.getCategoryId(), page, ITEMS_PER_PAGE, sortBy,
                    priceRange);
            int totalBooks = bookDAO.countBooksByCategory(category.getCategoryId(), priceRange);
            int totalPages = (int) Math.ceil((double) totalBooks / ITEMS_PER_PAGE);

            // Get recommended books (could be based on user's history or popular books)
            List<Book> recommendedBooks = bookDAO.getRecommendedBooks(5); // Limit to 5 books

            // Set attributes for JSP
            request.setAttribute("category", category);
            request.setAttribute("books", books);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("recommendedBooks", recommendedBooks);

            // Forward to category page
            request.setAttribute("pageTitle", category.getCategoryName() + " Books");
            request.setAttribute("currentPage", "category");
            request.setAttribute("mainContent", "/views/pages/category/category.jsp");
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}