import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constant.dart';
import '../core/network.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository {
  final _client = http.Client();

  Future<bool> checkEmail(String email) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/check-email');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true;
    } else {
      throw Exception('Failed to check email');
    }
  }

  Future<bool> verifyPassword(String email, String password) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true;
    } else {
      throw Exception('Failed to verify password');
    }
  }

  // ✅ This is the universal register: handles logo (cooperative) or not (normal user)
  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String nom,
    required String telephone,
    required String adresse,
    File? logoFile, // null for normal user
  }) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/register');

    if (logoFile == null) {
      // Normal user: send JSON only

      final body = jsonEncode({
        "email": email,
        "password": password,
        "role": role,
        "nom": nom,
        "telephone": telephone,
        "adresse": adresse,
      });
      print('REGISTER JSON BODY: $body');
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode != 200) {
        throw Exception('Registration failed: ${response.body}');
      }
    } else {
      // Cooperative: send multipart with logo file
      var request = http.MultipartRequest(
  'POST',
  Uri.parse('${AppConstants.baseUrl}/auth/register-with-logo'),
);

request.fields['user'] = jsonEncode({
  "email": email,
  "password": password,
  "role": role,
  "nom": nom,
  "telephone": telephone,
  "adresse": adresse,
});

request.files.add(
  await http.MultipartFile.fromPath('logo', logoFile.path),
);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Registration failed: ${response.body}');
      }
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('${AppConstants.baseUrl}/auth/login');
    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['token'] != null) {
      // Save token for future use
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', data['token']);
      await prefs.setInt("user_id", data["id"]);
      await prefs.setString('user_role', data['role']);
      await prefs.setString('user_email', data['email']);
      return data;
    } else {
      throw Exception(data['error'] ?? 'Login failed');
    }
  }
}



