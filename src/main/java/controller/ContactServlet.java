package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set attributes for the page template
        request.setAttribute("pageTitle", "Contact Us");
        request.setAttribute("currentPage", "contact");
        request.setAttribute("mainContent", "/views/pages/contact.jsp");

        // Forward to the page template
        request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        // Here you would typically save the contact form data to a database
        // For now, we'll just redirect to a thank you page
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("message", message);

        request.getRequestDispatcher("/views/contact/thankyou.jsp").forward(request, response);
    }
}