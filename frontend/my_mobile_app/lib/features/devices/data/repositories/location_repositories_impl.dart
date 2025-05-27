import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/devices/data/sources/local/location_local.dart';
import 'package:my_mobile_app/features/devices/domain/repositories/location_repository.dart';

class LocationRepositoriesImpl extends LocationRepositories {
  final LocationLocalDataSource _locationLocalDataSource;

  LocationRepositoriesImpl(this._locationLocalDataSource);
  
  @override
  Future<Either<Failure, bool>> checkLocationPermission() {
    // TODO: implement checkLocationPermission
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, LocationData>> getCurrentLocation() async {
    return await _locationLocalDataSource.getCurrentLocation();
  }
  
  @override
  Stream<Either<Failure, LocationData>> getLocationStram() async* {
    yield* _locationLocalDataSource.getLocationStream();
  }
  
  @override
  Future<Either<Failure, bool>> hasLocationPermission() {
    // TODO: implement hasLocationPermission
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> isLocationEnabled() {
    // TODO: implement isLocationEnabled
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> openLocationSettings() {
    // TODO: implement openLocationSettings
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, bool>> requestLocationPermission() {
    // TODO: implement requestLocationPermission
    throw UnimplementedError();
  }
}