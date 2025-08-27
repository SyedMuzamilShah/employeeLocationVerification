// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';
// // 2. Add Task Completion Dialog for Employees
// class TaskCompletionDialog extends StatefulWidget {
//   final Task task;
//   final String currentUserId;

//   const TaskCompletionDialog({
//     super.key,
//     required this.task,
//     required this.currentUserId,
//   });

//   @override
//   State<TaskCompletionDialog> createState() => _TaskCompletionDialogState();
// }

// class _TaskCompletionDialogState extends State<TaskCompletionDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final _notesController = TextEditingController();
//   List<String> _mediaUrls = [];

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Complete Task'),
//       content: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextFormField(
//                 controller: _notesController,
//                 decoration: const InputDecoration(
//                   labelText: 'Completion Notes',
//                   hintText: 'Describe the work done',
//                 ),
//                 maxLines: 3,
//                 validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//               ),
//               const SizedBox(height: 16),
//               const Text('Add Completion Proof:'),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.camera_alt),
//                     onPressed: _takePhoto,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.photo_library),
//                     onPressed: _pickImage,
//                   ),
//                 ],
//               ),
//               if (_mediaUrls.isNotEmpty)
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: _mediaUrls.length,
//                     itemBuilder: (ctx, index) => Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Image.network(_mediaUrls[index], width: 80),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               if (widget.task.location != null)
//                 _buildLocationVerification(widget.task.location!),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: _submitCompletion,
//           child: const Text('Submit Completion'),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationVerification(TaskLocation location) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Location Verification:'),
//         const SizedBox(height: 8),
//         Container(
//           height: 150,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: FlutterMap(
//             options: MapOptions(
//               initialCenter: location.toLatLng(),
//               initialZoom: 15.0,
//               // interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
//               interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               ),
//               MarkerLayer(
//                 markers: [
//                   Marker(
//                     point: location.toLatLng(),
//                     width: 40,
//                     height: 40,
//                     child: const Icon(
//                       Icons.location_pin,
//                       color: Colors.red,
//                       size: 40,
//                     ),
//                   ),
//                   Marker(
//                     point: _getCurrentLocation(), // You need to implement this
//                     width: 40,
//                     height: 40,
//                     child: const Icon(
//                       Icons.person_pin_circle,
//                       color: Colors.blue,
//                       size: 40,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Distance to task location: ${_calculateDistance(location).toStringAsFixed(2)} meters',
//           style: TextStyle(
//             color: _calculateDistance(location) > 100 
//                 ? Colors.red 
//                 : Colors.green,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _takePhoto() async {
//     // Implement camera capture
//     // Add the resulting image URL to _mediaUrls
//     setState(() {});
//   }

//   Future<void> _pickImage() async {
//     // Implement image picker
//     // Add the resulting image URL to _mediaUrls
//     setState(() {});
//   }

//   double _calculateDistance(TaskLocation location) {
//     // Implement distance calculation between current location and task location
//     return 0.0; // Replace with actual calculation
//   }

//   LatLng _getCurrentLocation() {
//     // Implement getting current location
//     return const LatLng(0, 0); // Replace with actual location
//   }

//   void _submitCompletion() {
//     if (_formKey.currentState!.validate()) {
//       final completedTask = Task(
//         id: widget.task.id,
//         title: widget.task.title,
//         description: widget.task.description,
//         dueDate: widget.task.dueDate,
//         priority: widget.task.priority,
//         status: TaskStatus.completed,
//         creatorId: widget.task.creatorId,
//         assigneeId: widget.task.assigneeId,
//         createdAt: widget.task.createdAt,
//         completedAt: DateTime.now(),
//         completedBy: widget.currentUserId,
//         location: widget.task.location,
//         completionNotes: _notesController.text,
//         completionMediaUrls: _mediaUrls,
//       );
//       // Update task in your state management
//       Navigator.pop(context, completedTask);
//     }
//   }
// }