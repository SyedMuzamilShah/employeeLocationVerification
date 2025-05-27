import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true; // If decoding fails, assume expired
    }
  }
}
