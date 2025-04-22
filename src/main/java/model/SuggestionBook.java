package model;

import java.util.Date;

public class SuggestionBook {
    private int suggestionId;
    private String suggestedBook;
    private String category;
    private String writer;
    private String description;
    private Date date;
    private Integer userId; // Can be null if suggestion from non-registered user

    // Default constructor
    public SuggestionBook() {
        this.date = new Date();
    }

    // Constructor with essential fields
    public SuggestionBook(String suggestedBook, String category, String writer) {
        this.suggestedBook = suggestedBook;
        this.category = category;
        this.writer = writer;
        this.date = new Date();
    }

    // Full constructor
    public SuggestionBook(int suggestionId, String suggestedBook, String category, String writer,
            String description, Date date, Integer userId) {
        this.suggestionId = suggestionId;
        this.suggestedBook = suggestedBook;
        this.category = category;
        this.writer = writer;
        this.description = description;
        this.date = date;
        this.userId = userId;
    }

    // Getters and setters
    public int getSuggestionId() {
        return suggestionId;
    }

    public void setSuggestionId(int suggestionId) {
        this.suggestionId = suggestionId;
    }

    public String getSuggestedBook() {
        return suggestedBook;
    }

    public void setSuggestedBook(String suggestedBook) {
        this.suggestedBook = suggestedBook;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getWriter() {
        return writer;
    }

    public void setWriter(String writer) {
        this.writer = writer;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "SuggestionBook{" +
                "suggestionId=" + suggestionId +
                ", suggestedBook='" + suggestedBook + '\'' +
                ", category='" + category + '\'' +
                ", writer='" + writer + '\'' +
                ", date=" + date +
                '}';
    }
}