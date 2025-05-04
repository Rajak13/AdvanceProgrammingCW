package controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.json.JSONObject;

import dao.BookDAO;
import dao.CategoryDAO;
import dao.OrderDAO;
import dao.SuggestionDAO;
import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Book;
import model.Category;
import model.User;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookDAO bookDAO;
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private CategoryDAO categoryDAO;
    private SuggestionDAO suggestionDAO;

    @Override
    public void init() throws ServletException {
        try {
            bookDAO = new BookDAO();
            orderDAO = new OrderDAO();
            userDAO = new UserDAO();
            categoryDAO = new CategoryDAO();
            suggestionDAO = new SuggestionDAO();
        } catch (Exception e) {
            throw new ServletException("Error initializing DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/dashboard";
        }

        try {
            switch (action) {
                case "/dashboard":
                    showDashboard(request, response);
                    break;
                case "/books":
                    showBooks(request, response);
                    break;
                case "/categories":
                    showCategories(request, response);
                    break;
                case "/users":
                    showUsers(request, response);
                    break;
                case "/orders":
                    showOrders(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                case "/settings":
                    showSettings(request, response);
                    break;
                case "/new":
                    showNewBookForm(request, response);
                    break;
                case "/edit":
                    showEditBookForm(request, response);
                    break;
                case "/delete":
                    deleteBook(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (path) {
            case "/profile":
                updateProfile(request, response);
                break;
            case "/profile/picture":
                updateProfilePicture(request, response);
                break;
            case "/settings/update":
                updateSettings(request, response);
                break;
            case "/books":
                handleBookOperation(request, response);
                break;
            case "/users":
                handleUserOperation(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Check if user is logged in and is an admin
        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = request.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "/dashboard";
        }

        try {
            switch (path) {
                case "/users":
                    handleUserDelete(request, response);
                    break;
                case "/books":
                    handleBookDelete(request, response);
                    break;
                case "/categories":
                    handleCategoryDelete(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get dashboard statistics
            int totalBooks = bookDAO.getTotalBooks();
            int activeUsers = userDAO.getActiveUsersCount();
            int totalOrders = orderDAO.getTotalOrders();
            double totalRevenue = orderDAO.getTotalRevenue();

            // Get recent activities
            List<Map<String, Object>> recentActivities = bookDAO.getRecentActivities();

            // Set attributes
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("recentActivities", recentActivities);

            // Forward to dashboard JSP
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Check if we're fetching a single book
            String bookId = request.getParameter("bookId");
            if (bookId != null) {
                Book book = bookDAO.getBookById(Integer.parseInt(bookId));
                if (book != null) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"id\":" + book.getBookId() +
                            ",\"title\":\"" + book.getBookName() +
                            "\",\"author\":\"" + book.getWriterName() +
                            "\",\"price\":" + book.getPrice() +
                            ",\"coverImage\":\"" + book.getPicture() + "\"}");
                    return;
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                    return;
                }
            }

            // Get all books with pagination
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<Map<String, Object>> books = bookDAO.getAllBooks((page - 1) * recordsPerPage, recordsPerPage);
            int noOfRecords = bookDAO.getNoOfRecords();
            int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

            List<Map<String, Object>> categories = bookDAO.getAllCategories();
            request.setAttribute("categories", categories);

            request.setAttribute("books", books);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", page);

            request.getRequestDispatcher("/views/admin/books.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all categories
            List<Map<String, Object>> categories = bookDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/views/admin/categories.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userName = request.getParameter("userName");
            if (userName != null && !userName.isEmpty()) {
                try {
                    User user = userDAO.getUserByName(userName);
                    if (user != null) {
                        response.setContentType("application/json");
                        response.getWriter().write("{" +
                                "\"id\":" + user.getUserId() +
                                ",\"name\":\"" + user.getName() + "\"" +
                                ",\"email\":\"" + user.getEmail() + "\"" +
                                ",\"address\":\"" + (user.getAddress() != null ? user.getAddress() : "") + "\"" +
                                ",\"contact\":\"" + (user.getContact() != null ? user.getContact() : "") + "\"" +
                                ",\"role\":\"" + user.getRole() + "\"" +
                                ",\"picture\":\"" + (user.getPicture() != null ? user.getPicture() : "") + "\"" +
                                "}");
                        return;
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.setContentType("application/json");
                        response.getWriter().write("{\"error\":\"User not found\"}");
                        return;
                    }
                } catch (Exception e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.setContentType("application/json");
                    response.getWriter().write("{\"error\":\"Invalid user name\"}");
                    return;
                }
            }

            // Get all users with pagination
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<Map<String, Object>> users = userDAO.getAllUsers((page - 1) * recordsPerPage, recordsPerPage);
            int noOfRecords = userDAO.getNoOfRecords();
            int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

            request.setAttribute("users", users);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", page);

            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Server error\"}");
        }
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all orders with pagination
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }

            List<Map<String, Object>> orders = orderDAO.getAllOrders((page - 1) * recordsPerPage, recordsPerPage);
            int noOfRecords = orderDAO.getNoOfRecords();
            int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);

            request.setAttribute("orders", orders);
            request.setAttribute("noOfPages", noOfPages);
            request.setAttribute("currentPage", page);

            request.getRequestDispatcher("/views/admin/orders.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/views/admin/profile.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/views/admin/settings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showNewBookForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/book-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditBookForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Book book = bookDAO.getBookById(id);
            if (book == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            request.setAttribute("book", book);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/admin/book-form.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if (bookDAO.deleteBook(id)) {
                response.sendRedirect("books");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleUserOperation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String userId = request.getParameter("userId");

            if ("add".equals(action)) {
                // Create new user
                User newUser = new User();
                newUser.setName(request.getParameter("name"));
                newUser.setEmail(request.getParameter("email"));
                newUser.setPassword(request.getParameter("password"));
                newUser.setRole(request.getParameter("role"));
                newUser.setAddress(request.getParameter("address"));
                newUser.setContact(request.getParameter("contact"));

                // Handle profile picture upload
                Part filePart = request.getPart("picture");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = java.util.UUID.randomUUID().toString() + "_" + getFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("/uploads/user-pictures");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists())
                        uploadDir.mkdirs();
                    String filePath = uploadPath + java.io.File.separator + fileName;
                    filePart.write(filePath);
                    newUser.setPicture("uploads/user-pictures/" + fileName);
                }

                userDAO.createUser(newUser);
                response.setStatus(HttpServletResponse.SC_CREATED);
                response.getWriter().write("User created successfully");
            } else if ("edit".equals(action) && userId != null) {
                // Update existing user
                User existingUser = userDAO.getUserById(Integer.parseInt(userId));
                if (existingUser != null) {
                    existingUser.setName(request.getParameter("name"));
                    existingUser.setEmail(request.getParameter("email"));
                    existingUser.setRole(request.getParameter("role"));
                    existingUser.setAddress(request.getParameter("address"));
                    existingUser.setContact(request.getParameter("contact"));

                    // Only update password if provided
                    String newPassword = request.getParameter("password");
                    if (newPassword != null && !newPassword.isEmpty()) {
                        existingUser.setPassword(newPassword);
                    }

                    // Handle profile picture upload
                    Part filePart = request.getPart("picture");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = java.util.UUID.randomUUID().toString() + "_" + getFileName(filePart);
                        String uploadPath = getServletContext().getRealPath("/uploads/user-pictures");
                        java.io.File uploadDir = new java.io.File(uploadPath);
                        if (!uploadDir.exists())
                            uploadDir.mkdirs();
                        String filePath = uploadPath + java.io.File.separator + fileName;
                        filePart.write(filePath);
                        existingUser.setPicture("uploads/user-pictures/" + fileName);
                    }

                    userDAO.updateUser(existingUser);
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("User updated successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    private void handleUserDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userName = request.getParameter("userName");
            if (userName != null && !userName.trim().isEmpty()) {
                if (userDAO.deleteUserByName(userName)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("User deleted successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to delete user");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "User name is required");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleBookOperation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String bookId = request.getParameter("bookId");

            if ("add".equals(action)) {
                Book newBook = new Book();
                newBook.setBookName(request.getParameter("bookName"));
                newBook.setWriterName(request.getParameter("writerName"));
                newBook.setPrice(Double.parseDouble(request.getParameter("price")));
                newBook.setStatus(request.getParameter("status"));
                newBook.setStock(Integer.parseInt(request.getParameter("stock")));
                newBook.setDescription(request.getParameter("description"));

                // Handle book cover upload
                Part filePart = request.getPart("picture");
                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = java.util.UUID.randomUUID().toString() + "_" + getFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("/uploads/book-covers");
                    java.io.File uploadDir = new java.io.File(uploadPath);
                    if (!uploadDir.exists())
                        uploadDir.mkdirs();
                    String filePath = uploadPath + java.io.File.separator + fileName;
                    filePart.write(filePath);
                    newBook.setPicture("uploads/book-covers/" + fileName);
                }

                // Handle categories
                String[] categoryIds = request.getParameterValues("categories");
                List<Integer> selectedCategoryIds = new ArrayList<>();
                if (categoryIds != null) {
                    for (String categoryId : categoryIds) {
                        selectedCategoryIds.add(Integer.parseInt(categoryId));
                    }
                }

                if (bookDAO.createBook(newBook, selectedCategoryIds)) {
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    response.getWriter().write("Book created successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to create book");
                }
            } else if ("edit".equals(action) && bookId != null) {
                Book existingBook = bookDAO.getBookById(Integer.parseInt(bookId));
                if (existingBook != null) {
                    existingBook.setBookName(request.getParameter("bookName"));
                    existingBook.setWriterName(request.getParameter("writerName"));
                    existingBook.setPrice(Double.parseDouble(request.getParameter("price")));
                    existingBook.setStatus(request.getParameter("status"));
                    existingBook.setStock(Integer.parseInt(request.getParameter("stock")));
                    existingBook.setDescription(request.getParameter("description"));

                    // Handle book cover upload
                    Part filePart = request.getPart("picture");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = java.util.UUID.randomUUID().toString() + "_" + getFileName(filePart);
                        String uploadPath = getServletContext().getRealPath("/uploads/book-covers");
                        java.io.File uploadDir = new java.io.File(uploadPath);
                        if (!uploadDir.exists())
                            uploadDir.mkdirs();
                        String filePath = uploadPath + java.io.File.separator + fileName;
                        filePart.write(filePath);
                        existingBook.setPicture("uploads/book-covers/" + fileName);
                    }

                    // Handle categories
                    String[] categoryIds = request.getParameterValues("categories");
                    List<Integer> selectedCategoryIds = new ArrayList<>();
                    if (categoryIds != null) {
                        for (String categoryId : categoryIds) {
                            selectedCategoryIds.add(Integer.parseInt(categoryId));
                        }
                    }

                    bookDAO.updateBook(existingBook);
                    bookDAO.updateBookCategories(existingBook.getBookId(), selectedCategoryIds);
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Book updated successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleBookDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String bookId = request.getParameter("bookId");
            if (bookId != null) {
                if (bookDAO.deleteBook(Integer.parseInt(bookId))) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Book deleted successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to delete book");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is required");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleCategoryOperation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String categoryId = request.getParameter("categoryId");

            if ("add".equals(action)) {
                Category category = new Category();
                category.setCategoryName(request.getParameter("name"));
                category.setDescription(request.getParameter("description"));

                if (categoryDAO.createCategory(category)) {
                    response.setStatus(HttpServletResponse.SC_CREATED);
                    response.getWriter().write("Category created successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to create category");
                }
            } else if ("edit".equals(action) && categoryId != null) {
                Category category = new Category();
                category.setCategoryId(Integer.parseInt(categoryId));
                category.setCategoryName(request.getParameter("name"));
                category.setDescription(request.getParameter("description"));

                if (categoryDAO.updateCategory(category)) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Category updated successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to update category");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleCategoryDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String categoryId = request.getParameter("categoryId");
            if (categoryId != null) {
                if (categoryDAO.deleteCategory(Integer.parseInt(categoryId))) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Category deleted successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to delete category");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Category ID is required");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void handleSuggestionOperation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            String suggestionId = request.getParameter("suggestionId");

            if (suggestionId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Suggestion ID is required");
                return;
            }

            if ("approve".equals(action)) {
                if (suggestionDAO.approveSuggestion(Integer.parseInt(suggestionId))) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Suggestion approved successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to approve suggestion");
                }
            } else if ("reject".equals(action)) {
                if (suggestionDAO.rejectSuggestion(Integer.parseInt(suggestionId))) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("Suggestion rejected successfully");
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Failed to reject suggestion");
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void insertBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Book book = new Book();
            book.setBookName(request.getParameter("bookName"));
            book.setPrice(Double.parseDouble(request.getParameter("price")));
            book.setWriterName(request.getParameter("writerName"));
            book.setPicture(request.getParameter("picture"));

            if (bookDAO.createBook(book, new ArrayList<>())) {
                response.sendRedirect("books");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Book book = new Book();
            book.setBookId(Integer.parseInt(request.getParameter("id")));
            book.setBookName(request.getParameter("bookName"));
            book.setPrice(Double.parseDouble(request.getParameter("price")));
            book.setWriterName(request.getParameter("writerName"));
            book.setPicture(request.getParameter("picture"));

            if (bookDAO.updateBook(book)) {
                response.sendRedirect("books");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        try {
            orderDAO.updateOrderStatus(orderId, status);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect("orders");
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
                return;
            }

            // Parse JSON request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
            String json = jsonBuilder.toString();
            JSONObject jsonObject = new JSONObject(json);

            // Update user information
            user.setName(jsonObject.getString("name"));
            user.setEmail(jsonObject.getString("email"));
            user.setAddress(jsonObject.optString("address", user.getAddress()));
            user.setContact(jsonObject.optString("contact", user.getContact()));

            // Update password if provided
            String currentPassword = jsonObject.optString("currentPassword");
            String newPassword = jsonObject.optString("newPassword");
            String confirmPassword = jsonObject.optString("confirmPassword");

            if (currentPassword != null && !currentPassword.isEmpty() &&
                    newPassword != null && !newPassword.isEmpty() &&
                    confirmPassword != null && !confirmPassword.isEmpty()) {

                if (!user.getPassword().equals(currentPassword)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"Current password is incorrect\"}");
                    return;
                }

                if (!newPassword.equals(confirmPassword)) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"success\": false, \"message\": \"New passwords do not match\"}");
                    return;
                }

                user.setPassword(newPassword);
            }

            // Update user in database
            userDAO.updateUser(user);

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Profile updated successfully\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Error updating profile\"}");
        }
    }

    private void updateProfilePicture(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
                return;
            }

            Part filePart = request.getPart("picture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                String uploadPath = getServletContext().getRealPath("/uploads/user-pictures");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                user.setPicture("uploads/user-pictures/" + fileName);
                userDAO.updateUser(user);
            }

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Profile picture updated successfully\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Error updating profile picture\"}");
        }
    }

    private void updateSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.getRequestDispatcher("/views/admin/settings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}