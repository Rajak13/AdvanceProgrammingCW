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
            System.out.println("=== DATABASE CONNECTION ATTEMPT ===");
            System.out.println("URL: " + URL);
            System.out.println("User: " + USER);
            System.out.println("Password length: " + (PASSWORD != null ? PASSWORD.length() : 0));
            
            // Check environment variables
            System.out.println("MYSQL_URL env: " + (System.getenv("MYSQL_URL") != null ? "SET" : "NOT SET"));
            System.out.println("DATABASE_URL env: " + (System.getenv("DATABASE_URL") != null ? "SET" : "NOT SET"));
            
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connection successful!");
            return conn;
        } catch (SQLException e) {
            System.err.println("=== DATABASE CONNECTION FAILED ===");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("SQLException: " + e.getMessage());
            System.err.println("SQLState: " + e.getSQLState());
            System.err.println("ErrorCode: " + e.getErrorCode());
            e.printStackTrace();
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