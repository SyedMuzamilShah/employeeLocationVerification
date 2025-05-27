import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_desktop_app/core/apiException/api_exception.dart';
import 'package:my_desktop_app/core/services/token_service.dart';
import 'package:my_desktop_app/features/auth/data/models/response/token_response_model.dart';

class ApiServices {
  // Singleton instance
  static final ApiServices _instance = ApiServices._();
  factory ApiServices() => _instance;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api/v1'));
  // Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  final TokenService _tokenStorage = TokenService();

  // Private class constructor
  ApiServices._() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Token varible intilized
        String? token;
        if (_tokenStorage.token != null) {
          var tokenModel = TokenModel.fromJson(_tokenStorage.token);
          token = tokenModel.accessToken;
        }

        options.contentType = 'application/json';
        options.receiveDataWhenStatusError = true;
        options.receiveTimeout = Duration(seconds: 15);
        options.connectTimeout = Duration(seconds: 15);
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
          debugPrint("Token  is [api_services.dart]");
          debugPrint(token);
        } else {
          debugPrint("Token is Null in [api_services.dart]");
        }
        return handler.next(options);
      },
    ));
  }

  // Post request function
  Future<Response<dynamic>> postRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {

    return await _requestHandler(
      () => _dio.post(
        endPoint,
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  // get request function
  Future<Response<dynamic>> getRequest({
    required String endPoint,
    // Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _requestHandler(
        () => _dio.get(endPoint, queryParameters: queryParameters));
  }

  // put request function
  Future<Response<dynamic>> putRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _requestHandler(
        () => _dio.put(endPoint, data: body, queryParameters: queryParameters));
  }

  // delete request function
  Future<Response<dynamic>> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _requestHandler(() =>
        _dio.delete(endPoint, data: body, queryParameters: queryParameters));
  }

  // patch request function
  Future<Response<dynamic>> patchRequest({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _requestHandler(() =>
        _dio.patch(endPoint, data: body, queryParameters: queryParameters, options: Options(receiveTimeout: Duration(seconds: 20))));
  }
}

// RequestHandler
Future<Response<dynamic>> _requestHandler(
    Future<Response> Function() request) async {
  try {
    var response = await request();
    if (kDebugMode) {
      print(
          "Api_services.dart: success response : Status Code : ${response.statusCode}");
    }
    // print("Api_services.dart: success response : ${response.data}");
    return response;
  } on DioException catch (e) {
    print(e.error);
    throw ApiException.fromDioError(e);
  } catch (e) {
    throw ApiException("Unexpected error: $e");
  }
}
