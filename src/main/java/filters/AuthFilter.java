package filters;

import java.io.IOException;
import java.sql.SQLException;

import dao.UserDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        boolean isLoggedIn = session != null && session.getAttribute("user") != null;
        boolean isAuthResource = uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/");
        boolean isAuthPage = uri.equals(contextPath + "/auth") ||
                uri.equals(contextPath + "/login") ||
                uri.equals(contextPath + "/register");
        boolean isHomePage = uri.equals(contextPath + "/") ||
                uri.equals(contextPath + "/views/pages/home.jsp");

        // Check for "Remember Me" cookie if not logged in
        if (!isLoggedIn && !isAuthResource) {
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        String username = cookie.getValue();
                        try {
                            UserDAO userDAO = new UserDAO();
                            User user = userDAO.getUserByUsername(username);
                            if (user != null) {
                                // Auto-login the user
                                session = req.getSession(true);
                                session.setAttribute("user", user);
                                isLoggedIn = true;
                                break;
                            }
                        } catch (SQLException e) {
                            // Log the error but continue without auto-login
                            System.err.println("Error during cookie authentication: " + e.getMessage());
                        }
                    }
                }
            }
        }

        if (isAuthResource) {
            // Always allow CSS, JS, and image resources
            chain.doFilter(request, response);
        } else if (isLoggedIn) {
            // If user is logged in, allow access to all pages
            chain.doFilter(request, response);
        } else if (isAuthPage) {
            // If user is not logged in and trying to access auth pages, allow it
            chain.doFilter(request, response);
        } else if (isHomePage) {
            // If user is not logged in and trying to access home page, redirect to auth
            res.sendRedirect(contextPath + "/auth");
        } else {
            // For all other pages, when not logged in, redirect to auth
            res.sendRedirect(contextPath + "/auth");
        }
    }

    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void destroy() {
    }
}