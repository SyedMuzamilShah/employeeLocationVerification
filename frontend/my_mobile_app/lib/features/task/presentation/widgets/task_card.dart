import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';

class TaskCard extends StatelessWidget {
  final TaskEntities task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueDate = DateFormat('MMM dd, yyyy - hh:mm a').format(task.dueDate ?? DateTime.now());

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title ?? 'No Title',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _TaskStatusBadge(status: task.status ?? TaskStatus.all),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  dueDate,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            if (task.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                task.description ?? 'No Description',
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;

  const _TaskStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case TaskStatus.completed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case TaskStatus.assigned:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case TaskStatus.rejected:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
      case TaskStatus.submitted:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.yellow.shade800;
        break;
      default:
        backgroundColor = theme.colorScheme.surface;
        textColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
