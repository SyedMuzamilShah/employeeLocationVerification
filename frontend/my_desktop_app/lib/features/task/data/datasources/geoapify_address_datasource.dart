import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/apiException/api_exception.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/core/url/url.dart';

abstract class AddressSuggestionDataSource {
  Future<Either<Failure, Map<String, dynamic>>> getAggressSuggestion(
      Map<String, dynamic> params);
}

class AddressSuggestionDataSourceImp implements AddressSuggestionDataSource {
  final ApiServices apiServices;
  const AddressSuggestionDataSourceImp(this.apiServices);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAggressSuggestion(
      Map<String, dynamic> params) async {
    try {
      final response = await apiServices.getRequest(
          endPoint: ServerUrl.getAddressSuggestion, queryParameters: params);
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
