import 'package:fpdart/fpdart.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:my_mobile_app/features/auth/data/datasources/auth_remote.dart';
import 'package:my_mobile_app/features/auth/data/models/request/login_params.dart';
import 'package:my_mobile_app/features/auth/data/models/request/register_params.dart';
import 'package:my_mobile_app/features/auth/data/models/response/token_response_model.dart';
import 'package:my_mobile_app/features/auth/data/models/response/user_response_model.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/features/auth/domain/repositories/auth_repositories_class.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/network/network_info.dart';

class AuthRepoImpl
    implements
        RegisterRepository,
        LoginRepository,
        LogoutRepository,
        UserRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSources _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepoImpl({
    required AuthRemoteDataSources remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  /// **Handles Authentication Response (Reduces Code Duplication)**
  Future<Either<Failure, UserEntities>> _handleAuthResponse(
    Future<Either<Failure, Map<String, dynamic>>> Function() authCall,
  ) async {
    if (!await _networkInfo.isConnected) {
      return Left(Failure(message: 'No internet connection'));
    }
    try {
      final response = await authCall();
      return response.fold(
        (failure) {
          return Left(failure);
        },
        (data) async {
          // convert the user map into class form
          final userModel = UserResponseModel.fromJson(data['data']['user']);

          // Cache tokens and user data
          await _localDataSource.cacheToken(data['data']['tokens']);
          await _localDataSource.cacheUser(userModel.toJson());

          return Right(userModel);
        },
      );
    } catch (e) {
      return Left(Failure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  /// **Register New User**
  @override
  Future<Either<Failure, UserEntities>> register(
      RegisterParams params) async {
    return _handleAuthResponse(
        () => _remoteDataSource.register(params.toJson()));
  }

  /// **Login User**
  @override
  Future<Either<Failure, UserEntities>> login(LoginParams params) async {
    return _handleAuthResponse(() => _remoteDataSource.login(params.toJson()));
  }

  /// **Logout User**
  @override
  Future<Either<Failure, String>> logout() async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.logout();
      await _localDataSource.clearTokenAndUser();
      return Right("User logged out successfully");
    } catch (e) {
      await _localDataSource.clearTokenAndUser();
      return Left(Failure(message: 'Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntities>> getUser() async {
      // try {
      //   final localUser = await _localDataSource.getCachedUser();
      //   if (localUser != null) {
      //     final user = UserResponseModel.fromJson(localUser);
      //     return Right(user);
      //   }
      // } catch (e) {
      //   if (e is CacheException) {
      //     if (kDebugMode) {
      //       print(e.message);
      //     }
      //   }
      // }

    if (!await _networkInfo.isConnected) {
      return Left(Failure(message: 'No internet connection'));
    }

    final remoteUser = await _remoteDataSource.getUser();

    return remoteUser.fold((err) {
      return Left(err);
    }, (data) async {
      // convert the user map into class form
      final userModel = UserResponseModel.fromJson(data['data']['user']);
      // Cache tokens and user data
      // await _localDataSource.cacheToken(data['data']['tokens']);
      await _localDataSource.cacheUser(userModel.toJson());
      return Right(userModel);
    });
  }

  // @override
  // Future<Either<Failure, bool>> refreshToken() async {
  //   final token = await _localDataSource.getCachedToken();
  //   if (token == null){
  //     return Left(Failure(message: 'access token not found'));
  //   }
  //   final tokenModel = TokenModel.fromJson(token);

  //   final response = await _remoteDataSource.tokenRefresh(tokenModel);

  //   return response.fold(
  //     (err) => Left(err),
  //     (succ) async {
  //       final tk = succ['data']['tokens'];
  //       await _localDataSource.cacheToken(tk);
  //       return right(true);
  //     });
  // }

  @override
  Future<Either<Failure, bool>> isLogin() async {
    final token = await _localDataSource.getCachedToken();
    if (token == null) {
      return Left(NotLoginFailure(message: 'Access token not found'));
    }
    final tokenModel = TokenModel.fromJson(token);

    bool decodedTokenIsExpired = JwtDecoder.isExpired(tokenModel.accessToken);
    if (!decodedTokenIsExpired) {
      return Right(true);
    }

    final response = await _remoteDataSource.tokenRefresh(tokenModel.toJson());

    return response.fold((err) => Left(NotLoginFailure(message: err.message)),
        (succ) async {
      final tk = succ['data']['tokens'];

      // only Cache the token 
      // user data is already Cached
      await _localDataSource.cacheToken(tk);
      return Right(true);
    });
  }
}
