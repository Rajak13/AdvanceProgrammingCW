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
    private UserDAO userDAO;

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
                uri.equals(contextPath + "/auth/login") ||
                uri.equals(contextPath + "/auth/register");
        boolean isHomePage = uri.equals(contextPath + "/") ||
                uri.equals(contextPath + "/views/pages/home.jsp");
        boolean isAdminPage = uri.contains("/views/admin/");

        // Check for "Remember Me" cookie if not logged in
        if (!isLoggedIn && !isAuthResource) {
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        String username = cookie.getValue();
                        try {
                            User user = userDAO.getUserByUsername(username);
                            if (user != null) {
                                session = req.getSession(true);
                                session.setAttribute("user", user);
                                isLoggedIn = true;
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        // Allow access to auth pages and home page for non-logged-in users
        if (!isLoggedIn && (isAuthPage || isHomePage || isAuthResource)) {
            chain.doFilter(request, response);
            return;
        }

        // Redirect to login if not logged in
        if (!isLoggedIn) {
            res.sendRedirect(contextPath + "/auth");
            return;
        }

        // Check admin access
        User user = (User) session.getAttribute("user");
        if (isAdminPage && !user.isAdmin()) {
            res.sendRedirect(contextPath + "/views/pages/home.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDAO = new UserDAO();
    }

    public void destroy() {
    }
}