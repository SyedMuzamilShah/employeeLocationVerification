import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/location_services.dart';
import 'package:my_mobile_app/features/devices/data/repositories/location_repositories_impl.dart';
import 'package:my_mobile_app/features/devices/data/sources/local/location_local.dart';
import 'package:my_mobile_app/features/devices/domain/usecase/location_usecase.dart';

final currentLocationProvider = FutureProvider((ref) async {
  final locationUseCase = ref.read(_locationUseCaseProvider);
  return await locationUseCase.getCurrentLocation();
});

final locationStreamProvider = StreamProvider((ref) {
  final locationUseCase = ref.read(_locationUseCaseProvider);
  return locationUseCase.getLocationStream();
});

final _locationUseCaseProvider = Provider((ref) {
  return LocationUsecase(
      LocationRepositoriesImpl(LocationLocalDataSourceImpl(LocationService())));
});
