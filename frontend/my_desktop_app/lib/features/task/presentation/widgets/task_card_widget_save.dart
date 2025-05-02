// import 'package:flutter/material.dart';
// import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/location_indicator_widget.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/status_chip_widget.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/task_completion_dialog_widget.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/task_model.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/task_verification_dialog_widget.dart';
// import 'package:my_desktop_app/features/task/presentation/widgets/user_avatar_widget.dart';

// class TaskCard extends StatelessWidget {
//   final TaskEntities taskModel;

//   const TaskCard({super.key, required this.taskModel});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Card(
//       color: theme.cardColor,
//       elevation: 1,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//         side: BorderSide(color: theme.dividerColor),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         // onTap: () => _handleCardTap(context),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Title Row
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       taskModel.title,
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),

//               /// Description
//               Text(
//                 taskModel.description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   color: theme.colorScheme.onSurface.withOpacity(0.8),
//                 ),
//               ),

//               /// Location
//               if (taskModel.location != null) ...[
//                 const SizedBox(height: 10),
//                 LocationIndicator(location: taskModel.location!),
//               ],

//               const SizedBox(height: 12),

//               /// Status + Assignees
//               Row(
//                 children: [
//                   StatusChip(
//                     status: taskModel.status,
//                     onStatusChange: (value) {
//                       debugPrint('Status changed to $value');
//                     },
//                   ),
//                   const Spacer(),
//                   ..._buildAssigneeAvatars(),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildAssigneeAvatars() {
//     // Replace this with actual assigned users when available
//     return [
//       UserAvatar(user: AppUser(id: '1', name: 'John', email: 'john@example.com')),
//       UserAvatar(user: AppUser(id: '2', name: 'Alice', email: 'alice@example.com')),
//     ];
//   }

//   // void _handleCardTap(BuildContext context) {
//   //   final isCompleted = taskModel.status == TaskStatus.completed;
//   //   // final isVerified = taskModel.verifiedBy != null;
//   //   final isVerified = taskModel.adminId != null;

//   //   if (!isCompleted) {
//   //     _showCompletionDialog(context);
//   //   } else if (isCompleted && !isVerified) {
//   //     _showVerificationDialog(context);
//   //   }
//   // }

//   // Future<void> _showCompletionDialog(BuildContext context) async {
//   //   await showDialog<TaskEntities>(
//   //     context: context,
//   //     builder: (context) => TaskCompletionDialog(
//   //       task: taskModel,
//   //       currentUserId: taskModel.adminId,
//   //     ),
//   //   );
//   // }

//   // Future<void> _showVerificationDialog(BuildContext context) async {
//   //   await showDialog<bool>(
//   //     context: context,
//   //     builder: (context) => TaskVerificationDialog(
//   //       task: taskModel,
//   //       currentUserId: taskModel.adminId,
//   //     ),
//   //   );
//   // }
// }
