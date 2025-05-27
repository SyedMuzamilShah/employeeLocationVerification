import 'package:my_mobile_app/features/task/domain/entities/location_entities.dart';

class LocationResponseModel extends LocationEntities {
  LocationResponseModel(
      {required super.latitude,
      required super.longitude,
      super.address,
      super.placeId,
      super.placeName});
  factory LocationResponseModel.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'];
    if (coords is List && coords.length == 2){
        final lng = coords[0] as double;
        final lat = coords[1] as double;
      return LocationResponseModel(
        longitude: lng,
        latitude: lat,
        address: json['address'],
      );
    }
    throw FormatException('Invalid coordinates: $coords');
  }
}
