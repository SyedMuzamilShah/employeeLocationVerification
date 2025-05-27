import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/features/auth/data/models/request/login_params.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/features/auth/domain/repositories/auth_repositories_class.dart';
import 'package:my_mobile_app/core/failure/failure.dart';

abstract class LoginUseCase {
  Future<Either<Failure, UserEntities>> login({required LoginParams params});
}


class LoginUseCaseImpl extends LoginUseCase {

  final LoginRepository _loginRepo;
  LoginUseCaseImpl({required LoginRepository loginRepo}) : _loginRepo = loginRepo;

  @override
  Future<Either<Failure, UserEntities>> login({required LoginParams params}) async {
    return await _loginRepo.login(params);
  }
}