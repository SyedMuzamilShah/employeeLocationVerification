import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/apiException/api_exception.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/core/url/url.dart';

// Task-assigned
// 1. employeeId
// 2. Task Id

// Task-deassigned
// 1. employeeId
// 2. TaskId

// Task-verified
// 1. taskId
// 2. employeeId

abstract class TaskManagamentDataSources {
  Future<Either<Failure, Map<String, dynamic>>> taskAssign(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskDeassign(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskVerified(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskStatusChange(
      Map<String, dynamic> params);
}

abstract class TaskDataSources {
  Future<Either<Failure, Map<String, dynamic>>> taskCreate(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskUpdate(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskDelete(
      Map<String, dynamic> params);
  Future<Either<Failure, Map<String, dynamic>>> taskRead(
      [Map<String, dynamic>? params]);
  
  Future<Either<Failure, Map<String, dynamic>>> taskDetailGet(
    Map<String, dynamic> params);
}

class TaskManagamentDataSourcesImpl extends TaskManagamentDataSources {
  final ApiServices _api;
  TaskManagamentDataSourcesImpl({required ApiServices services})
      : _api = services;
  @override
  Future<Either<Failure, Map<String, dynamic>>> taskAssign(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.postRequest(
          endPoint: ServerUrl.taskAssign, body: params);
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
  Future<Either<Failure, Map<String, dynamic>>> taskDeassign(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.getRequest(
          endPoint: ServerUrl.taskDeassign, queryParameters: params);
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
  Future<Either<Failure, Map<String, dynamic>>> taskVerified(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.patchRequest(
          endPoint: ServerUrl.taskVerified, body: params);
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
  Future<Either<Failure, Map<String, dynamic>>> taskStatusChange(Map<String, dynamic> params) async {
    try {
      final response = await _api.patchRequest(
          endPoint: ServerUrl.taskStatusChange, queryParameters: params);
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
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

class TaskDataSourcesImpl implements TaskDataSources {
  final ApiServices _api;
  TaskDataSourcesImpl({required ApiServices services}) : _api = services;

  @override
  Future<Either<Failure, Map<String, dynamic>>> taskRead(
      [Map<String, dynamic>? prams]) async {
    try {
      final response = await _api.getRequest(
          endPoint: ServerUrl.taskRead, queryParameters: prams);
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
  Future<Either<Failure, Map<String, dynamic>>> taskCreate(
      Map<String, dynamic> parmas) async {
    try {
      final response = await _api.postRequest(
          endPoint: ServerUrl.taskCreate, body: parmas);
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
      print(err);
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> taskUpdate(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.patchRequest(
        endPoint: ServerUrl.taskUpdate,
        body: params,
      );
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
  Future<Either<Failure, Map<String, dynamic>>> taskDelete(
      Map<String, dynamic> params) async {
    try {
      final response = await _api.deleteRequest(
        endPoint: ServerUrl.taskDelete,
        queryParameters: params,
      );
      if (response.statusCode == 204) {
        return Right(response.data);
      }
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
  Future<Either<Failure, Map<String, dynamic>>> taskDetailGet(Map<String, dynamic> params) async {
    try {
      final response = await _api.getRequest(
        endPoint: ServerUrl.taskDetailGet,
        queryParameters: params,
      );

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
}
