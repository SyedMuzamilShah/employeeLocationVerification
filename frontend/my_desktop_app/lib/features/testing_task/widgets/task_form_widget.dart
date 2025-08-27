//   // Enhanced Task Form with Location Picker
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:intl/intl.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';

// class TaskForm extends StatefulWidget {
//   final List<AppUser> users;
//   final TaskLocation? initialLocation;
//   final Function(String, String, DateTime, TaskPriority, String?, TaskLocation?) onSubmit;

//   const TaskForm({
//     super.key,
//     required this.users,
//     this.initialLocation,
//     required this.onSubmit,
//   });

//   @override
//   State<TaskForm> createState() => _TaskFormState();
// }

// class _TaskFormState extends State<TaskForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _addressController = TextEditingController();
//   DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
//   TaskPriority _priority = TaskPriority.medium;
//   String? _assigneeId;
//   TaskLocation? _location;

//   @override
//   void initState() {
//     super.initState();
//     _location = widget.initialLocation;
//     if (_location?.address != null) {
//       _addressController.text = _location!.address!;
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: _titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//               validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//             ),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 16),
//             _buildDatePicker(),
//             const SizedBox(height: 16),
//             _buildPrioritySelector(),
//             const SizedBox(height: 16),
//             _buildAssigneeDropdown(),
//             const SizedBox(height: 16),
//             _buildLocationSection(context),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _submitForm,
//               child: const Text('Create Task'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationSection(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(
//                   labelText: 'Address',
//                   hintText: 'Enter address or tap map',
//                 ),
//                 onChanged: (value) {
//                   if (_location != null) {
//                     _location = TaskLocation(
//                       latitude: _location!.latitude,
//                       longitude: _location!.longitude,
//                       address: value,
//                     );
//                   }
//                 },
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.map),
//               onPressed: () => _showMapPicker(context),
//             ),
//           ],
//         ),
//         if (_location != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 8),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_pin, size: 16, color: Colors.red),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Lat: ${_location!.latitude.toStringAsFixed(4)}, '
//                   'Lng: ${_location!.longitude.toStringAsFixed(4)}',
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   void _showMapPicker(BuildContext context) {
//     LatLng? selectedLocation = _location?.toLatLng();
    
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Select Location'),
//           content: SizedBox(
//             width: double.maxFinite,
//             height: 400,
//             child: FlutterMap(
//               options: MapOptions(
//                 // center: selectedLocation ?? const LatLng(37.7749, -122.4194),
//                 initialCenter: selectedLocation ?? const LatLng(37.7749, -122.4194),

//                 // zoom: 12.0,
//                 initialZoom: 12.0,
//                 onTap: (_, latLng) {
//                   selectedLocation = latLng;
//                 },
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.task_manager',
//                 ),
//                 if (selectedLocation != null)
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         point: selectedLocation!,
//                         width: 40,
//                         height: 40,
//                         child:  const Icon(
//                           Icons.location_pin,
//                           color: Colors.red,
//                           size: 40,
//                         ),
//                       ),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (selectedLocation != null) {
//                   setState(() {
//                     _location = TaskLocation(
//                       latitude: selectedLocation!.latitude,
//                       longitude: selectedLocation!.longitude,
//                       address: _addressController.text.isEmpty ? null : _addressController.text,
//                     );
//                   });
//                 }
//                 Navigator.pop(context);
//               },
//               child: const Text('Select'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildDatePicker() {
//     return ListTile(
//       title: const Text('Due Date'),
//       subtitle: Text(DateFormat('MMM dd, yyyy').format(_dueDate)),
//       trailing: const Icon(Icons.calendar_today),
//       onTap: () async {
//         final date = await showDatePicker(
//           context: context,
//           initialDate: _dueDate,
//           firstDate: DateTime.now(),
//           lastDate: DateTime.now().add(const Duration(days: 365)),
//         );
//         if (date != null) {
//           setState(() => _dueDate = date);
//         }
//       },
//     );
//   }

//   Widget _buildPrioritySelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Priority'),
//         Row(
//           children: TaskPriority.values.map((priority) {
//             return Expanded(
//               child: RadioListTile<TaskPriority>(
//                 title: Text(priority.name.toUpperCase()),
//                 value: priority,
//                 groupValue: _priority,
//                 onChanged: (value) => setState(() => _priority = value!),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildAssigneeDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _assigneeId,
//       decoration: const InputDecoration(labelText: 'Assign To'),
//       items: [
//         const DropdownMenuItem(value: null, child: Text('Unassigned')),
//         ...widget.users.map((user) {
//           return DropdownMenuItem(
//             value: user.id,
//             child: Text(user.name),
//           );
//         }),
//       ],
//       onChanged: (value) => setState(() => _assigneeId = value),
//     );
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       widget.onSubmit(
//         _titleController.text,
//         _descriptionController.text,
//         _dueDate,
//         _priority,
//         _assigneeId,
//         _location,
//       );
//     }
//   }
// }
