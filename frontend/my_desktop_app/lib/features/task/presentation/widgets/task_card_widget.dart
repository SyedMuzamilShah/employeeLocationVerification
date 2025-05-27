import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/location_indicator_widget.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/status_chip_widget.dart';

class TaskCard extends StatelessWidget {
  final TaskEntities taskModel;

  const TaskCard({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    taskModel.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                StatusChip(
                  status: taskModel.status,
                  onStatusChange: (value) {
                    debugPrint('Status changed to $value');
                  },
                ),
              ],
            ),
      
            const SizedBox(height: 12),
            const Divider(height: 1),
      
            /// Info Section
            const SizedBox(height: 12),
            _infoRow(
              context,
              label: "Description",
              value: taskModel.description,
            ),
            if (taskModel.location != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LocationIndicator(location: taskModel.location!),
              ),
      
            const SizedBox(height: 16),
      
            /// Assignees
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Assignees",
            //       style: theme.textTheme.bodyMedium?.copyWith(
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //     Row(children: _buildAssigneeAvatars()),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, {required String label, required String value}) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  // List<Widget> _buildAssigneeAvatars() {
  //   return [
  //     UserAvatar(user: AppUser(id: '1', name: 'John', email: 'john@example.com')),
  //     const SizedBox(width: 4),
  //     UserAvatar(user: AppUser(id: '2', name: 'Alice', email: 'alice@example.com')),
  //   ];
  // }
}
