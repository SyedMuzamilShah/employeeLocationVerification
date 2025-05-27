// import 'package:fpdart/fpdart.dart';
// import 'package:my_desktop_app/features/auth/domain/entities/user_entities.dart';
// import '../../../../core/errors/failures.dart';

// abstract class AuthRepository {
//   Future<Either<Failure, UserEntities>> login(String email, String password);
//   Future<Either<Failure, UserEntities>> register(String name, String email, String password);
//   Future<Either<Failure, void>> logout();
//   Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
//   Future<Either<Failure, void>> forgotPassword(String email);
//   Future<Either<Failure, UserEntities?>> getCurrentUser();
//   Future<Either<Failure, String?>> getToken();
// }