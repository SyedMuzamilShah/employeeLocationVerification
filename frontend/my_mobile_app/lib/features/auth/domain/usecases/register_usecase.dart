import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/features/auth/data/models/request/register_params.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/features/auth/domain/repositories/auth_repositories_class.dart';
import 'package:my_mobile_app/core/failure/failure.dart';

abstract class RegisterUseCase {
  Future<Either<Failure, UserEntities>> register({required RegisterParams params});
}

class RegisterUseCaseImpl extends RegisterUseCase {

  final RegisterRepository _registerRepo;
  RegisterUseCaseImpl({required RegisterRepository registerRepo}) : _registerRepo = registerRepo;

  @override
  Future<Either<Failure, UserEntities>> register({required RegisterParams params}) async {
    return await _registerRepo.register(params);
  }
}