package utils;

public class StatusUtil {
    public static String getStatusClass(String status) {
        if (status == null)
            return "secondary";

        switch (status) {
            case "Pending":
                return "warning";
            case "Processing":
                return "info";
            case "Shipped":
                return "primary";
            case "Delivered":
                return "success";
            case "Cancelled":
                return "danger";
            default:
                return "secondary";
        }
    }
}