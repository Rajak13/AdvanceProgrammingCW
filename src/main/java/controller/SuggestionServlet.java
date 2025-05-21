package controller;

import java.io.IOException;
import java.sql.SQLException;

import dao.SuggestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SuggestionBook;
import model.User;

@WebServlet("/suggest-book/*")
public class SuggestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SuggestionDAO suggestionDAO;

    public void init() {
        suggestionDAO = new SuggestionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Show suggestion form
            request.setAttribute("pageTitle", "Suggest a Book");
            request.setAttribute("currentPage", "suggest");
            request.setAttribute("mainContent", "/views/pages/suggest.jsp");
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
        } else if (pathInfo.matches("/\\d+")) {
            // Get suggestion details for admin
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null || !"ADMIN".equals(user.getRole())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            try {
                int suggestionId = Integer.parseInt(pathInfo.substring(1));
                SuggestionBook suggestion = suggestionDAO.getSuggestion(suggestionId);
                if (suggestion != null) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(new com.google.gson.Gson().toJson(suggestion));
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Suggestion not found");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading suggestion details");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Handle new suggestion submission
            handleNewSuggestion(request, response);
        } else if (pathInfo.equals("/update")) {
            // Handle status update
            handleStatusUpdate(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleNewSuggestion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String suggestedBook = request.getParameter("suggestedBook");
        String writer = request.getParameter("writer");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        // Validate required fields
        if (suggestedBook == null || suggestedBook.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Book title is required.");
            request.setAttribute("pageTitle", "Suggest a Book");
            request.setAttribute("currentPage", "suggest");
            request.setAttribute("mainContent", "/views/pages/suggest.jsp");
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
            return;
        }

        try {
            // Create new suggestion
            SuggestionBook suggestion = new SuggestionBook();
            suggestion.setTitle(suggestedBook);
            suggestion.setAuthor(writer);
            suggestion.setCategory(category);
            suggestion.setDescription(description);
            suggestion.setStatus("Pending"); // Set initial status

            // Get user ID if logged in, otherwise set to 0 for anonymous suggestions
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user != null) {
                suggestion.setUserId(user.getUserId());
            } else {
                suggestion.setUserId(0); // Anonymous suggestion
            }

            if (suggestionDAO.createSuggestion(suggestion)) {
                request.setAttribute("successMessage", "Thank you for your book suggestion! We'll review it soon.");
            } else {
                request.setAttribute("errorMessage",
                        "Sorry, there was an error submitting your suggestion. Please try again later.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                    "Sorry, there was an error submitting your suggestion. Please try again later.");
        }

        // Set attributes for the page template
        request.setAttribute("pageTitle", "Suggest a Book");
        request.setAttribute("currentPage", "suggest");
        request.setAttribute("mainContent", "/views/pages/suggest.jsp");
        request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
    }

    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            int suggestionId = Integer.parseInt(request.getParameter("suggestionId"));
            String status = request.getParameter("status");

            SuggestionBook suggestion = suggestionDAO.getSuggestion(suggestionId);
            if (suggestion == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Suggestion not found");
                return;
            }

            suggestion.setStatus(status);
            if (suggestionDAO.updateSuggestion(suggestion)) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\":true,\"message\":\"Status updated successfully\"}");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update suggestion status");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating suggestion");
        }
    }
}