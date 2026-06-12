import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/models/user_model.dart';

/// Local storage for the JWT access token and cached user profile.
/// Handles save / read / clear of both token and user data in SharedPreferences.
class AuthStorageService {
  static const _tokenKey = 'access_token';
  static const _userKey = 'cached_user';

  // ── Token ──────────────────────────────────────────────────────

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── Cached User Profile (offline support) ──────────────────────

  /// Save the user profile as JSON so it's available when offline.
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  /// Load the cached user profile from local storage.
  /// Returns `null` if nothing has been cached yet.
  static Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  /// Remove cached user profile (e.g., on logout or account deletion).
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // ── User ID (convenience) ───────────────────────────────────────

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Clear all auth-related data (token + cached user + user ID).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove('user_id');
  }
}
