import 'dart:convert';
import 'package:event_deskop_app/core/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  static const String _tokenKey = 'authToken';
  static const String _userKey = 'userDetails';

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Map<String, dynamic>? _userDetails;
  Map<String, dynamic>? get userDetails => _userDetails;

  AuthProvider() {
    _initialize();
  }

  Future<String?> get token async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _initialize() async {
    await _loadTokenAndUser();
  }

  Future<void> _loadTokenAndUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    String? userJson = prefs.getString(_userKey);

    if (token != null && userJson != null) {
      _isLoggedIn = true;
      _userDetails = jsonDecode(userJson);
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    const String endpoint = "/login";
    final Uri url = Uri.parse("${AppConstant.eventBaseUrl}$endpoint");

    try {
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token'];
        Map<String, dynamic> user = data['user'];

        // Save token and user details in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userKey, jsonEncode(user));

        // Update in-memory variables
        _isLoggedIn = true;
        _userDetails = user;
        notifyListeners();
        return true;
      } else {
        var errorData = jsonDecode(response.body);
        String errorMessage = errorData['error'] ?? 'Unknown error';
        print('Login failed: $errorMessage');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    // Clear any user session data stored in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.clear();

    _isLoggedIn = false;
    _userDetails = null;

    notifyListeners();
  }
}
