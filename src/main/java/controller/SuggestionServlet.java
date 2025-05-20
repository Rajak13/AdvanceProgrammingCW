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

@WebServlet("/suggestions/*")
public class SuggestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SuggestionDAO suggestionDAO;

    public void init() {
        suggestionDAO = new SuggestionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            switch (action) {
                case "/list":
                    if ("admin".equals(user.getRole())) {
                        listAllSuggestions(request, response);
                    } else {
                        listUserSuggestions(request, response, user.getUserId());
                    }
                    break;
                case "/view":
                    viewSuggestion(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();
        if (action == null) {
            action = "/create";
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        try {
            switch (action) {
                case "/create":
                    createSuggestion(request, response, user.getUserId());
                    break;
                case "/update":
                    if ("admin".equals(user.getRole())) {
                        updateSuggestion(request, response);
                    } else {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                    }
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listAllSuggestions(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        request.setAttribute("suggestions", suggestionDAO.getAllSuggestions());
        request.getRequestDispatcher("/suggestions/list.jsp").forward(request, response);
    }

    private void listUserSuggestions(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, ServletException, IOException {
        request.setAttribute("suggestions", suggestionDAO.getUserSuggestions(userId));
        request.getRequestDispatcher("/suggestions/list.jsp").forward(request, response);
    }

    private void viewSuggestion(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int suggestionId = Integer.parseInt(request.getParameter("id"));
        SuggestionBook suggestion = suggestionDAO.getSuggestion(suggestionId);

        if (suggestion == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("suggestion", suggestion);
        request.getRequestDispatcher("/suggestions/view.jsp").forward(request, response);
    }

    private void createSuggestion(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String description = request.getParameter("description");

        SuggestionBook suggestion = new SuggestionBook();
        suggestion.setUserId(userId);
        suggestion.setTitle(title);
        suggestion.setAuthor(author);
        suggestion.setDescription(description);
        suggestion.setStatus("pending");

        if (suggestionDAO.createSuggestion(suggestion)) {
            response.sendRedirect(request.getContextPath() + "/suggestions/list");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create suggestion");
        }
    }

    private void updateSuggestion(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int suggestionId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        SuggestionBook suggestion = suggestionDAO.getSuggestion(suggestionId);
        if (suggestion == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        suggestion.setStatus(status);
        if (suggestionDAO.updateSuggestion(suggestion)) {
            response.sendRedirect(request.getContextPath() + "/suggestions/view?id=" + suggestionId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update suggestion");
        }
    }
}