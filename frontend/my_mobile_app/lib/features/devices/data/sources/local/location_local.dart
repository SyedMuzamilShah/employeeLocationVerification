import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/services/location_services.dart';

abstract class LocationLocalDataSource {
  Future<Either<Failure, LocationData>> getCurrentLocation();
  Stream<Either<Failure, LocationData>> getLocationStream();
  // Future<Either<Failure, bool>> requestLocationPermission();
  // Future<Either<Failure, bool>> isLocationEnabled();
  // Future<Either<Failure, bool>> openLocationSettings();
  // Future<Either<Failure, bool>> checkLocationPermission();
  // Future<Either<Failure, bool>> hasLocationPermission(); 
}


class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final LocationService location;

  LocationLocalDataSourceImpl(this.location);
  
  @override
  Future<Either<Failure, LocationData>> getCurrentLocation() async {
    try {
       final response = await location.getCurrentLocation();
       if (response.isMock != null) {
        if (response.isMock!){
         print('Warning: Mock location detected');
          Left(Failure(message: "Pack location detected"));
        }
       }
       return Right(response);
    }catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
  @override
  Stream<Either<Failure, LocationData>> getLocationStream() {
    try {
      final response = location.stateStreaming();
      return response.map((locationData) => Right(locationData));
    } catch (e) {
      return Stream.value(Left(Failure(message: e.toString())));
    }
  }
}