import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/apiException/api_exception.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/services/api_services.dart';
import 'package:my_mobile_app/core/url/url.dart';

abstract class ImageUploadRemote {
  Future<Either<Failure, Map<String, dynamic>>> uploadImage(FormData params);
}

class ImageUploadRemoteImpl extends ImageUploadRemote {
  final ApiServices _api;
  ImageUploadRemoteImpl({required ApiServices services}) : _api = services;
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> uploadImage(
      FormData params) async {
    try {
      final response = await _api.postRequestForForm(
          endPoint: ServerUrl.uploadImage, body: params);
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
}
