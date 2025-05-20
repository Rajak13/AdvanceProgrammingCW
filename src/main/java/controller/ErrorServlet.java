package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/error")
public class ErrorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        String errorMessage = (String) request.getAttribute("jakarta.servlet.error.message");
        String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
        String servletName = (String) request.getAttribute("jakarta.servlet.error.servlet_name");
        Throwable throwable = (Throwable) request.getAttribute("jakarta.servlet.error.exception");

        request.setAttribute("statusCode", statusCode);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("requestUri", requestUri);
        request.setAttribute("servletName", servletName);
        request.setAttribute("throwable", throwable);

        request.getRequestDispatcher("/views/errors/error.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}