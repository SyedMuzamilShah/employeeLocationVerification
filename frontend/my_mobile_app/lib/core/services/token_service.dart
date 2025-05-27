import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;

  TokenService._internal();

  Map<String, dynamic>? _token;
  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    // _token = _prefs?.getString('token'); // Load token once initialized
    String? t = _prefs?.getString('token');
    if (t == null) {
      _token = null;
    } else {
      _token = json.decode(t);
    }
  }

  Map<String, dynamic>? get token => _token;

  Future<void> setToken(Map<String, dynamic> token) async {
    await initialize();
    _token = token;
    await _prefs?.setString('token', json.encode(token));
  }

  Future<void> clearToken() async {
    _token = null;
    await _prefs?.remove('token');
  }
}
