
// import 'package:flutter/material.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';

// class PriorityBadge extends StatelessWidget {
//   final TaskPriority priority;

//    const PriorityBadge({required this.priority});

//   @override
//   Widget build(BuildContext context) {
//     final (color, text) = switch (priority) {
//       TaskPriority.low => (Colors.green, 'LOW'),
//       TaskPriority.medium => (Colors.orange, 'MED'),
//       TaskPriority.high => (Colors.red, 'HIGH'),
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }