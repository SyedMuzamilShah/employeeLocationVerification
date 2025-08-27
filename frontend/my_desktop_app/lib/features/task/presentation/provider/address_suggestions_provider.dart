import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/task/data/datasources/geoapify_address_datasource.dart';
import 'package:my_desktop_app/features/task/data/models/request/address_suggestion_params.dart';
import 'package:my_desktop_app/features/task/data/repositories/geoapify_address_repository.dart';
import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';
import 'package:my_desktop_app/features/task/domain/usecases/address_usecase.dart';

// Repository Provider
final addressSuggestionUseCaseProvider = Provider<AddressSuggestionUseCase>((ref) {
  return AddressSuggestionUseCaseImpl(repo: AddressSuggestionRepoImpl(AddressSuggestionDataSourceImp(ApiServices())));
});

// // Suggestions Provider (Async)
// final addressSuggestionsProvider =
//     FutureProvider.family<List<String>, String>((ref, input) async {
//   final repo = ref.watch(addressSuggestionUseCaseProvider);
//   if (input.isEmpty) return [];
//   return await repo.(input);
// });

final addressSuggestionsProvider = FutureProvider.autoDispose.family<List<AddressSuggestionEntities>, String>((ref, input) async {
  final AddressSuggestionParams params = AddressSuggestionParams(address: input);
  final repo = ref.watch(addressSuggestionUseCaseProvider);

  final response = await repo.getAddressSuggestion(params);

  return response.fold(
    (error) => throw Exception(error.message),
    (success) => success,
  );
});

