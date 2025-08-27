// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/location_indicator_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/priority_badge_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/status_chip_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_completion_dialog_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_model.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/task_verification_dialog_widget.dart';
// import 'package:my_desktop_app/features/testing_task/widgets/user_avatar_widget.dart';


// class TaskCard extends StatelessWidget {
//   final Task task;
//   final List<AppUser> users;
//   final VoidCallback onTap;
//   final ValueChanged<TaskStatus> onStatusChange;
//   final bool isAdmin;
//   final String currentUserId;
//   final Function(Task) onTaskCompletion;
//   final Function(Task, bool) onTaskVerification;

//   const TaskCard({
//     super.key,
//     required this.task,
//     required this.users,
//     required this.onTap,
//     required this.onStatusChange,
//     required this.isAdmin,
//     required this.currentUserId,
//     required this.onTaskCompletion,
//     required this.onTaskVerification,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final assignee = task.assigneeId != null
//         ? users.firstWhere((u) => u.id == task.assigneeId,
//             orElse: () => users.first)
//         : null;
//     final theme = Theme.of(context);

    
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _handleCardTap(context),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       task.title,
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   PriorityBadge(priority: task.priority),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 task.description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodyMedium,
//               ),
//               if (task.location != null) ...[
//                 const SizedBox(height: 8),
//                 LocationIndicator(location: task.location!),
//               ],
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   StatusChip(
//                     status: task.status,
//                     onStatusChange: onStatusChange,
//                   ),
//                   const Spacer(),
//                   if (assignee != null) UserAvatar(user: assignee),
//                 ],
//               ),
              
//               if (task.status == TaskStatus.completed &&
//                   task.verifiedBy == null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Pending Verification',
//                   style: TextStyle(
//                     color: Colors.orange[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ] else if (task.verifiedBy != null) ...[
//                 const SizedBox(height: 8),
//                 Text(
//                   'Verified by ${_getUserName(task.verifiedBy!)}',
//                   style: TextStyle(
//                     color: Colors.green[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleCardTap(BuildContext context) {
//     if (!isAdmin &&
//         task.assigneeId == currentUserId &&
//         task.status != TaskStatus.completed) {
//       _showCompletionDialog(context);
//     } else if (isAdmin &&
//         task.status == TaskStatus.completed &&
//         task.verifiedBy == null) {
//       _showVerificationDialog(context);
//     } else {
//       onTap();
//     }
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
//     }
//   }

//   String _getUserName(String userId) {
//     try {
//       return users.firstWhere((user) => user.id == userId).name;
//     } catch (e) {
//       return 'Admin';
//     }
//   }
// }
