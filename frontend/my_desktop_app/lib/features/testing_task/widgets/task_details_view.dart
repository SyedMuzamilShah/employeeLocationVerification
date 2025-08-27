// // 2. Update your TaskDetailsScreen to include completion/verification
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:intl/intl.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_completion_dialog_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_verification_dialog_widget.dart';
// class TaskDetailsScreen extends StatelessWidget {
//   final Task task;
//   final List<AppUser> users;
//   final bool isAdmin;
//   final String currentUserId;
//   final Function(Task) onTaskCompletion;
//   final Function(Task, bool) onTaskVerification;

//   const TaskDetailsScreen({
//     super.key,
//     required this.task,
//     required this.users,
//     required this.isAdmin,
//     required this.currentUserId,
//     required this.onTaskCompletion,
//     required this.onTaskVerification,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final assignee = task.assigneeId != null 
//         ? users.firstWhere((u) => u.id == task.assigneeId, orElse: () => users.first)
//         : null;
//     final creator = users.firstWhere((u) => u.id == task.creatorId);
//     print('test');
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Task Details'),
//         actions: [
//           // if (!isAdmin && task.assigneeId == currentUserId && task.status != TaskStatus.completed)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: () => _showCompletionDialog(context),
//               tooltip: 'Mark as Complete',
//             ),
//           // if (isAdmin && task.status == TaskStatus.completed && task.verifiedBy == null)
//             IconButton(
//               icon: const Icon(Icons.verified),
//               onPressed: () => _showVerificationDialog(context),
//               tooltip: 'Verify Completion',
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Task Title and Priority
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     task.title,
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//                 _PriorityBadge(priority: task.priority, large: true),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Task Status and Dates
//             Wrap(
//               spacing: 16,
//               runSpacing: 8,
//               children: [
//                 _MetaItem(
//                   icon: Icons.circle,
//                   label: 'Status',
//                   value: task.status.name.toUpperCase(),
//                   color: _getStatusColor(task.status),
//                 ),
//                 _MetaItem(
//                   icon: Icons.calendar_today,
//                   label: 'Due Date',
//                   value: DateFormat('MMM dd, yyyy').format(task.dueDate),
//                 ),
//                 if (task.completedAt != null)
//                   _MetaItem(
//                     icon: Icons.check_circle,
//                     label: 'Completed',
//                     value: DateFormat('MMM dd, yyyy').format(task.completedAt!),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Description Section
//             const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Text(task.description),
//             const SizedBox(height: 24),

//             // Location Section
//             if (task.location != null) ...[
//               const Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
//               _buildLocationMap(task.location!),
//               const SizedBox(height: 8),
//               Text(
//                 task.location!.address ?? 
//                 'Coordinates: ${task.location!.latitude.toStringAsFixed(4)}, ${task.location!.longitude.toStringAsFixed(4)}',
//               ),
//               const SizedBox(height: 24),
//             ],

//             // People Section
//             const Text('People:', style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             _buildUserTile('Created By', creator),
//             if (assignee != null) _buildUserTile('Assigned To', assignee),
//             const SizedBox(height: 24),

//             // Completion/Verification Section
//             if (task.status == TaskStatus.completed) ...[
//               const Divider(),
//               const Text('Completion Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 8),
              
//               if (task.completedBy != null)
//                 _buildUserTile('Completed By', users.firstWhere((u) => u.id == task.completedBy!)),
              
//               if (task.completionNotes != null) ...[
//                 const SizedBox(height: 8),
//                 const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(task.completionNotes!),
//               ],
              
//               if (task.completionMediaUrls?.isNotEmpty ?? false) ...[
//                 const SizedBox(height: 8),
//                 const Text('Proof:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: task.completionMediaUrls!.length,
//                     itemBuilder: (ctx, index) => Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Image.network(task.completionMediaUrls![index], width: 80),
//                     ),
//                   ),
//                 ),
//               ],
              
//               if (task.verifiedBy != null) ...[
//                 const SizedBox(height: 8),
//                 _buildUserTile('Verified By', users.firstWhere((u) => u.id == task.verifiedBy!)),
//                 Text('Verified on ${DateFormat.yMd().add_jm().format(task.verifiedAt!)}'),
//               ] else if (isAdmin && task.status == TaskStatus.completed) ...[
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () => _showVerificationDialog(context),
//                   child: const Text('Verify Completion'),
//                 ),
//               ],
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationMap(TaskLocation location) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: FlutterMap(
//           options: MapOptions(
//             initialCenter: location.toLatLng(),
//             initialZoom: 14.0,
//             interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
//           ),
//           children: [
//             TileLayer(
//               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               userAgentPackageName: 'com.example.task_manager',
//             ),
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: location.toLatLng(),
//                   width: 40,
//                   height: 40,
//                   child:  Icon(
//                     Icons.location_pin,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildUserTile(String label, AppUser user) {
//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: CircleAvatar(
//         child: Text(user.name.split(' ').map((n) => n[0]).join()),
//       ),
//       title: Text(user.name),
//       subtitle: Text(user.email),
//     );
//   }

//   Color _getStatusColor(TaskStatus status) {
//     return switch (status) {
//       TaskStatus.pending => Colors.blue,
//       TaskStatus.inProgress => Colors.purple,
//       TaskStatus.completed => Colors.green,
//       TaskStatus.cancelled => Colors.grey,
//       TaskStatus.created => Colors.brown,
//       TaskStatus.assigned => Colors.pink,
//     };
//   }

//   Future<void> _showCompletionDialog(BuildContext context) async {
//     final result = await showDialog<Task>(
//       context: context,
//       builder: (context) => TaskCompletionDialog(
//         task: task,
//         currentUserId: currentUserId,
//       ),
//     );
//     if (result != null) {
//       onTaskCompletion(result);
//       Navigator.pop(context); // Close details screen after completion
//     }
//   }

//   Future<void> _showVerificationDialog(BuildContext context) async {
//     final verified = await showDialog<bool>(
//       context: context,
//       builder: (context) => TaskVerificationDialog(
//         task: task,
//         currentUserId: currentUserId,
//       ),
//     );
//     if (verified != null) {
//       onTaskVerification(task, verified);
//       Navigator.pop(context); // Close details screen after verification
//     }
//   }
// }

// class _PriorityBadge extends StatelessWidget {
//   final TaskPriority priority;
//   final bool large;

//   const _PriorityBadge({
//     required this.priority,
//     this.large = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final (color, text) = switch (priority) {
//       TaskPriority.low => (Colors.green, 'LOW'),
//       TaskPriority.medium => (Colors.orange, 'MED'),
//       TaskPriority.high => (Colors.red, 'HIGH'),
//     };

//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: large ? 12 : 8,
//         vertical: large ? 6 : 2,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: large ? 14 : 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// class _MetaItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color? color;

//   const _MetaItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//     this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: color),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label, style: const TextStyle(fontSize: 12)),
//             Text(
//               value,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }