// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:my_mobile_app/core/failure/failure.dart';
// import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
// import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
// import 'package:my_mobile_app/features/task/presentation/provider/task_complete_provider.dart';

// class TaskForm extends ConsumerStatefulWidget {
//   const TaskForm({super.key});

//   @override
//   TaskFormState createState() => TaskFormState();
// }

// class TaskFormState extends ConsumerState<TaskForm> {
//   final _taskAssignmentIdController = TextEditingController();
//   DateTime? _selectedTime;
//   File? _imageFile;
//   double? _latitude;
//   double? _longitude;

//   final ImagePicker _picker = ImagePicker(); // Image Picker instance

//   @override
//   Widget build(BuildContext context) {
//     final taskCompleteState = ref.watch(taskCompleteProvider);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: taskCompleteState.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stack) => _buildErrorWidget(error),
//         data: (task) => Form(
//           child: Column(
//             children: [
//               _taskAssignmentIdField(),
//               _selectDateTimeField(),
//               _captureImageButton(),
//               if (_imageFile != null) _displayCapturedImage(),
//               _locationFields(),
//               _submitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorWidget(error) {
//     if (error is Failure) {
//       return Column(
//         children: [
//           Text('Error: ${error.message}'),
//           if (error is ValidationFailure)
//             ...error.errors.map((entry) => Text('${entry.key}: ${entry.value}')),
//             Text('Suggestion: ${error.message}'),
//         ],
//       );
//     }
//     return const Text('Unknown error occurred');
//   }

//   Widget _taskAssignmentIdField() {
//     return TextFormField(
//       controller: _taskAssignmentIdController,
//       decoration: const InputDecoration(
//         labelText: 'Task Assignment ID',
//       ),
//     );
//   }

//   Widget _selectDateTimeField() {
//     return ListTile(
//       title: Text('Selected Time: ${_selectedTime?.toLocal().toString() ?? 'No time selected'}'),
//       trailing: const Icon(Icons.calendar_today),
//       onTap: _selectDateTime,
//     );
//   }

//   Widget _captureImageButton() {
//     return ElevatedButton(
//       onPressed: _captureImage,
//       child: const Text('Capture Image from Camera'),
//     );
//   }

//   Widget _displayCapturedImage() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child:  _imageFile != null
//     ? Image.file(_imageFile!) // for local file
//     : const Text("No image selected"),
//     );
//   }

//   Widget _locationFields() {
//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             decoration: const InputDecoration(
//               labelText: 'Latitude',
//             ),
//             keyboardType: TextInputType.number,
//             onChanged: (value) {
//               _latitude = double.tryParse(value);
//             },
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: TextFormField(
//             decoration: const InputDecoration(
//               labelText: 'Longitude',
//             ),
//             keyboardType: TextInputType.number,
//             onChanged: (value) {
//               _longitude = double.tryParse(value);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _submitButton() {
//     return ElevatedButton(
//       onPressed: _submitTask,
//       child: const Text('Complete Task'),
//     );
//   }

//   Future<void> _selectDateTime() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   Future<void> _submitTask() async {
//     if (_taskAssignmentIdController.text.isEmpty) {
//       _showErrorDialog("Task Assignment ID is required.");
//       return;
//     }

//     if (_latitude == null || _longitude == null) {
//       _showErrorDialog("Please provide valid latitude and longitude.");
//       return;
//     }

//     final taskParams = TaskCompletingParams(
//       taskAssignmentId: _taskAssignmentIdController.text,
//       currentTime: _selectedTime ?? DateTime.now(),
//       image: _imageFile,
//       // location: LocationModel(latitude: _latitude!, longitude: _longitude!),
//       location: LocationParams(latitude: _latitude!, longitude: _longitude!),
//     );

//     ref.read(taskCompleteParamsProvider.notifier).state = taskParams;
//     // ref.read(taskCompleteProvider.notifier).completeTask();
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _captureImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);

//     if (image != null) {
//       setState(() {
//         _imageFile = File(image.path);;
//       });
//     }
//   }
// }
