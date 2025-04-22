package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

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

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Simple validation
        if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                subject == null || subject.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Please fill all required fields");

            // Set attributes for the page template
            request.setAttribute("pageTitle", "Contact Us");
            request.setAttribute("currentPage", "contact");
            request.setAttribute("mainContent", "/views/pages/contact.jsp");

            // Forward back to the form
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
            return;
        }

        try {
            // In a real application, you would:
            // 1. Save the message to a database
            // 2. Send an email notification
            // 3. Use more robust validation

            // For simplicity, we'll just show a success message
            request.setAttribute("successMessage", "Thank you for contacting us! We will get back to you soon.");

            // Set attributes for the page template
            request.setAttribute("pageTitle", "Contact Us");
            request.setAttribute("currentPage", "contact");
            request.setAttribute("mainContent", "/views/pages/contact.jsp");

            // Forward back to the form
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", "There was an error processing your request. Please try again later.");

            // Set attributes for the page template
            request.setAttribute("pageTitle", "Contact Us");
            request.setAttribute("currentPage", "contact");
            request.setAttribute("mainContent", "/views/pages/contact.jsp");

            // Forward back to the form
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
        }
    }
}