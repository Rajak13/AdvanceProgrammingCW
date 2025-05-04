package model;

import java.sql.Timestamp;

public class SuggestionBook {
    private int suggestionId;
    private String suggestedBook;
    private String category;
    private String writer;
    private String description;
    private Timestamp date;
    private int userId;

    public SuggestionBook() {
    }

    public SuggestionBook(int suggestionId, String suggestedBook, String category, String writer, String description,
            Timestamp date, int userId) {
        this.suggestionId = suggestionId;
        this.suggestedBook = suggestedBook;
        this.category = category;
        this.writer = writer;
        this.description = description;
        this.date = date;
        this.userId = userId;
    }

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

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "SuggestionBook [suggestionId=" + suggestionId + ", suggestedBook=" + suggestedBook + ", category="
                + category + ", writer=" + writer + ", description=" + description + ", date=" + date + ", userId="
                + userId + "]";
    }
}