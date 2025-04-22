package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({ "/", "/home" })
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set attributes for the page template
        request.setAttribute("pageTitle", "Home");
        request.setAttribute("currentPage", "home");
        request.setAttribute("mainContent", "/views/pages/home_content.jsp");

        // Forward to the page template
        request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
    }
}
