package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class DatabaseInitializer {
    private static final Logger logger = Logger.getLogger(DatabaseInitializer.class.getName());
    private static boolean initialized = false;

    public static synchronized void initialize() {
        if (initialized) {
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            logger.info("Checking database initialization...");
            
            if (!tablesExist(conn)) {
                logger.info("Tables not found. Initializing database schema...");
                runSchemaScript(conn);
                insertSampleData(conn);
                logger.info("Database initialization completed successfully!");
            } else {
                logger.info("Database tables already exist. Skipping initialization.");
            }
            
            initialized = true;
        } catch (SQLException e) {
            logger.severe("Database initialization failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static boolean tablesExist(Connection conn) throws SQLException {
        DatabaseMetaData metaData = conn.getMetaData();
        
        // Check for key tables
        String[] requiredTables = {"user", "book", "category", "cart", "order"};
        
        for (String tableName : requiredTables) {
            try (ResultSet rs = metaData.getTables(null, null, tableName, new String[]{"TABLE"})) {
                if (!rs.next()) {
                    logger.info("Table '" + tableName + "' not found.");
                    return false;
                }
            }
        }
        
        logger.info("All required tables exist.");
        return true;
    }

    private static void runSchemaScript(Connection conn) throws SQLException {
        List<String> sqlStatements = readSchemaFile();
        
        try (Statement stmt = conn.createStatement()) {
            for (String sql : sqlStatements) {
                if (!sql.trim().isEmpty() && !sql.trim().startsWith("--")) {
                    logger.info("Executing: " + sql.substring(0, Math.min(sql.length(), 50)) + "...");
                    stmt.execute(sql);
                }
            }
        }
    }

    private static List<String> readSchemaFile() {
        List<String> statements = new ArrayList<>();
        
        try (InputStream is = DatabaseInitializer.class.getClassLoader().getResourceAsStream("schema.sql");
             BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            
            StringBuilder currentStatement = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                
                // Skip comments and empty lines
                if (line.isEmpty() || line.startsWith("--")) {
                    continue;
                }
                
                // Skip CREATE DATABASE and USE statements (Railway handles this)
                if (line.toUpperCase().startsWith("CREATE DATABASE") || 
                    line.toUpperCase().startsWith("USE ")) {
                    continue;
                }
                
                currentStatement.append(line).append(" ");
                
                // If line ends with semicolon, we have a complete statement
                if (line.endsWith(";")) {
                    statements.add(currentStatement.toString().trim());
                    currentStatement = new StringBuilder();
                }
            }
            
        } catch (IOException e) {
            logger.severe("Failed to read schema.sql: " + e.getMessage());
            e.printStackTrace();
        }
        
        return statements;
    }

    private static void insertSampleData(Connection conn) throws SQLException {
        logger.info("Inserting sample data...");
        
        try (Statement stmt = conn.createStatement()) {
            // Insert sample categories
            stmt.execute("INSERT INTO category (category_name, description) VALUES " +
                "('Fiction', 'Fictional books and novels'), " +
                "('Non-Fiction', 'Educational and factual books'), " +
                "('Science', 'Science and technology books'), " +
                "('History', 'Historical books and biographies')");
            
            // Insert sample admin user (password: admin123)
            stmt.execute("INSERT INTO user (name, email, password, role, address, contact) VALUES " +
                "('Admin User', 'admin@bookstore.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', '123 Admin St', '+1234567890')");
            
            // Insert sample books
            stmt.execute("INSERT INTO book (Book_name, price, writer_name, description, stock, status) VALUES " +
                "('The Great Gatsby', 12.99, 'F. Scott Fitzgerald', 'A classic American novel', 50, 'New'), " +
                "('To Kill a Mockingbird', 14.99, 'Harper Lee', 'A gripping tale of racial injustice', 30, 'New'), " +
                "('1984', 13.99, 'George Orwell', 'A dystopian social science fiction novel', 40, 'New'), " +
                "('Pride and Prejudice', 11.99, 'Jane Austen', 'A romantic novel of manners', 25, 'New')");
            
            logger.info("Sample data inserted successfully!");
        }
    }
}