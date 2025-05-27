import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

class LocationParams extends Equatable {
  final double longitude;
  final double latitude;
  final String? address;
  final String? placeId;
  final String? placeName;

  const LocationParams(
      {
      required this.longitude,
      required this.latitude,
      this.address,
      this.placeName,
      this.placeId});

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
      if (address != null) 'address': address,
      if (placeId != null) 'placeId': placeId,
      if (placeName != null) 'placeName': placeName,
    };
  }


    LocationParams copyWith({
    double? longitude,
    double? latitude,
    String? address,
    String? placeId,
    String? placeName,
  }) {
    return LocationParams(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
    );
  }

  @override
  List<Object?> get props => [longitude, latitude, address, placeId, placeName];

  LatLng toLatLng() => LatLng(latitude, longitude);
}
