package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    // Use Railway environment variables with fallback to local development values
    private static final String URL = buildDatabaseUrl();
    private static final String USER = System.getenv("DATABASE_USER") != null 
        ? System.getenv("DATABASE_USER") 
        : "root";
    private static final String PASSWORD = System.getenv("DATABASE_PASSWORD") != null 
        ? System.getenv("DATABASE_PASSWORD") 
        : "";

    private static String buildDatabaseUrl() {
        // Check if we're running on Railway (has MYSQL_URL)
        String railwayUrl = System.getenv("MYSQL_URL");
        if (railwayUrl != null) {
            // Convert Railway MySQL URL to JDBC format
            // From: mysql://root:password@mysql.railway.internal:3306/railway
            // To: jdbc:mysql://mysql.railway.internal:3306/railway?useSSL=true&serverTimezone=UTC
            return railwayUrl.replace("mysql://", "jdbc:mysql://") + "?useSSL=true&serverTimezone=UTC";
        }
        
        // Check for custom DATABASE_URL
        String customUrl = System.getenv("DATABASE_URL");
        if (customUrl != null) {
            return customUrl;
        }
        
        // Fallback to local development
        return "jdbc:mysql://localhost:3306/bookstore?useSSL=false&serverTimezone=UTC";
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            System.out.println("Attempting to connect to database: " + URL);
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Database connection failed!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}