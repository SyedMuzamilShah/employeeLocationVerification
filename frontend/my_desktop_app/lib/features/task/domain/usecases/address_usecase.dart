import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/models/request/address_suggestion_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/address_repo.dart';

abstract class AddressSuggestionUseCase {
  Future<Either<Failure, List<AddressSuggestionEntities>>> getAddressSuggestion(AddressSuggestionParams params);
}


class AddressSuggestionUseCaseImpl extends AddressSuggestionUseCase {
  final AddressSuggestionRepo _repo;
  AddressSuggestionUseCaseImpl({required AddressSuggestionRepo repo}) : _repo = repo;

  @override
  Future<Either<Failure, List<AddressSuggestionEntities>>> getAddressSuggestion(AddressSuggestionParams params) async {
    final organization = await _repo.getAddressSuggestions(params);
    return organization.fold((err) => Left(err), (succ) => Right(succ));
  }
}