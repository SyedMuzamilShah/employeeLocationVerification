
// // 3. Add Admin Verification Dialog
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';
// // 3. Add Admin Verification Dialog
// class TaskVerificationDialog extends StatelessWidget {
//   final Task task;
//   final String currentUserId;

//   const TaskVerificationDialog({
//     super.key,
//     required this.task,
//     required this.currentUserId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Verify Task Completion'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (task.completionNotes != null) ...[
//               const Text('Completion Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
//               Text(task.completionNotes!),
//               const SizedBox(height: 16),
//             ],
//             if (task.completionMediaUrls?.isNotEmpty ?? false) ...[
//               const Text('Completion Proof:', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               SizedBox(
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: task.completionMediaUrls!.length,
//                   itemBuilder: (ctx, index) => Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.network(task.completionMediaUrls![index], width: 80),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//             if (task.location != null) ...[
//               const Text('Location Verification:', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: FlutterMap(
//                   options: MapOptions(
//                     initialCenter: task.location!.toLatLng(),
//                     initialZoom: 15.0,
//                     interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: task.location!.toLatLng(),
//                           width: 40,
//                           height: 40,
//                           child:  const Icon(
//                             Icons.location_pin,
//                             color: Colors.red,
//                             size: 40,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context, false),
//           child: const Text('Reject'),
//         ),
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context, true),
//           child: const Text('Verify Completion'),
//         ),
//       ],
//     );
//   }
// }
