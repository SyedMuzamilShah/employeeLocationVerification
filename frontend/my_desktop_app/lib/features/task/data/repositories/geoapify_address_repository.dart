import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/datasources/geoapify_address_datasource.dart';
import 'package:my_desktop_app/features/task/data/models/request/address_suggestion_params.dart';
import 'package:my_desktop_app/features/task/data/models/response/address_suggestion_response.dart';
import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/address_repo.dart';

class AddressSuggestionRepoImpl implements AddressSuggestionRepo {
  final AddressSuggestionDataSourceImp dataSource;
  const AddressSuggestionRepoImpl(this.dataSource);
  @override
  Future<Either<Failure, List<AddressSuggestionEntities>>>
      getAddressSuggestions(AddressSuggestionParams params) async {
    final response = await dataSource.getAggressSuggestion(params.toMap());

    return response.fold((error) => Left(error), (succ) {
      final responseList = succ['data'] as List;
      final suggestions = responseList
          .map((item) => AddressSuggestionResponse.fromMap(item))
          .toList();
      return Right(suggestions);
    });
  }
}
