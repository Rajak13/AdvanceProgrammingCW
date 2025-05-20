package controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;

import dao.BookDAO;
import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Book;
import model.Category;

@WebServlet("/books/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class BookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    private Gson gson = new Gson();
    private static final String UPLOAD_DIRECTORY = "uploads/books";

    @Override
    public void init() throws ServletException {
        try {
            bookDAO = new BookDAO();
            categoryDAO = new CategoryDAO();

            // Create upload directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
        } catch (SQLException e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // --- Book JSON for admin modal edit ---
        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam != null) {
            try {
                int bookId = Integer.parseInt(bookIdParam);
                Book book = bookDAO.getBook(bookId);
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(book));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid book ID\"}");
            }
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        try {
            switch (action) {
                case "/list":
                    listBooks(request, response);
                    break;
                case "/view":
                    viewBook(request, response);
                    break;
                case "/search":
                    searchBooks(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String categoryId = request.getParameter("category");
        String sortBy = request.getParameter("sort");
        String priceRange = request.getParameter("price");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            // Use default page 1
        }

        List<Book> books;
        if (categoryId != null && !categoryId.isEmpty()) {
            books = bookDAO.getBooksByCategory(Integer.parseInt(categoryId), page, 12, sortBy, priceRange);
        } else {
            books = bookDAO.getAllBooks(page, 12, sortBy, priceRange);
        }

        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("currentCategory", categoryId);
        request.setAttribute("currentSort", sortBy);
        request.setAttribute("currentPriceRange", priceRange);
        request.getRequestDispatcher("/views/pages/book_list.jsp").forward(request, response);
    }

    private void viewBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBook(bookId);

        if (book == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("book", book);
        request.getRequestDispatcher("/views/pages/book_view.jsp").forward(request, response);
    }

    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String query = request.getParameter("q");
        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        List<Book> books = bookDAO.searchBooks(query);
        request.setAttribute("books", books);
        request.setAttribute("searchQuery", query);
        request.getRequestDispatcher("/views/pages/book_search.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        try {
            // Get form data
            String bookIdParam = request.getParameter("bookId");
            String bookName = request.getParameter("bookName");
            String writerName = request.getParameter("writerName");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String categoryStr = request.getParameter("category");

            // Handle file upload
            String picture = null;
            Part filePart = request.getPart("picture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                filePart.write(uploadPath + File.separator + fileName);
                picture = UPLOAD_DIRECTORY + "/" + fileName;
            }

            // Validate required fields
            if (bookName == null || bookName.trim().isEmpty() ||
                    writerName == null || writerName.trim().isEmpty() ||
                    priceStr == null || priceStr.trim().isEmpty() ||
                    stockStr == null || stockStr.trim().isEmpty() ||
                    status == null || status.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Required fields are missing\"}");
                return;
            }

            // Create book object
            Book book = new Book();
            book.setBookName(bookName.trim());
            book.setWriterName(writerName.trim());
            book.setDescription(description != null ? description.trim() : "");
            book.setStatus(status.trim());
            if (picture != null) {
                book.setPicture(picture);
            }

            try {
                book.setPrice(Double.parseDouble(priceStr.trim()));
                book.setStock(Integer.parseInt(stockStr.trim()));
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid price or stock value\"}");
                return;
            }

            // Handle categories
            List<Integer> categoryIds = new ArrayList<>();
            if (categoryStr != null && !categoryStr.trim().isEmpty()) {
                try {
                    categoryIds.add(Integer.parseInt(categoryStr.trim()));
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Invalid category ID\"}");
                    return;
                }
            }

            boolean success;
            String message;
            if (bookIdParam != null && !bookIdParam.trim().isEmpty()) {
                // Update existing book
                try {
                    book.setBookId(Integer.parseInt(bookIdParam.trim()));
                    success = bookDAO.updateBook(book);
                    if (success) {
                        bookDAO.updateBookCategories(book.getBookId(), categoryIds);
                    }
                    message = success ? "Book updated successfully" : "Failed to update book";
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Invalid book ID\"}");
                    return;
                }
            } else {
                // Create new book
                success = bookDAO.createBook(book, categoryIds);
                message = success ? "Book created successfully" : "Failed to create book";
            }

            if (success) {
                response.getWriter().write("{\"message\":\"" + message + "\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\":\"" + message + "\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error processing book: " + e.getMessage() + "\"}");
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookIdParam = request.getParameter("bookId");
        response.setContentType("application/json");
        try {
            if (bookIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Book ID is required\"}");
                return;
            }
            int bookId = Integer.parseInt(bookIdParam);
            boolean success = bookDAO.deleteBook(bookId);
            if (success) {
                response.getWriter().write("{\"message\":\"Book deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Book not found or could not be deleted\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error deleting book\"}");
        }
    }
}