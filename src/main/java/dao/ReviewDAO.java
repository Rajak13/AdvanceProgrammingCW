package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Review;
import utils.DBUtil;

public class ReviewDAO {
    private static final String GET_REVIEW = "SELECT * FROM review WHERE Review_id = ?";
    private static final String GET_BOOK_REVIEWS = "SELECT * FROM review WHERE Book_id = ? ORDER BY date DESC";
    private static final String CREATE_REVIEW = "INSERT INTO review (User_id, Book_id, rating, comment, date) VALUES (?, ?, ?, ?, ?)";
    private static final String UPDATE_REVIEW = "UPDATE review SET rating = ?, comment = ? WHERE Review_id = ?";
    private static final String DELETE_REVIEW = "DELETE FROM review WHERE Review_id = ?";

    public Review getReview(int reviewId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_REVIEW)) {
            stmt.setInt(1, reviewId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getInt("Review_id"));
                    review.setUserId(rs.getInt("User_id"));
                    review.setBookId(rs.getInt("Book_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setDate(rs.getTimestamp("date"));
                    return review;
                }
            }
        }
        return null;
    }

    public List<Review> getBookReviews(int bookId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(GET_BOOK_REVIEWS)) {
            stmt.setInt(1, bookId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getInt("Review_id"));
                    review.setUserId(rs.getInt("User_id"));
                    review.setBookId(rs.getInt("Book_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setDate(rs.getTimestamp("date"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public boolean createReview(Review review) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(CREATE_REVIEW)) {
            stmt.setInt(1, review.getUserId());
            stmt.setInt(2, review.getBookId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.setTimestamp(5, review.getDate());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateReview(Review review) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(UPDATE_REVIEW)) {
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setInt(3, review.getReviewId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(DELETE_REVIEW)) {
            stmt.setInt(1, reviewId);
            return stmt.executeUpdate() > 0;
        }
    }
}