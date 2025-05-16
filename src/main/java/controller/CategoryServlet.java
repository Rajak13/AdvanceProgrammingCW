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

@WebServlet("/categories/*")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;
    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        try {
            categoryDAO = new CategoryDAO();
            bookDAO = new BookDAO();
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/list":
                    listCategories(request, response);
                    break;
                case "/view":
                    viewCategory(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/pages/category.jsp").forward(request, response);
    }

    private void viewCategory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.getCategoryById(categoryId);
        if (category != null) {
            List<Book> books = bookDAO.getBooksByCategory(categoryId);
            request.setAttribute("category", category);
            request.setAttribute("books", books);
            request.getRequestDispatcher("/views/pages/category_view.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}