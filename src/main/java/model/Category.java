package model;

public class Category {
    private int categoryId;
    private String categoryName;
    private String description;
    private String slug; // URL-friendly version of the category name

    // Default constructor
    public Category() {
    }

    // Constructor with essential fields
    public Category(String categoryName) {
        this.categoryName = categoryName;
        this.slug = generateSlug(categoryName);
    }

    // Full constructor
    public Category(int categoryId, String categoryName, String description) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.description = description;
        this.slug = generateSlug(categoryName);
    }

    // Getters and setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
        this.slug = generateSlug(categoryName);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    // Helper method to generate URL slug from category name
    private String generateSlug(String name) {
        if (name == null)
            return "";
        return name.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-");
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", slug='" + slug + '\'' +
                '}';
    }
}