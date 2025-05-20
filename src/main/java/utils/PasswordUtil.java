package utils;

import java.security.SecureRandom;
import java.util.Base64;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    private static final SecureRandom SECURE_RANDOM = new SecureRandom();

    public static String hashPassword(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(12)); // Using work factor of 12
    }

    public static boolean checkPassword(String plainText, String hashed) {
        if (plainText == null || hashed == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainText, hashed);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Generates a secure random token (can be used for reset tokens, API keys,
     * etc.)
     * 
     * @param length The length of the token in bytes
     * @return Base64 encoded random token
     */
    public static String generateSecureToken(int length) {
        byte[] token = new byte[length];
        SECURE_RANDOM.nextBytes(token);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(token);
    }
}