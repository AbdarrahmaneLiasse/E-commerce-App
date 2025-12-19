import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SharedPreferencesHelper {
  static const String _tokenKey = 'jwt_token';
  static const String _roleKey = 'user_role';
  static const String _emailKey = 'user_email';
  static const String _userIdKey = 'user_id';
  static const String _sessionIdKey = 'session_id';

  /// Enregistre la session utilisateur (appelé après login)
  static Future<void> saveSession({
    required String token,
    required String role,
    required String email,
    required int userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_emailKey, email);
    await prefs.setInt(_userIdKey, userId);
  }

  /// Efface la session (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_sessionIdKey); // Nettoie aussi le sessionId visiteur
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// ⚡️ Retourne le sessionId visiteur, ou le crée si besoin
  static Future<String> getOrCreateSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString(_sessionIdKey);
    if (sessionId == null) {
      sessionId = const Uuid().v4(); // Génère un id unique !
      await prefs.setString(_sessionIdKey, sessionId);
    }
    return sessionId;
  }
}
