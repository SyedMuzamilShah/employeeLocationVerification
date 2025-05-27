import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:my_mobile_app/core/failure/failure.dart';

abstract class LocationRepositories {
  Future<Either<Failure, LocationData>> getCurrentLocation();
  Stream<Either<Failure, LocationData>> getLocationStram();
  Future<Either<Failure, bool>> requestLocationPermission();
  Future<Either<Failure, bool>> isLocationEnabled();
  Future<Either<Failure, bool>> openLocationSettings();
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, bool>> hasLocationPermission();
}