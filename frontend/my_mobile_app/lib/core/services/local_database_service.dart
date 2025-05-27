import 'package:hive_flutter/adapters.dart';
import 'package:my_mobile_app/core/apiException/api_exception.dart';
class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._();

  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._();

  late Box box;
  final String _userKey = 'user';
  final String _blogKey = 'blog';

  /// ✅ Initialize Hive Box with Try-Catch
  Future<void> init() async {
    try {
      box = await Hive.openBox('myBox');
    } catch (e) {
      throw CacheException("Failed to open Hive box: $e");
    }
  }

  /// ✅ Store user data safely
  Future<void> storeUser(Map<String, dynamic> data) async {
    try {
      await box.put(_userKey, data);
    } catch (e) {
      throw CacheException("Failed to store user data: $e");
    }
  }

  /// ✅ Get user data
  dynamic getUser() {
    try {
      return box.get(_userKey);
    } catch (e) {
      throw CacheException("Failed to retrieve user data: $e");
    }
  }

  /// ✅ Remove user data
  Future<void> clearUser() async {
    try {
      await box.delete(_userKey);
    } catch (e) {
      throw CacheException("Failed to clear user data: $e");
    }
  }

  /// ✅ Store blog data safely
  Future<void> storeBlog(Map<String, dynamic> data) async {
    try {
      await box.put(_blogKey, data);
    } catch (e) {
      throw CacheException("Failed to store blog data: $e");
    }
  }

  /// ✅ Get blog data
  dynamic getBlog() {
    try {
      return box.get(_blogKey);
    } catch (e) {
      throw CacheException("Failed to retrieve blog data: $e");
    }
  }

  /// ✅ Remove blog data
  Future<void> clearBlog() async {
    try {
      await box.delete(_blogKey);
    } catch (e) {
      throw CacheException("Failed to clear blog data: $e");
    }
  }
}
