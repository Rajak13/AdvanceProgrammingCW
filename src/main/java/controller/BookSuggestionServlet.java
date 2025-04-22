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

@WebServlet("/suggest-book")
public class BookSuggestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String suggestedBook = request.getParameter("suggestedBook");
        String writer = request.getParameter("writer");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String email = request.getParameter("email");

        // Simple validation
        if (suggestedBook == null || suggestedBook.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please provide at least the book title and your email");

            // Set attributes for the page template
            request.setAttribute("pageTitle", "Contact Us");
            request.setAttribute("currentPage", "contact");
            request.setAttribute("mainContent", "/views/pages/contact.jsp");

            // Forward back to the form
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
            return;
        }

        try {
            // Create SuggestionBook object
            SuggestionBook suggestion = new SuggestionBook();
            suggestion.setSuggestedBook(suggestedBook);
            suggestion.setWriter(writer);
            suggestion.setCategory(category);
            suggestion.setDescription(description);

            // Get user ID if user is logged in
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                suggestion.setUserId(user.getUserId());
            }

            // Save suggestion to database
            SuggestionDAO suggestionDAO = new SuggestionDAO();
            boolean success = suggestionDAO.createSuggestion(suggestion, email);

            if (success) {
                request.setAttribute("successMessage",
                        "Thank you for your book suggestion! We'll consider adding it to our collection.");
            } else {
                request.setAttribute("errorMessage",
                        "Sorry, there was an error saving your suggestion. Please try again later.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again later.");
        }

        // Set attributes for the page template
        request.setAttribute("pageTitle", "Contact Us");
        request.setAttribute("currentPage", "contact");
        request.setAttribute("mainContent", "/views/pages/contact.jsp");

        // Forward back to the form
        request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
    }
}