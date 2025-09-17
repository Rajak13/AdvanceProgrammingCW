package filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.User;

@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Allow normal users to POST to /admin/orders for order creation
        String method = httpRequest.getMethod();
        String uri = httpRequest.getRequestURI();
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                // User is an admin, allow access
                chain.doFilter(request, response);
                return;
            } else if ("POST".equalsIgnoreCase(method) && uri.endsWith("/admin/orders")) {
                // Allow normal users to place orders
                chain.doFilter(request, response);
                return;
            }
        }

        // User is not logged in or is not an admin, show access denied
        String accept = httpRequest.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            httpResponse.setContentType("application/json");
            httpResponse.setCharacterEncoding("UTF-8");
            httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            httpResponse.getWriter().write("{\"error\":\"Unauthorized access\"}");
        } else {
            httpRequest.getRequestDispatcher("/views/errors/access-denied.jsp").forward(httpRequest, httpResponse);
        }
    }
}