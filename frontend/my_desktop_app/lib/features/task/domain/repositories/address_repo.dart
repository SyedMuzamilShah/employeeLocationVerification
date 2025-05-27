import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/models/request/address_suggestion_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';

abstract class AddressSuggestionRepo {
  Future<Either<Failure, List<AddressSuggestionEntities>>> getAddressSuggestions(AddressSuggestionParams params);
}
