import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static int? _currentUser;

  static Future<bool> isUserLogged() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool("isLogged") ?? false;
  }

  static Future<void> login(int userId) async {
    _currentUser = userId;
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool("isLogged", true);
    shared.setInt('currentUserId', _currentUser!);
  }

  static Future<void> logout(BuildContext context) async {
    _currentUser = null;
    SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool('isLogged', false);
  }

  static Future<int?> getUserId() async {
    if (_currentUser != null) {
      return _currentUser; // Retorna se já estiver na memória
    }
    SharedPreferences shared = await SharedPreferences.getInstance();
    _currentUser =
        shared.getInt('currentUserId'); // Recuperar do SharedPreferences
    return _currentUser;
  }
}
