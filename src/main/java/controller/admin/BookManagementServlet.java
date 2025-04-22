package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Book;

@WebServlet("/admin/books/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class BookManagementServlet extends HttpServlet {

    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // List all books
                listBooks(request, response);
            } else if (pathInfo.equals("/add")) {
                // Show add book form
                showAddForm(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Show edit book form
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                // Delete a book
                deleteBook(request, response);
            } else if (pathInfo.equals("/view")) {
                // View book details
                viewBook(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Redirect to list
                response.sendRedirect(request.getContextPath() + "/admin/books");
            } else if (pathInfo.equals("/add")) {
                // Add new book
                addBook(request, response);
            } else if (pathInfo.equals("/edit")) {
                // Update existing book
                updateBook(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/views/admin/books/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/books/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);

        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/views/admin/books/form.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Book not found");
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    private void viewBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);

        if (book != null) {
            request.setAttribute("book", book);
            request.getRequestDispatcher("/views/admin/books/view.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Book not found");
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String bookName = request.getParameter("bookName");
        double price = Double.parseDouble(request.getParameter("price"));
        String writerName = request.getParameter("writerName");

        Book book = new Book();
        book.setBookName(bookName);
        book.setPrice(price);
        book.setWriterName(writerName);

        // Handle file upload if present
        Part filePart = request.getPart("picture");
        if (filePart != null && filePart.getSize() > 0) {
            // Save file and get the filename
            String fileName = processFileUpload(filePart);
            book.setPicture(fileName);
        }

        bookDAO.addBook(book);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        String bookName = request.getParameter("bookName");
        double price = Double.parseDouble(request.getParameter("price"));
        String writerName = request.getParameter("writerName");

        Book book = bookDAO.getBookById(bookId);

        if (book != null) {
            book.setBookName(bookName);
            book.setPrice(price);
            book.setWriterName(writerName);

            // Handle file upload if present
            Part filePart = request.getPart("picture");
            if (filePart != null && filePart.getSize() > 0) {
                // Save file and get the filename
                String fileName = processFileUpload(filePart);
                book.setPicture(fileName);
            }

            bookDAO.updateBook(book);

            response.sendRedirect(request.getContextPath() + "/admin/books");
        } else {
            request.setAttribute("errorMessage", "Book not found");
            request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        bookDAO.deleteBook(bookId);

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private String processFileUpload(Part filePart) throws IOException {
        // Generate a unique filename to avoid conflicts
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

        // Define the upload directory path
        String uploadDir = getServletContext().getRealPath("/images/books/");

        // Create the directory if it doesn't exist
        java.io.File uploadDirFile = new java.io.File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }

        // Ensure proper file path with correct separator
        String filePath = uploadDir + java.io.File.separator + fileName;

        // Save the file
        filePart.write(filePath);

        // Return the relative path to the file (for web access)
        return "/images/books/" + fileName;
    }
}