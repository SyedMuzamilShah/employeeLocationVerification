// import 'package:fpdart/fpdart.dart';
// import 'package:my_desktop_app/core/failure/failure.dart';
// import 'package:my_desktop_app/core/network/network_info.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_remote.dart';
// import 'package:my_desktop_app/features/auth/data/models/request/login_request_prams.dart';
// import 'package:my_desktop_app/features/auth/data/models/response/user_response_model.dart';
// import 'package:my_desktop_app/features/auth/domain/entities/user_entities.dart';
// import 'package:my_desktop_app/features/auth/domain/repositories/auth_repositories_class.dart';

// class LoginRepoImpl implements LoginRepository {
//   final AuthLocalDataSource _authLocalDataSource;
//   final AuthRemoteDataSources _authRemoteDataSources;
//   final NetworkInfo _networkInfo;

//   LoginRepoImpl(
//       {required AuthRemoteDataSources sources,
//       required AuthLocalDataSource authLocalData,
//       required NetworkInfo networkInfo})
//       : _authRemoteDataSources = sources,
//         _authLocalDataSource = authLocalData,
//         _networkInfo = networkInfo;

//   @override
//   Future<Either<Failure, UserEntities>> login(LoginRequestPrams prams) async {
//     if (!await _networkInfo.isConnected) {
//       return Left(NetworkFailure(message: 'No internet connection'));
//     }
//     // Note that the response should be [Response Instance]
//     final user = await _authRemoteDataSources.login(prams);

//     return user.fold((err) => Left(err), (user) async {
//       // Create the model
//       final UserResponseModel model =
//           UserResponseModel.fromJson(user['data']['user']);

//       // Saved the user data and tokens
//       await _authLocalDataSource.cacheToken(user['data']['tokens']);
//       await _authLocalDataSource.cacheUser(model.toJson());

//       // return the user model
//       return Right(model);
//     });
//   }
// }
