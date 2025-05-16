package filters;

import java.io.IOException;

import dao.UserDAO;
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

@WebFilter("/*")
public class AuthFilter implements Filter {
    private UserDAO userDAO;

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        System.out
                .println("Session: " + session + ", User: " + (session != null ? session.getAttribute("user") : null));

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        boolean isAuthResource = uri.contains("/css/") || uri.contains("/js/") ||
                uri.contains("/images/") || uri.contains("/fonts/");
        boolean isAuthPage = uri.startsWith(contextPath + "/auth");
        boolean isHomePage = uri.equals(contextPath + "/") || uri.equals(contextPath + "/home");
        boolean isAdminPage = uri.contains("/admin/");

        // Allow access to auth pages, home page, and static resources
        if (isLoggedIn || isAuthPage || isHomePage || isAuthResource) {
            chain.doFilter(request, response);
            return;
        }

        // Redirect to login if not logged in
        String accept = req.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");
            res.setStatus(HttpServletResponse.SC_FORBIDDEN);
            res.getWriter().write("{\"error\":\"Unauthorized access\"}");
        } else {
            res.sendRedirect(contextPath + "/auth");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDAO = new UserDAO();
    }

    public void destroy() {
    }
}