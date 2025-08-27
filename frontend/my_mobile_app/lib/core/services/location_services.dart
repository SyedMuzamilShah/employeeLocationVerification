import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  
  Stream<LocationData> stateStreaming() async* {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled){
      throw Exception('Location services are disabled');
    }
    await for (final loc in _location.onLocationChanged) {
      yield loc; 
    }
  }

  Future<LocationData> getCurrentLocation() async {
    print("Get Location Function called");
    try {
      // Check and request service enablement
      _serviceEnabled = await _location.serviceEnabled();
      print("Get Location Function called : $_serviceEnabled");

      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          throw Exception('Location services are disabled');
        }
      }

      // Check and request permissions
      // _permissionStatus = await _location.hasPermission();
      // if (_permissionStatus == PermissionStatus.denied) {
      //   _permissionStatus = await _location.requestPermission();
      //   if (_permissionStatus != PermissionStatus.granted) {
      //     throw Exception('Location permissions denied');
      //   }
      // }
      // _location.changeSettings(interval: 10000);

      // Get current location
      return await _location.getLocation();
    } catch (e) {
      print('Location error: $e');
      throw Exception('Location error: $e');

    }
  }

  Future<bool> checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return false;
    }

    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
    }

    return _permissionStatus == PermissionStatus.granted;
  }
}
