package controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String STORE_EMAIL = "bookstorepanna@gmail.com";

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
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Validate required fields
        if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                subject == null || subject.trim().isEmpty() ||
                message == null || message.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all required fields.");
            request.setAttribute("pageTitle", "Contact Us");
            request.setAttribute("currentPage", "contact");
            request.setAttribute("mainContent", "/views/pages/contact.jsp");
            request.getRequestDispatcher("/views/common/page_template.jsp").forward(request, response);
            return;
        }

        // Create email body
        String emailBody = String.format(
                "Name: %s\n" +
                        "Email: %s\n" +
                        "Phone: %s\n\n" +
                        "Message:\n%s",
                name, email, phone, message);

        // Encode the subject and body for the mailto URL
        String encodedSubject = URLEncoder.encode(subject, StandardCharsets.UTF_8.toString());
        String encodedBody = URLEncoder.encode(emailBody, StandardCharsets.UTF_8.toString());

        // Create mailto URL
        String mailtoUrl = String.format("mailto:%s?subject=%s&body=%s",
                STORE_EMAIL, encodedSubject, encodedBody);

        // Redirect to the mailto URL
        response.sendRedirect(mailtoUrl);
    }
}