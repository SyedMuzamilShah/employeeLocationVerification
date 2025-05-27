import 'package:flutter/foundation.dart';
import 'package:my_mobile_app/core/apiException/api_exception.dart';
import 'package:my_mobile_app/core/services/local_database_service.dart';
import 'package:my_mobile_app/core/services/token_service.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(Map<String, dynamic> user);
  Future<void> cacheToken(Map<String, dynamic> token);

  Future<Map<String, dynamic>?> getCachedUser();
  Future<Map<String, dynamic>?> getCachedToken();

  Future<void> clearToken();
  Future<void> clearUser();
  Future<void> clearTokenAndUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenService _tokenService;
  final LocalDatabaseService _localDb;

  AuthLocalDataSourceImpl(
      {required TokenService tokenService,
      required LocalDatabaseService localDb})
      : _tokenService = tokenService,
        _localDb = localDb;

  @override
  Future<void> cacheToken(Map<String, dynamic> token) async {
    try {
      await _tokenService.setToken(token);
    } catch (e) {
      throw CacheException('Failed to cache token: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(Map<String, dynamic> user) async {
    try {
      await _localDb.storeUser(user);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await _tokenService.clearToken();
    } catch (e) {
      throw CacheException('Failed to clear token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearTokenAndUser() async {
    try {
      await _tokenService.clearToken();
      await _localDb.clearUser();
    } catch (e) {
      throw CacheException('Failed to clear token and user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _localDb.clearUser();
    } catch (e) {
      throw CacheException('Failed to clear user: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedToken() async {
    try {
      return _tokenService.token;
    } catch (e) {
      throw CacheException('Failed to get cached token: ${e.toString()}');
    }
  }
  @override
Future<Map<String, dynamic>?> getCachedUser() async {
  try {
    final user = _localDb.getUser();
    if (user == null) {
      throw CacheException('No cached user found');
    }
    final Map<String, dynamic> castedUser = Map<String, dynamic>.from(user);
    return castedUser;
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching cached user: ${e.toString()}");
    }
    throw CacheException('Failed to get cached user: ${e.toString()}');
  }
}

}
