import 'package:latlong2/latlong.dart';

class LocationEntities {
  final double longitude;
  final double latitude;
  final String? address;
  final String? placeId;
  final String? placeName;

  LocationEntities(
      {required this.longitude,
      required this.latitude,
      this.address,
      this.placeName,
      this.placeId});
  
  LatLng toLatLng() => LatLng(latitude, longitude);
}
