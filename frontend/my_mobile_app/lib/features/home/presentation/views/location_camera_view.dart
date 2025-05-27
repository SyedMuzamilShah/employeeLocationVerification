
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_mobile_app/core/services/location_decode_services.dart';
// import 'package:my_mobile_app/core/widgets/loading_widget.dart';
// import 'package:my_mobile_app/features/devices/presentation/providers/location_provider.dart';
// import 'package:my_mobile_app/features/devices/presentation/providers/permission_provider.dart';
// import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
// import 'package:my_mobile_app/features/task/presentation/provider/task_complete_provider.dart';
// import 'package:permission_handler/permission_handler.dart';



// class LocationCameraView extends ConsumerWidget {
//   const LocationCameraView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final permissions = ref.watch(permissionsProvider);
//     final location = ref.watch(currentLocationProvider);
//     print(location);
//     final bool faceVerifiection = true;
//     final taskCompleteProvider = ref.read(taskCompleteParamsProvider);
//     print("Testing the view");
//     return Scaffold(
//       appBar: AppBar(title: const Text('Camera & Location')),
//       body: permissions.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => Center(child: Text('Error: $error')),
//         data: (permissions) {
//           final cameraStatus = permissions[Permission.camera];
//           final locationStatus = permissions[Permission.location];
//           print(cameraStatus);
//           print(locationStatus);
//           if (cameraStatus?.isGranted == true && locationStatus?.isGranted == true) {
//             print("permission is granted");
//             // return _CameraContent(location: location);
//             return location.when(data: (d) {
//               print(d?.latitude);
//               print(d?.longitude);
//               LocationDecodeServices decodeLocation = LocationDecodeServices();
//               final response = decodeLocation.decodeCoordinate(d!.longitude, d.latitude);
//               response.then((succ){
//                 // taskCompleteProvider.copyWith(location: LocationModel(latitude: d.latitude!, longitude: d.longitude!, address: succ));
//                 taskCompleteProvider.copyWith(location: LocationParams(latitude: d.latitude!, longitude: d.longitude!, address: succ));
//               });
//               return Text("Data : $d");
//             }, 
//             error: (err, stc)=> ElevatedButton(onPressed: (){
//               print(taskCompleteProvider.location.toJson());
//             }, child: Text("Success")), 
//             loading: ()=> MyLoadingWidget());
//             // Show the camera;
//           }

//           // return _PermissionRequestView(
//           //   cameraStatus: cameraStatus,
//           //   locationStatus: locationStatus,
//           // );
//           return Text("Data");
//         },
//       ),
//     );
//   }
// }
