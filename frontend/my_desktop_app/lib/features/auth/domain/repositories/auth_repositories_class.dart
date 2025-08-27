import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/auth/data/models/request/change_password_params.dart';
import 'package:my_desktop_app/features/auth/data/models/request/login_params.dart';
import 'package:my_desktop_app/features/auth/data/models/request/register_params.dart';
import 'package:my_desktop_app/features/auth/domain/entities/user_entities.dart';


// Done ✅
abstract class LoginRepository {
  Future<Either<Failure, UserEntities>> login(LoginParams params);
}

// Done ✅
abstract class RegisterRepository {
  Future<Either<Failure, UserEntities>> register(RegisterParams params);
}

// Done ✅
abstract class LogoutRepository {
  Future<Either<Failure, String>> logout();
}

// Done ✅
abstract class UserRepository {
  Future<Either<Failure, bool>> isLogin();
  Future<Either<Failure, UserEntities>> getUser();
}

abstract class UserRefreshToken {
  Future<Either<Failure, bool>> isLogin();
  Future<Either<Failure, bool>> refreshToken();
}

abstract class ChangePasswordRepository {
  Future<Either<Failure, String>> changePassword(ChangePasswordParams params);
}


abstract class ForgotPasswordRepository {
  Future<Either<Failure, String>> forgotPassword();
}