import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';


// final permissionsProvider = FutureProvider<Map<Permission, PermissionStatus>>((ref) async {
//   return await [
//     Permission.camera,
//     Permission.location,
//   ].request();
// });


final permissionsProvider = FutureProvider<Map<Permission, PermissionStatus>>((ref) async {
  final cameraStatus = await Permission.camera.status;
  final locationStatus = await Permission.location.status;

  if (cameraStatus.isDenied || locationStatus.isDenied) {
    // Only request if denied
    return await [
      Permission.camera,
      Permission.location,
    ].request();
  }

  return {
    Permission.camera: cameraStatus,
    Permission.location: locationStatus,
  };
});
