import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../data/auth_repository.dart';
import '../../shared_preferences/shared_preferences_helper.dart';

class AuthController with ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  Future<bool> checkEmail(String email) async {
    return await _repo.checkEmail(email);
  }

  Future<bool> verifyPassword(String email, String password) async {
    return await _repo.verifyPassword(email, password);
  }

  Future<void> register({
    required String email,
    required String password,
    required String role,
    required String nom,
    required String telephone,
    required String adresse,
    File? logoFile, // Pass this if cooperative
  }) async {
    await _repo.register(
      email: email,
      password: password,
      role: role,
      nom: nom,
      telephone: telephone,
      adresse: adresse,
      logoFile: logoFile,
    );
  }

  Future<Map<String, dynamic>> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final data = await _repo.login(email, password);
    // Sauvegarde la session en local (via ton helper)
    await SharedPreferencesHelper.saveSession(
      token: data['token'],
      role: data['role'],
      email: data['email'],
      userId: data['id'], // ou ce que renvoie ton backend
    );
    // Navigation selon le rôle
    if (data['role'] == 'COOPERATION') {
      Navigator.pushReplacementNamed(context, '/HomeShell', arguments: data['role']);
    } else {
      Navigator.pushReplacementNamed(context, '/HomeShell', arguments: data['role']);
    }
    notifyListeners();
    return data;
  }

}
