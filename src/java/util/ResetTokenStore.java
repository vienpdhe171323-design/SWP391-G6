package util;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class ResetTokenStore {
    private static final Map<String, TokenEntry> tokens = new ConcurrentHashMap<>();

    public static void save(String token, String email) {
        tokens.put(token, new TokenEntry(email, System.currentTimeMillis()));
    }

    public static String getEmail(String token) {
        TokenEntry entry = tokens.get(token);
        if (entry == null) return null;
        if (System.currentTimeMillis() - entry.time > 15 * 60 * 1000) {
            tokens.remove(token);
            return null;
        }
        return entry.email;
    }

    public static void remove(String token) {
        tokens.remove(token);
    }

    private static class TokenEntry {
        String email;
        long time;
        TokenEntry(String email, long time) {
            this.email = email;
            this.time = time;
        }
    }
}
