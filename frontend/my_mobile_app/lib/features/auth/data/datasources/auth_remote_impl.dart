import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/features/auth/data/datasources/auth_remote.dart';
import 'package:my_mobile_app/core/apiException/api_exception.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/services/api_services.dart';
import 'package:my_mobile_app/core/url/url.dart';

class AuthRemoteDataSourcesImpl extends AuthRemoteDataSources {
  final ApiServices _apiServices;
  AuthRemoteDataSourcesImpl({required ApiServices api}) : _apiServices = api;

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      Map<String, dynamic> prams) async {
    // Post Route hit they just returned the response and and ApiException if error happened.
    // [End point is passed], [body : data is passed converting them into map]

    try {
      var response = await _apiServices.postRequest(
          endPoint: ServerUrl.userLoginRoute, body: prams);
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
      Map<String, dynamic> prams) async {
    

    try {
      var response = await _apiServices.postRequest(
        endPoint: ServerUrl.userRegisterRoute, body: prams);
      if (response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await _apiServices.postRequest(endPoint: ServerUrl.userLogoutRoute);
    return;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUser() async {
    
    
    try {
      var response =
        await _apiServices.getRequest(endPoint: ServerUrl.userGetProfileRoute);
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> tokenRefresh(
      Map<String, dynamic> prams) async {

    try {
      var response = await _apiServices.postRequest(
        endPoint: ServerUrl.userRefreshToken, body: prams);
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> changePassword(
      Map<String, dynamic> prams) async {
    try {
      var response = await _apiServices.postRequest(
          endPoint: ServerUrl.userChangePasswordRoute, body: prams);
          print("Testing the main portion");
          print(response.data);
      if (response.statusCode == 204) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }
}
