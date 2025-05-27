// import 'package:flutter/material.dart';
// import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
// import 'package:my_mobile_app/features/task/presentation/widgets/permission_warning_card.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionWarningSection extends StatelessWidget {
//   final Map<Permission, PermissionStatus> permissions;
//   final TaskEntities task;

//   const PermissionWarningSection({
//     super.key,
//     required this.permissions,
//     required this.task,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final locationPermission = permissions[Permission.location] ?? PermissionStatus.denied;
//     final cameraPermission = permissions[Permission.camera] ?? PermissionStatus.denied;


//     final List<Widget> warnings = [];

//     // if (task.r && !locationPermission.isGranted) {
//       warnings.add(const PermissionWarningCard(
//                     icon: Icons.location_off,
//                     title: 'Location Access Required',
//                     description: 'Enable location to verify task completion',
//                     status: locationPermission,
//                     onFix: () => locationStatus!.isPermanentlyDenied
//                         ? openAppSettings()
//                         : ref.refresh(permissionsProvider),
//                   ));
//     // }

//     if (task.pictureAllowed && !cameraPermission.isGranted) {
//       warnings.add(const WarningCard(
//         message: 'Camera permission is required to take a verification photo.',
//       ));
//     }

//     if (warnings.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: warnings
//           .map((w) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8.0),
//                 child: w,
//               ))
//           .toList(),
//     );
//   }
// }
