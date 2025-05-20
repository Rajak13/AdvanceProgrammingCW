package listener;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.logging.Logger;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class MySQLContextListener implements ServletContextListener {
    private static final Logger logger = Logger.getLogger(MySQLContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("MySQL Context Listener initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("MySQL Context Listener destroyed");

        // Deregister JDBC drivers
        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
                logger.info("Deregistered JDBC driver: " + driver);
            } catch (SQLException e) {
                logger.warning("Error deregistering JDBC driver: " + e.getMessage());
            }
        }
    }
}