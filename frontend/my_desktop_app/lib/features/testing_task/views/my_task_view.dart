// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:intl/intl.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/priority_badge_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_card_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_details_view.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_form_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model_data.dart';

// // Main Dashboard
// class MyTaskView extends StatefulWidget {
//   const MyTaskView({super.key});

//   @override
//   State<MyTaskView> createState() => _MyTaskViewState();
// }

// class _MyTaskViewState extends State<MyTaskView> {
//   List<Task> _tasks = demoTasks;
//   TaskStatus? _filterStatus;
//   bool _showMapView = false;
//   LatLng? _selectedLocation;

//   void _addTask(Task newTask) {
//     setState(() {
//       _tasks = [..._tasks, newTask];
//     });
//   }

//   // void _updateTask(Task updatedTask) {
//   //   setState(() {
//   //     _tasks = _tasks
//   //         .map((task) => task.id == updatedTask.id ? updatedTask : task)
//   //         .toList();
//   //   });
//   // }

//   void _filterTasks(TaskStatus? status) {
//     setState(() {
//       _filterStatus = status;
//     });
//   }

//   void _toggleView() {
//     setState(() {
//       _showMapView = !_showMapView;
//     });
//   }

//   List<Task> get _filteredTasks {
//     if (_filterStatus == null) return _tasks; // Get All the status
//     return _tasks.where((task) => task.status == _filterStatus).toList(); // Get Which one is select
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           _buildStatusFilter(), 
//           Expanded(
//             child: _showMapView ? _buildMapView() : _buildListView(),
//           ),
//         ],
//       ),
//       floatingActionButton: Column(
//         spacing: 5,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton(
//             heroTag: 'View',
//             onPressed: _toggleView,
//             tooltip: _showMapView ? 'List View' : 'Map View',
//             child: Icon(_showMapView ? Icons.list : Icons.map),
//           ),
//           FloatingActionButton(
//             heroTag: 'Create',
//             onPressed: () => _showAddTaskDialog(context),
//             tooltip: 'Create New Task',
//             child: Icon(Icons.add),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusFilter() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Row(
//           children: [
//             const SizedBox(width: 8),
//             FilterChip(
//               label: const Text('All'),
//               selected: _filterStatus == null,
//               onSelected: (_) => _filterTasks(null),
//             ),
//             ...TaskStatus.values.map((status) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: FilterChip(
//                   label: Text(status.name.toUpperCase()),
//                   selected: _filterStatus == status,
//                   onSelected: (_) => _filterTasks(status),
//                 ),
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildListView() {
//     return ListView.builder(
//       itemCount: _filteredTasks.length,
//       itemBuilder: (context, index) {
//         final task = _filteredTasks[index];
//         return TaskCard(
//           currentUserId: task.id,
//           isAdmin: true,
//           onTaskCompletion: (task) {},
//           onTaskVerification: (task, status) {},
//           task: task,
//           users: demoUsers,
//           onTap: () => _showTaskDetails(context, task),
//           onStatusChange: (newStatus) {
//             setState(() {
//               task.status = newStatus;
//               if (newStatus == TaskStatus.completed) {
//                 task.completedAt = DateTime.now();
//               }
//             });
//           },
//         );
//       },
//     );
//   }

//   Widget _buildMapView() {
//     return FlutterMap(
//       options: MapOptions(
//         // center: const LatLng(37.7749, -122.4194),
//         initialCenter: const LatLng(37.7749, -122.4194),
//         // zoom: 10.0,
//         initialZoom: 10.0,
//         onTap: (_, latLng) {
//           setState(() {
//             _selectedLocation = latLng;
//           });
//         },
//       ),
//       children: [
//         TileLayer(
//           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//           userAgentPackageName: 'com.example.task_manager',
//         ),
//         MarkerLayer(
//           markers: _filteredTasks.where((t) => t.location != null).map((task) {
//             return Marker(
//               point: task.location!.toLatLng(),
//               width: 80,
//               height: 80,
//               child: GestureDetector(
//                 onTap: () => _showTaskDetails(context, task),
//                 child: Column(
//                   children: [
//                     PriorityBadge(priority: task.priority),
//                     Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 4,
//                             spreadRadius: 1,
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         task.title,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         if (_selectedLocation != null)
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: _selectedLocation!,
//                 width: 40,
//                 height: 40,
//                 child: const Icon(
//                   Icons.location_pin,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//       ],
//     );
//   }

//   void _showAddTaskDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Create New Task'),
//           content: TaskForm(
//             users: demoUsers,
//             initialLocation: _selectedLocation != null
//                 ? TaskLocation(
//                     latitude: _selectedLocation!.latitude,
//                     longitude: _selectedLocation!.longitude,
//                   )
//                 : null,
//             onSubmit:
//                 (title, description, dueDate, priority, assigneeId, location) {
//               final newTask = Task(
//                 id: DateTime.now().millisecondsSinceEpoch.toString(),
//                 title: title,
//                 description: description,
//                 dueDate: dueDate,
//                 priority: priority,
//                 creatorId: '1', // Assuming current user is creator
//                 assigneeId: assigneeId,
//                 createdAt: DateTime.now(),
//                 location: location,
//               );
//               _addTask(newTask);
//               Navigator.pop(context);
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _showTaskDetails(BuildContext context, Task task) {
//     // showModalBottomSheet(
//     //   context: context,
//     //   isScrollControlled: true,
//     //   builder: (context) {
//     //     return TaskDetailsSheet(
//     //       task: task,
//     //       users: demoUsers,
//     //       onUpdate: (updatedTask) {
//     //         _updateTask(updatedTask);
//     //         Navigator.pop(context);
//     //       },
//     //     );
//     //   },
//     // );
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TaskDetailsScreen(
//           task: task,
//           users: demoUsers,
//           // isAdmin: currentUser.isAdmin,
//           isAdmin: false,
//           // currentUserId: currentUser.id,
//           currentUserId: task.id,
//           onTaskCompletion: _handleTaskCompletion,
//           // onTaskCompletion: (_){},
//           onTaskVerification: _handleTaskVerification,
//           // onTaskVerification: (_,__){},
//         ),
//       ),
//     );
//   }

//   void _handleTaskCompletion(Task completedTask) {
//     setState(() {
//       _tasks = _tasks
//           .map((t) => t.id == completedTask.id ? completedTask : t)
//           .toList();
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Task completion submitted for review')),
//     );
//   }

//   void _handleTaskVerification(Task task, bool verified) {
//     setState(() {
//       _tasks = _tasks.map((t) {
//         if (t.id == task.id) {
//           return Task(
//             id: t.id,
//             title: t.title,
//             description: t.description,
//             dueDate: t.dueDate,
//             priority: t.priority,
//             status: verified ? TaskStatus.completed : TaskStatus.inProgress,
//             creatorId: t.creatorId,
//             assigneeId: t.assigneeId,
//             createdAt: t.createdAt,
//             completedAt: t.completedAt,
//             completedBy: t.completedBy,
//             // verifiedBy: verified ? currentUser.id : null,
//             verifiedBy: 'Admin',
//             verifiedAt: verified ? DateTime.now() : null,
//             location: t.location,
//             completionNotes: t.completionNotes,
//             completionMediaUrls: t.completionMediaUrls,
//           );
//         }
//         return t;
//       }).toList();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content:
//               Text(verified ? 'Task verified!' : 'Task returned for rework')),
//     );
//   }
// }

// // Task Details Sheet
// class TaskDetailsSheet extends StatelessWidget {
//   final Task task;
//   final List<AppUser> users;
//   final ValueChanged<Task> onUpdate;

//   const TaskDetailsSheet({
//     super.key,
//     required this.task,
//     required this.users,
//     required this.onUpdate,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final assignee = task.assigneeId != null
//         ? users.firstWhere((u) => u.id == task.assigneeId)
//         : null;
//     final creator = users.firstWhere((u) => u.id == task.creatorId);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             task.title,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           _buildMetaInfo(context),
//           const SizedBox(height: 16),
//           const Text('Description:',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           Text(task.description),
//           if (task.location != null) ...[
//             const SizedBox(height: 16),
//             const Text('Location:',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             _buildLocationMap(task.location!),
//           ],
//           const SizedBox(height: 16),
//           _buildUserInfo('Created By', creator),
//           if (assignee != null) _buildUserInfo('Assigned To', assignee),
//           const SizedBox(height: 16),
//           _buildStatusActions(context),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: () => _showEditForm(context),
//             child: const Text('Edit Task'),
//           ),
//         ],
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
//             // center: location.toLatLng(),
//             initialCenter: location.toLatLng(),
//             // zoom: 14.0,
//             initialZoom: 14.0,
//             // interactiveFlags: InteractiveFlag.none,
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
//                   child: const Icon(
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

//   Widget _buildMetaInfo(BuildContext context) {
//     return Wrap(
//       spacing: 16,
//       runSpacing: 8,
//       children: [
//         _MetaItem(
//           icon: Icons.calendar_today,
//           label: 'Due Date',
//           value: DateFormat('MMM dd, yyyy').format(task.dueDate),
//         ),
//         _MetaItem(
//           icon: Icons.priority_high,
//           label: 'Priority',
//           value: task.priority.name.toUpperCase(),
//           color: _getPriorityColor(task.priority),
//         ),
//         _MetaItem(
//           icon: Icons.circle,
//           label: 'Status',
//           value: task.status.name.toUpperCase(),
//           color: _getStatusColor(task.status),
//         ),
//       ],
//     );
//   }

//   Widget _buildUserInfo(String label, AppUser user) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
//         ListTile(
//           contentPadding: EdgeInsets.zero,
//           leading: CircleAvatar(
//             child: Text(user.name.split(' ').map((n) => n[0]).join()),
//           ),
//           title: Text(user.name),
//           subtitle: Text(user.email),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusActions(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       children: TaskStatus.values.map((status) {
//         return ChoiceChip(
//           label: Text(status.name.toUpperCase()),
//           selected: task.status == status,
//           onSelected: (_) {
//             task.status = status;
//             if (status == TaskStatus.completed) {
//               task.completedAt = DateTime.now();
//             }
//             onUpdate(task);
//             Navigator.pop(context);
//           },
//         );
//       }).toList(),
//     );
//   }

//   Color _getPriorityColor(TaskPriority priority) {
//     return switch (priority) {
//       TaskPriority.low => Colors.green,
//       TaskPriority.medium => Colors.orange,
//       TaskPriority.high => Colors.red,
//     };
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

//   void _showEditForm(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Task'),
//           content: TaskForm(
//             users: users,
//             initialLocation: task.location,
//             onSubmit:
//                 (title, description, dueDate, priority, assigneeId, location) {
//               final updatedTask = Task(
//                 id: task.id,
//                 title: title,
//                 description: description,
//                 dueDate: dueDate,
//                 priority: priority,
//                 status: task.status,
//                 creatorId: task.creatorId,
//                 assigneeId: assigneeId,
//                 createdAt: task.createdAt,
//                 completedAt: task.completedAt,
//                 location: location, // Added location parameter
//               );
//               onUpdate(updatedTask);
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//           ),
//         );
//       },
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
//             Text(value,
//                 style: TextStyle(fontWeight: FontWeight.bold, color: color)),
//           ],
//         ),
//       ],
//     );
//   }
// }
