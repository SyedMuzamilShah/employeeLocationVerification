import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/apiException/api_exception.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/services/api_services.dart';
import 'package:my_mobile_app/core/url/url.dart';

abstract class TaskRemoteDataSource {
  Future<Either<Failure, Map<String, dynamic>>> getTasks(
      Map<String, dynamic>? params);
  Future<Either<Failure, Map<String, dynamic>>> getTaskById(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> completingTask(FormData params);
  Future<Either<Failure, String>> completingTaskCheckout(Map<String, dynamic> params);
}

class TaskRemoteDataSourceImpl extends TaskRemoteDataSource {
  final ApiServices _api;
  TaskRemoteDataSourceImpl({required ApiServices services}) : _api = services;

  @override
  Future<Either<Failure, Map<String, dynamic>>> getTasks(
      Map<String, dynamic>? params) async {
        print(params);
    try {
      final response = await _api.getRequest(
          endPoint: ServerUrl.tasksRead, queryParameters: params);
      if (response.statusCode == 200 || response.statusCode == 201) {
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
  Future<Either<Failure, Map<String, dynamic>>> completingTask(
      FormData params) async {
    try {
      final response = await _api.postRequestForForm(
          endPoint: ServerUrl.taskComplete, body: params);
      if (response.statusCode == 200 || response.statusCode == 201) {
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
  Future<Either<Failure, Map<String, dynamic>>> getTaskById(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.getRequest(
          endPoint: ServerUrl.taskComplete, queryParameters: params);
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
  Future<Either<Failure, String>> completingTaskCheckout(Map<String, dynamic> params) async {
    try {
      final response = await _api.postRequest(
          endPoint: ServerUrl.taskCompleteCheckOut, body: params);
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
