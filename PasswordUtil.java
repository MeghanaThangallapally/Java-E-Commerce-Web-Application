package com.shopflow.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {

    private static final int SALT_LENGTH = 16;

    /** Hash a plain-text password with a random salt (SHA-256). */
    public static String hashPassword(String plainPassword) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(plainPassword.getBytes());

            String saltB64  = Base64.getEncoder().encodeToString(salt);
            String hashB64  = Base64.getEncoder().encodeToString(hashed);
            return saltB64 + ":" + hashB64;

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /** Verify a plain-text password against a stored salt:hash string. */
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        try {
            String[] parts = storedHash.split(":");
            if (parts.length != 2) return false;

            byte[] salt   = Base64.getDecoder().decode(parts[0]);
            byte[] stored = Base64.getDecoder().decode(parts[1]);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] computed = md.digest(plainPassword.getBytes());

            if (computed.length != stored.length) return false;
            int diff = 0;
            for (int i = 0; i < computed.length; i++) diff |= computed[i] ^ stored[i];
            return diff == 0;

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
