package filters;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in and is admin
        boolean isAdmin = false;
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            isAdmin = user.isAdmin();
        }

        // Allow if admin, otherwise redirect to access denied page
        if (isAdmin) {
            chain.doFilter(request, response);
        } else {
            httpRequest.setAttribute("errorMessage", "You don't have permission to access the admin dashboard");
            httpRequest.getRequestDispatcher("/views/errors/access-denied.jsp").forward(httpRequest, httpResponse);
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}