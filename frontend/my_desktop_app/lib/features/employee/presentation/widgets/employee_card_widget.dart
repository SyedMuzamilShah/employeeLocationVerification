import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_data_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_status_badge.dart';

class EmployeeCard extends ConsumerWidget {
  final EmployeeReadParams readParams;
  final EmployeeEntities employee;
  final VoidCallback? onStatusChanged;

  const EmployeeCard({
    super.key,
    required this.readParams,
    required this.employee,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(employeeProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      color: theme.cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with name and status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  employee.name ?? employee.userName ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                EmployeeStatusBadge(status: employee.status.name),
              ],
            ),
            const SizedBox(height: 8),

            // Email
            Row(
              children: [
                Icon(Icons.email, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  employee.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Org ID & Role
            Wrap(
              spacing: 12,
              children: [
                // Text(
                //   employee.organizationId,
                //   style: theme.textTheme.bodySmall?.copyWith(
                //     color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                //   ),
                // ),
                if (employee.role != null)
                  Text(
                    employee.role!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            _buildActionButtons(ref, notifier, context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      WidgetRef ref, EmployeeNotifier notifier, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void handleStatusChange(EmployeeStatus status) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Action'),
          content: Text(
            'Are you sure you want to mark this employee as ${status.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        final params = EmployeeStatusChangeParams(
          employeeId: employee.id,
          status: status,
        );
        final success = await notifier.employeeStatusChange(params);
        if (context.mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status updated to ${status.name}')),
          );
        }
        ref.invalidate(loadEmployeeProvider(readParams));
      }
    }

    if (employee.status == EmployeeStatus.rejected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: onStatusChanged ??
                () => handleStatusChange(EmployeeStatus.pending),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
            ),
            child: const Text('Set to Pending'),
          ),
        ],
      );
    }

    if (employee.status == EmployeeStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: onStatusChanged ??
                () => handleStatusChange(EmployeeStatus.verified),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
            ),
            child: const Text('Verify'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onStatusChanged ??
                () => handleStatusChange(EmployeeStatus.rejected),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Reject'),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
