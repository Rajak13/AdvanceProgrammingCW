package model;

import java.sql.Timestamp;

public class SuggestionBook {
    private int suggestionId;
    private int userId;
    private String title;
    private String author;
    private String category;
    private String description;
    private String status;
    private Timestamp date;

    public SuggestionBook() {
    }

    public int getSuggestionId() {
        return suggestionId;
    }

    public void setSuggestionId(int suggestionId) {
        this.suggestionId = suggestionId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "SuggestionBook [suggestionId=" + suggestionId + ", userId=" + userId + ", title=" + title 
            + ", author=" + author + ", category=" + category + ", description=" + description 
            + ", status=" + status + ", date=" + date + "]";
    }
}