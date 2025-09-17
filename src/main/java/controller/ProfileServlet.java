package controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Logger;

import dao.UserDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.User;

@WebServlet("/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class ProfileServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/profile-pictures";
    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());
    private String persistentUploadPath;

    @Override
    public void init() throws ServletException {
        super.init();
        // Set up persistent upload directory within the project
        String projectPath = System.getProperty("catalina.base");
        persistentUploadPath = projectPath + File.separator + "wtpwebapps" + File.separator + "BookStore"
                + File.separator + UPLOAD_DIR;
        logger.info("Initializing persistent upload directory at: " + persistentUploadPath);

        // Create the upload directory if it doesn't exist
        File uploadDir = new File(persistentUploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            logger.info("Created persistent upload directory: " + created);
            if (!created) {
                logger.severe("Failed to create upload directory at: " + persistentUploadPath);
            }
        }

        // Verify the directory is writable
        if (!uploadDir.canWrite()) {
            logger.severe("Upload directory is not writable: " + persistentUploadPath);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/views/pages/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            // Get form parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");

            // Update user information
            user.setName(name);
            user.setEmail(email);
            user.setContact(phone);
            user.setAddress(address);

            // Handle profile picture upload
            Part filePart = request.getPart("picture");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
                logger.info("Processing file upload: " + fileName);

                // Save the file to persistent storage
                String filePath = persistentUploadPath + File.separator + fileName;
                logger.info("Saving file to: " + filePath);

                // Ensure the directory exists before writing
                File uploadDir = new File(persistentUploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                // Write the file
                filePart.write(filePath);

                // Verify the file was written
                File savedFile = new File(filePath);
                if (!savedFile.exists()) {
                    throw new IOException("Failed to save file: " + filePath);
                }
                logger.info("File saved successfully: " + savedFile.getAbsolutePath());

                // Set the relative path for the database (without leading slash)
                String relativePath = UPLOAD_DIR + "/" + fileName;
                logger.info("Setting relative path in database: " + relativePath);
                user.setPicture(relativePath);
            }

            // Update user in database
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUser(user);
            logger.info("User update success: " + success);

            if (success) {
                session.setAttribute("user", user);
                request.setAttribute("successMessage", "Profile updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
            }
        } catch (Exception e) {
            logger.severe("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating your profile: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/pages/profile.jsp").forward(request, response);
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] elements = contentDisposition.split(";");
        for (String element : elements) {
            if (element.trim().startsWith("filename")) {
                return element.substring(element.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }
}