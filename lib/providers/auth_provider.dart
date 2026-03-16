import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:openiothub_constants/constants/SharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;

  AuthProvider() {
    loadCurrentToken();
  }

  Future<void> loadCurrentToken() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(SharedPreferencesKey.USER_TOKEN_KEY);

      if (token != null && token.isNotEmpty) {
        // 检查Token是否过期
        if (JwtDecoder.isExpired(token)) {
          // Token已过期，清除
          await prefs.remove(SharedPreferencesKey.USER_TOKEN_KEY);
          _isAuthenticated = false;
          _token = null;
        } else {
          _isAuthenticated = true;
          _token = token;
        }
      } else {
        _isAuthenticated = false;
        _token = null;
      }
    } catch (e) {
      _isAuthenticated = false;
      _token = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPreferencesKey.USER_TOKEN_KEY, token);
    _token = token;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPreferencesKey.USER_TOKEN_KEY);
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
