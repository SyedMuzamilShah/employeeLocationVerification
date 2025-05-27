import 'package:location/location.dart';
import 'package:my_mobile_app/core/errors/exception_log.dart';
import 'package:my_mobile_app/features/devices/domain/repositories/location_repository.dart';

class LocationUsecase {
  final LocationRepositories _repositories;
  const LocationUsecase(this._repositories);

  Future<bool> checkLocationPermission() async {
    final result = await _repositories.checkLocationPermission();
    return result.fold((error) => false, (r) => r);
  }

  Future<bool> requestLocationPermission() async {
    final result = await _repositories.requestLocationPermission();
    return result.fold((error) => false, (sucess) => sucess);
  }

  Future<LocationData> getCurrentLocation() async {
    final result = await _repositories.getCurrentLocation();
    return result.fold((error) => throw ExceptionLog(error.message), (sucess) => sucess);
  }

  Stream<LocationData> getLocationStream() {
    final result = _repositories.getLocationStram();
    return result.map((event) => event.fold((error) => throw ExceptionLog(error.message), (sucess) => sucess));
  }
}