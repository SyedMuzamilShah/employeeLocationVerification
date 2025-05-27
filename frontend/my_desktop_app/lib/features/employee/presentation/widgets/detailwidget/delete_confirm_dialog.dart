
import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_detail_provider.dart';
Future<bool> showDeleteConfirmationDialogForEmployee(
  BuildContext context,
  EmployeeDetailNotifier notifier,
  String employeeId,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
          'Are you sure you want to delete this employee? This action cannot be undone.',
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
                final model = EmployeeDeleteParams(employeeId: employeeId);
                await notifier.deleteEmployee(model);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Employee deleted successfully'),
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
