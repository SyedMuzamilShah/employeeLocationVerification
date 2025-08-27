
// import 'package:flutter/material.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';

// class StatusChip extends StatelessWidget {
//   final TaskStatus status;
//   final ValueChanged<TaskStatus> onStatusChange;

//   const StatusChip({super.key, 
//     required this.status,
//     required this.onStatusChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = switch (status) {
//       TaskStatus.pending => Colors.blue,
//       TaskStatus.inProgress => Colors.purple,
//       TaskStatus.completed => Colors.green,
//       TaskStatus.cancelled => Colors.grey,
//       TaskStatus.created => Colors.brown,
//       TaskStatus.assigned => Colors.pink,
//     };

//     return InkWell(
//       onTap: () {
//         final newStatus = switch (status) {
//           TaskStatus.pending => TaskStatus.inProgress,
//           TaskStatus.inProgress => TaskStatus.completed,
//           TaskStatus.completed => TaskStatus.pending,
//           TaskStatus.cancelled => TaskStatus.pending,
//           TaskStatus.created => TaskStatus.created,
//           TaskStatus.assigned => TaskStatus.assigned,
//         };
//         onStatusChange(newStatus);
//       },
//       child: Chip(
//         label: Text(status.name.toUpperCase()),
//         labelStyle: const TextStyle(fontSize: 12),
//         backgroundColor: color.withOpacity(0.1),
//         side: BorderSide(color: color),
//         labelPadding: const EdgeInsets.symmetric(horizontal: 6),
//       ),
//     );
//   }
// }