package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DatabaseInitializer;

@WebServlet(value = "/init-db", loadOnStartup = 1)
public class DatabaseInitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("=== DATABASE INITIALIZATION STARTING ===");
        
        try {
            // Test database connection first
            System.out.println("Testing database connection...");
            utils.DBUtil.getConnection().close();
            System.out.println("Database connection successful!");
            
            // Initialize database
            DatabaseInitializer.initialize();
            System.out.println("=== DATABASE INITIALIZATION COMPLETED ===");
            
        } catch (Exception e) {
            System.err.println("=== DATABASE INITIALIZATION FAILED ===");
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            
            // Don't throw exception - let app start anyway
            System.err.println("Application will continue without database...");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"status\":\"Database initialized\"}");
    }
}