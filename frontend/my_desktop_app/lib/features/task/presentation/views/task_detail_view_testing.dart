// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';


// class TaskDetailViewTesting extends StatelessWidget {
//   const TaskDetailViewTesting({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample task data
//     final task = Task(
//       id: 'TSK-2023-0456',
//       title: 'Inventory Check - Warehouse A',
//       description: 'Perform full inventory check of all items in Warehouse A. Verify quantities against system records and report discrepancies.',
//       status: TaskStatus.assigned,
//       createdAt: DateTime(2023, 5, 15, 9, 30),
//       dueDate: DateTime(2023, 5, 25, 17, 0),
//       distance: 1250,
//       address: '123 Industrial Park, Warehouse District, Cityville',
//       coordinates: const LatLng(51.509364, -0.128928),
//       employees: [
//         EmployeeAssignment(
//           name: 'John Smith',
//           avatar: 'JS',
//           status: AssignmentStatus.assigned,
//           deadline: DateTime(2023, 5, 25, 17, 0),
//           submittedAt: null,
//           submittedLate: false,
//           faceVerified: false,
//           validationMethod: ValidationMethod.auto,
//           pictureAllowed: true,
//           imageUrl: null,
//         ),
//         EmployeeAssignment(
//           name: 'Sarah Johnson',
//           avatar: 'SJ',
//           status: AssignmentStatus.inProgress,
//           deadline: DateTime(2023, 5, 25, 17, 0),
//           submittedAt: null,
//           submittedLate: false,
//           faceVerified: false,
//           validationMethod: ValidationMethod.auto,
//           pictureAllowed: true,
//           imageUrl: null,
//         ),
//         EmployeeAssignment(
//           name: 'Michael Chen',
//           avatar: 'MC',
//           status: AssignmentStatus.verified,
//           deadline: DateTime(2023, 5, 24, 17, 0),
//           submittedAt: DateTime(2023, 5, 24, 16, 45),
//           submittedLate: false,
//           faceVerified: true,
//           validationMethod: ValidationMethod.manually,
//           pictureAllowed: true,
//           imageUrl: 'https://example.com/image1.jpg',
//         ),
//       ],
//     );

//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             _buildHeader(task),
//             const SizedBox(height: 20),
            
//             // Main content
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Left column - Task info

//                   Expanded(
//                     flex: 1,
//                     child: Container(
//                       color: Colors.red,
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Column(
//                       children: [
//                         _buildTaskInfoCard(task),
//                         const SizedBox(height: 16),
//                         _buildAssignedEmployees(task),
//                       ],
//                     ),
//                   ),
                  
//                   const SizedBox(width: 16),
                  
//                   // Right column - Map
//                   Expanded(
//                     flex: 3,
//                     child: _buildMapCard(task),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(Task task) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Task Details',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue.shade700,
//           ),
//         ),
//         Text(
//           'Created: ${task.createdAt.toString().split(' ')[0]} | ID: ${task.id}',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade600,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTaskInfoCard(Task task) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               task.description,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Wrap(
//               spacing: 16,
//               runSpacing: 8,
//               children: [
//                 _buildStatusBadge(task.status),
//                 _buildInfoItem(Icons.calendar_today, 'Due: ${_formatDate(task.dueDate)}'),
//                 _buildInfoItem(Icons.place, '${task.distance}m away'),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildInfoItem(Icons.location_on, task.address),
//             _buildInfoItem(Icons.map, 'Coordinates: ${task.coordinates.latitude.toStringAsFixed(6)}, ${task.coordinates.longitude.toStringAsFixed(6)}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(TaskStatus status) {
//     Color backgroundColor;
//     Color textColor;
//     String statusText;
    
//     switch (status) {
//       case TaskStatus.created:
//         backgroundColor = Colors.grey.shade300;
//         textColor = Colors.grey.shade800;
//         statusText = 'CREATED';
//         break;
//       case TaskStatus.assigned:
//         backgroundColor = Colors.blue.shade200;
//         textColor = Colors.blue.shade800;
//         statusText = 'ASSIGNED';
//         break;
//       case TaskStatus.completed:
//         backgroundColor = Colors.orange.shade200;
//         textColor = Colors.orange.shade800;
//         statusText = 'COMPLETED';
//         break;
//       case TaskStatus.verified:
//         backgroundColor = Colors.green.shade200;
//         textColor = Colors.green.shade800;
//         statusText = 'VERIFIED';
//         break;
//     }
    
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         statusText,
//         style: TextStyle(
//           color: textColor,
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoItem(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 18, color: Colors.blue.shade400),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade700,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMapCard(Task task) {
//     return Card(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Icon(Icons.map, color: Colors.blue.shade400),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Task Location',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade700,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FlutterMap(
//               options: MapOptions(
//                 initialCenter : task.coordinates,
//                 initialZoom: 15.0,
//                 // interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
//               ),
//               children: [
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.task_detail_view',
//                 ),
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       point: task.coordinates,
//                       child:  Icon(
//                         Icons.location_pin,
//                         color: Colors.red,
//                         size: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAssignedEmployees(Task task) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Assigned Employees (${task.employees.length})',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade700,
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 100,
//               child: ListView.separated(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: task.employees.length,
//                 separatorBuilder: (context, index) => const SizedBox(width: 16),
//                 itemBuilder: (context, index) {
//                   return _buildEmployeeAvatar(task.employees[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeAvatar(EmployeeAssignment employee) {
//     return Tooltip(
//       message: employee.name,
//       preferBelow: false,
//       verticalOffset: 20,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(50),
//         onTap: () {},
//         child: PopupMenuButton<EmployeeAssignment>(
//           position: PopupMenuPosition.under,
//           itemBuilder: (context) => [
//             const PopupMenuItem(
//               enabled: false,
//               child: Text('Employee Details', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             const PopupMenuDivider(),
//             PopupMenuItem(
//               enabled: false,
//               child: _buildEmployeeDetails(employee),
//             ),
//           ],
//           child: Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _getEmployeeColor(employee.status),
//             ),
//             child: Center(
//               child: Text(
//                 employee.avatar,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmployeeDetails(EmployeeAssignment employee) {
//     return SizedBox(
//       width: 250,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _getEmployeeColor(employee.status),
//                 ),
//                 child: Center(
//                   child: Text(
//                     employee.avatar,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 employee.name,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildDetailRow('Status', _formatAssignmentStatus(employee.status)),
//           _buildDetailRow('Deadline', _formatDate(employee.deadline)),
//           if (employee.submittedAt != null) ...[
//             _buildDetailRow('Submitted', _formatDate(employee.submittedAt!)),
//             if (employee.submittedLate)
//               _buildDetailRow('', 'Submitted Late', isWarning: true),
//           ],
//           _buildDetailRow('Face Verified', employee.faceVerified ? 'Yes' : 'No'),
//           _buildDetailRow('Validation', employee.validationMethod == ValidationMethod.auto ? 'Auto' : 'Manual'),
//           _buildDetailRow('Picture Allowed', employee.pictureAllowed ? 'Yes' : 'No'),
//           if (employee.imageUrl != null) ...[
//             const SizedBox(height: 8),
//             const Text('Submitted Image:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             Image.network(
//               employee.imageUrl!,
//               height: 80,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 80,
//                 color: Colors.grey.shade200,
//                 child: const Center(child: Text('Image not available')),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {bool isWarning = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.w500,
//               color: isWarning ? Colors.red : Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getEmployeeColor(AssignmentStatus status) {
//     switch (status) {
//       case AssignmentStatus.assigned:
//         return Colors.blue.shade400;
//       case AssignmentStatus.inProgress:
//         return Colors.orange.shade400;
//       case AssignmentStatus.completed:
//         return Colors.purple.shade400;
//       case AssignmentStatus.verified:
//         return Colors.green.shade400;
//     }
//   }

//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
//   }

//   String _formatAssignmentStatus(AssignmentStatus status) {
//     return status.toString().split('.').last.toUpperCase();
//   }
// }

// // Data Models
// class Task {
//   final String id;
//   final String title;
//   final String description;
//   final TaskStatus status;
//   final DateTime createdAt;
//   final DateTime dueDate;
//   final int distance;
//   final String address;
//   final LatLng coordinates;
//   final List<EmployeeAssignment> employees;

//   const Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.status,
//     required this.createdAt,
//     required this.dueDate,
//     required this.distance,
//     required this.address,
//     required this.coordinates,
//     required this.employees,
//   });
// }

// class EmployeeAssignment {
//   final String name;
//   final String avatar;
//   final AssignmentStatus status;
//   final DateTime deadline;
//   final DateTime? submittedAt;
//   final bool submittedLate;
//   final bool faceVerified;
//   final ValidationMethod validationMethod;
//   final bool pictureAllowed;
//   final String? imageUrl;

//   const EmployeeAssignment({
//     required this.name,
//     required this.avatar,
//     required this.status,
//     required this.deadline,
//     this.submittedAt,
//     required this.submittedLate,
//     required this.faceVerified,
//     required this.validationMethod,
//     required this.pictureAllowed,
//     this.imageUrl,
//   });
// }

// enum TaskStatus { created, assigned, completed, verified }
// enum AssignmentStatus { assigned, inProgress, completed, verified }
// enum ValidationMethod { auto, manually }