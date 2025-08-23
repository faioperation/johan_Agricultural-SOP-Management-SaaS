import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static String? accessToken;
  static String? refreshToken;
  static String? userRole;
  static String? userId;   // ✅ ADD THIS

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _roleKey = 'user_role';
  static const _userIdKey = 'user_id';  // ✅ ADD THIS

  static bool get isLoggedIn => accessToken != null;
  static bool get isManager => userRole == 'MANAGER';
  static bool get isEmployee => userRole == 'EMPLOYEE';

  /// 🔹 Load tokens on app start
  static Future<void> loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessKey);
    refreshToken = prefs.getString(_refreshKey);
    userRole = prefs.getString(_roleKey);
    userId = prefs.getString(_userIdKey); // ✅ LOAD
  }

  /// 🔹 Save tokens and role after login
  static Future<void> saveTokens({
    required String access,
    String? refresh,
    String? role,
    String? id,     // ✅ ADD THIS
  }) async {
    accessToken = access;
    if (refresh != null) refreshToken = refresh;
    if (role != null) userRole = role;
    if (id != null) userId = id;  // ✅ SET

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, access);
    if (refresh != null) {
      await prefs.setString(_refreshKey, refresh);
    }
    if (role != null) {
      await prefs.setString(_roleKey, role);
    }
    if (id != null) {
      await prefs.setString(_userIdKey, id); // ✅ SAVE
    }
  }

  /// 🔹 Clear on logout
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = null;
    refreshToken = null;
    userRole = null;
    userId = null;  // ✅ CLEAR

    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey); // ✅ REMOVE
  }
}
