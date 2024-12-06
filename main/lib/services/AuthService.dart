import 'package:flutter/material.dart';
import 'package:main/pages/ListaScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static int? _currentUser;

  static Future<bool> isUserLogged() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool("isLogged") ?? false;
  }

  static Future<void> login(int userId) async{
      _currentUser = userId;
      SharedPreferences shared = await SharedPreferences.getInstance();
      shared.setBool("isLogged", true);
  }

  static Future<void> logout(BuildContext context) async {
    _currentUser = null;
    SharedPreferences shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', false);

  }

  static Future<int?> getUserId() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getInt('isLogged');
  }



}