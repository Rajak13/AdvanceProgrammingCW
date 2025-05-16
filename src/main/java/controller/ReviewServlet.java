package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Review;
import model.User;

@WebServlet("/reviews/*")
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
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
                    listReviews(request, response);
                    break;
                case "/view":
                    viewReview(request, response);
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
                    createReview(request, response, user.getUserId());
                    break;
                case "/update":
                    updateReview(request, response, user.getUserId());
                    break;
                case "/delete":
                    deleteReview(request, response, user.getUserId());
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listReviews(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        request.setAttribute("reviews", reviewDAO.getBookReviews(bookId));
        request.getRequestDispatcher("/views/pages/review_list.jsp").forward(request, response);
    }

    private void viewReview(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int reviewId = Integer.parseInt(request.getParameter("id"));
        Review review = reviewDAO.getReview(reviewId);

        if (review == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("review", review);
        request.getRequestDispatcher("/reviews/view.jsp").forward(request, response);
    }

    private void createReview(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Review review = new Review();
        review.setUserId(userId);
        review.setBookId(bookId);
        review.setRating(rating);
        review.setComment(comment);
        review.setDate(new Timestamp(System.currentTimeMillis()));

        if (reviewDAO.createReview(review)) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId);
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create review");
        }
    }

    private void updateReview(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        int reviewId = Integer.parseInt(request.getParameter("id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        Review review = reviewDAO.getReview(reviewId);
        if (review == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (review.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        review.setRating(rating);
        review.setComment(comment);

        if (reviewDAO.updateReview(review)) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + review.getBookId());
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update review");
        }
    }

    private void deleteReview(HttpServletRequest request, HttpServletResponse response, int userId)
            throws SQLException, IOException {
        int reviewId = Integer.parseInt(request.getParameter("id"));

        Review review = reviewDAO.getReview(reviewId);
        if (review == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (review.getUserId() != userId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (reviewDAO.deleteReview(reviewId)) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + review.getBookId());
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete review");
        }
    }
}