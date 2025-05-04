package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
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

@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;

    public void init() {
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "create":
                    createBook(request, response);
                    break;
                case "update":
                    updateBook(request, response);
                    break;
                case "delete":
                    deleteBook(request, response);
                    break;
                default:
                    listBooks(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                default:
                    listBooks(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        for (Book book : books) {
            book.setCategories(bookDAO.getCategoriesForBook(book.getBookId()));
        }
        request.setAttribute("books", books);
        request.getRequestDispatcher("book-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("book-form.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(id);
        book.setCategories(bookDAO.getCategoriesForBook(id));
        List<Category> allCategories = categoryDAO.getAllCategories();
        request.setAttribute("book", book);
        request.setAttribute("categories", allCategories);
        request.getRequestDispatcher("book-form.jsp").forward(request, response);
    }

    private void createBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        Book book = new Book();
        book.setBookName(request.getParameter("bookName"));
        book.setPrice(Double.parseDouble(request.getParameter("price")));
        book.setWriterName(request.getParameter("writerName"));
        book.setPicture(request.getParameter("picture"));
        book.setStatus(request.getParameter("status"));
        book.setStock(Integer.parseInt(request.getParameter("stock")));
        book.setDescription(request.getParameter("description"));

        String[] categoryIds = request.getParameterValues("categories");
        List<Integer> selectedCategoryIds = new ArrayList<>();
        if (categoryIds != null) {
            for (String categoryId : categoryIds) {
                selectedCategoryIds.add(Integer.parseInt(categoryId));
            }
        }

        bookDAO.createBook(book, selectedCategoryIds);
        response.sendRedirect("BookServlet");
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Book book = new Book();
        book.setBookId(id);
        book.setBookName(request.getParameter("bookName"));
        book.setPrice(Double.parseDouble(request.getParameter("price")));
        book.setWriterName(request.getParameter("writerName"));
        book.setPicture(request.getParameter("picture"));
        book.setStatus(request.getParameter("status"));
        book.setStock(Integer.parseInt(request.getParameter("stock")));
        book.setDescription(request.getParameter("description"));

        String[] categoryIds = request.getParameterValues("categories");
        List<Integer> selectedCategoryIds = new ArrayList<>();
        if (categoryIds != null) {
            for (String categoryId : categoryIds) {
                selectedCategoryIds.add(Integer.parseInt(categoryId));
            }
        }

        bookDAO.updateBook(book);
        bookDAO.updateBookCategories(id, selectedCategoryIds);
        response.sendRedirect("BookServlet");
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        bookDAO.deleteBook(id);
        response.sendRedirect("BookServlet");
    }
}