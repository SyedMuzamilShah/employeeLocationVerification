import 'package:fpdart/fpdart.dart';
import 'package:location/location.dart';
import 'package:my_mobile_app/core/failure/failure.dart';

abstract class CameraRepositories {
  Future<Either<Failure, LocationData>> getPicture();
}