package controller;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get the session before invalidating it for logging
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object user = session.getAttribute("user");
                logger.log(Level.INFO, "Logging out user: {0}", user);

                // Invalidate the session
                session.invalidate();
                logger.log(Level.INFO, "Session invalidated");
            }

            // Clear the remember me cookie
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUser".equals(cookie.getName())) {
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        cookie.setDomain(request.getServerName());
                        cookie.setSecure(request.isSecure());
                        cookie.setHttpOnly(true);
                        response.addCookie(cookie);
                        logger.log(Level.INFO, "Remember me cookie cleared");
                        break;
                    }
                }
            }

            // Redirect to login page
            String loginUrl = request.getContextPath() + "/auth/login";
            logger.log(Level.INFO, "Redirecting to: {0}", loginUrl);
            response.sendRedirect(loginUrl);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during logout", e);
            // Redirect to login page even if there's an error
            response.sendRedirect(request.getContextPath() + "/auth/login");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}