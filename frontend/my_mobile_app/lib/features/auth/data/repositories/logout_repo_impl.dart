// import 'package:fpdart/fpdart.dart';
// import 'package:my_desktop_app/core/failure/failure.dart';
// import 'package:my_desktop_app/core/network/network_info.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_remote.dart';
// import 'package:my_desktop_app/features/auth/domain/repositories/auth_repositories_class.dart';

// class LogoutRepoImpl extends LogoutRepository {
//   final AuthLocalDataSource _authLocalDataSource;
//   final AuthRemoteDataSources _authRemoteDataSources;
//   final NetworkInfo _networkInfo;

//   LogoutRepoImpl({
//     required AuthRemoteDataSources sources,
//     required AuthLocalDataSource authLocalData,
//     required NetworkInfo networkInfo,
//   })  : _authRemoteDataSources = sources,
//         _authLocalDataSource = authLocalData,
//         _networkInfo = networkInfo;

//   @override
//   Future<Either<Failure, String>> logout() async {
//     try {
//       if (!await _networkInfo.isConnected) {
//         return Left(NetworkFailure(message: 'No Internet'));
//       }

//       // Attempt API logout
//       await _authRemoteDataSources.logout();

//       // Clear local storage
//       await _authLocalDataSource.clearTokenAndUser();
//       return Right("User logout successfully");
//     } catch (e) {
//       return Left(Failure(message: '$e'));
//     }
//   }
// }
