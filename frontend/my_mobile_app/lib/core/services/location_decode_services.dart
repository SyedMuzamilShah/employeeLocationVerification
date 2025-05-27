import 'package:geocoding/geocoding.dart';

class LocationDecodeServices {
  Future<String?> decodeCoordinate (lng, ltd) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(ltd, lng);
    return placemarks.first.thoroughfare ?? placemarks.first.locality;
  }
}