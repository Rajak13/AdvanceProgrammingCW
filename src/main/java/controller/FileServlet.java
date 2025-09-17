package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/files/*")
public class FileServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(FileServlet.class.getName());
    private String persistentUploadPath;

    @Override
    public void init() throws ServletException {
        super.init();
        String projectPath = System.getProperty("catalina.base");
        persistentUploadPath = projectPath + File.separator + "wtpwebapps" + File.separator + "BookStore";
        logger.info("Initializing FileServlet with upload path: " + persistentUploadPath);

        // Verify the base directory exists
        File baseDir = new File(persistentUploadPath);
        if (!baseDir.exists()) {
            logger.severe("Base directory does not exist: " + persistentUploadPath);
        } else if (!baseDir.canRead()) {
            logger.severe("Base directory is not readable: " + persistentUploadPath);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Remove leading slash and normalize path
        String relativePath = pathInfo.substring(1).replace('/', File.separatorChar);
        File file = new File(persistentUploadPath, relativePath);
        logger.info("Attempting to serve file: " + file.getAbsolutePath());

        // Verify file exists and is readable
        if (!file.exists()) {
            logger.warning("File not found: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (!file.canRead()) {
            logger.warning("File is not readable: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Set content type based on file extension
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLength((int) file.length());

        // Stream the file
        try (FileInputStream in = new FileInputStream(file);
                OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            logger.info("Successfully served file: " + file.getAbsolutePath());
        } catch (IOException e) {
            logger.severe("Error serving file: " + e.getMessage());
            throw e;
        }
    }
}