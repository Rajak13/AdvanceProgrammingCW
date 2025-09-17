package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Test database connection
            utils.DBUtil.getConnection().close();
            response.getWriter().write("{\"status\":\"healthy\",\"database\":\"connected\"}");
        } catch (Exception e) {
            response.getWriter().write("{\"status\":\"healthy\",\"database\":\"disconnected\",\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}