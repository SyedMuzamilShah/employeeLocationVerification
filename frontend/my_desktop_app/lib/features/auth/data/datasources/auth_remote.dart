import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';

abstract class AuthRemoteDataSources {
  Future<Either<Failure, Map<String, dynamic>>> login(Map<String, dynamic> prams);
  Future<Either<Failure, Map<String, dynamic>>> register(Map<String, dynamic> prams);
  Future<Either<Failure, String>> changePassword(Map<String, dynamic> prams);
  Future<Either<Failure, Map<String, dynamic>>> tokenRefresh(Map<String, dynamic> prams);
  Future<void> logout();
  Future<Either<Failure, Map<String, dynamic>>> getUser();
}