import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/features/auth/data/models/request/change_password_params.dart';
import 'package:my_mobile_app/features/auth/data/models/request/login_params.dart';
import 'package:my_mobile_app/features/auth/data/models/request/register_params.dart';
import 'package:my_mobile_app/features/auth/data/repositories/basic_auth_impl.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/core/failure/failure.dart';

abstract class AuthUsecase {
  Future<Either<Failure, UserEntities>> register(RegisterParams params);
  Future<Either<Failure, UserEntities>> login(LoginParams params);
  Future<Either<Failure, String>> changePassword(ChangePasswordParams params);
  Future<Either<Failure, bool>> isLogin();
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, UserEntities>> getUser();
  // Future<Either<Failure, bool>> refreshToken();
}

class AuthUsecaseImpl extends AuthUsecase {
  final AuthRepoImpl _authRepo;
  AuthUsecaseImpl({required AuthRepoImpl authRepo}) : _authRepo = authRepo;

  @override
  Future<Either<Failure, UserEntities>> login(LoginParams params) async {
    return await _authRepo.login(params);
  }

  @override
  Future<Either<Failure, UserEntities>> register(RegisterParams params) async {
    return await _authRepo.register(params);
  }

  @override
  Future<Either<Failure, String>> logout() async {
    return await _authRepo.logout();
  }

  @override
  Future<Either<Failure, UserEntities>> getUser() async {
    return await _authRepo.getUser();
  }

  // @override
  // Future<Either<Failure, bool>> refreshToken() async {
  //   return await _authRepo.refreshToken();
  // }

  @override
  Future<Either<Failure, bool>> isLogin() async {
    return await _authRepo.isLogin();
  }

  @override
  Future<Either<Failure, String>> changePassword(
      ChangePasswordParams params) async {
    return await _authRepo.changePassword(params);
  }
}
