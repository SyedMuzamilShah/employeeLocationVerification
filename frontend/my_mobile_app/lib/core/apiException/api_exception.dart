import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  factory ApiException.fromDioError(DioException error) {
    print("Type : ${error.type} \t StatusCode : ${error.response?.statusCode}");
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException("Request timed out. Please try again.");

      case DioExceptionType.connectionError:
        return ApiException("Server is not connected");

      case DioExceptionType.cancel:
        return ApiException("Request was cancelled.");

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      default:
        return ApiException("Something went wrong.");
    }
  }

  @override
  String toString() => message;
}

class ValidationException extends ApiException {
  final List<dynamic> errors;
  ValidationException({required this.errors, String? message})
      : super(message ?? 'Validation failure');
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

ApiException _handleBadResponse(DioException error) {
  final statusCode = error.response?.statusCode;
  final responseData = error.response?.data;
  // print("Bad Request statusCode : $statusCode");
  // print("Bad Request response : $responseData");
  if (statusCode == 400) {
    // return ValidationException(errors: responseData['errors'], message: responseData['message']);
    if (responseData["errors"] != null && responseData["errors"] is List) {
      return ValidationException(
          errors: responseData['errors'], message: responseData['message']);
    }

    return ApiException(responseData["message"] ?? "Bad request.");
  } else if (statusCode == 401) {
    return ApiException(responseData["message"] ?? "Unauthorized. Please log in again.");
  } else if (statusCode == 403) {
    return ApiException("You do not have permission to access this.");
  } else if (statusCode == 404) {
    try {
      return ApiException(responseData["message"] ?? "Resource not found.");
    }catch (err){
      return ApiException("Resource not found.");
    }

  }
   else if (statusCode == 500) {
    return ApiException(responseData["message"] ?? "Server error. Please try again later.");
  }
   else if (statusCode == 409) {
    return ApiException(responseData["message"] ?? "Some thing want wrong");
  }
   else {
    return ApiException("Unexpected error occurred.");
  }
}
