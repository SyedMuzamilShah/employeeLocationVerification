
import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_provider.dart';
Future<bool> showDeleteConfirmationDialogForTask(
  BuildContext context,
  TaskNotifier notifier,
  String taskId,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // return false
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context, true); // return true
              try {
                final model = TaskDeleteParams(id: taskId);
                await notifier.delete(model);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  return result ?? false; // return false if user dismisses the dialog
}
