import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_managemanat_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_managment_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/tast_detail_load_provider.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';

class ManualVerificationButtons extends ConsumerWidget {
  final TaskAssignmentEntity assignment;

  const ManualVerificationButtons({super.key, required this.assignment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(taskManagementProvider).isLoading;

    if (isLoading) {
      return const MyLoadingWidget();
    }

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        MyCustomButton(
          btnText: 'Verify Manually',
          onClick: () async {
            final params = TaskVerifiedParams(
              taskId: assignment.taskId,
              employeesId: [assignment.employee.id],
            );
            final response = await ref
                .read(taskManagementProvider.notifier)
                .taskVerifie(params);
            if (response) {
              ref.invalidate(loadTaskDetailProvider);
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(width: 10),
        MyCustomButton(
          btnText: 'Reject Request',
          color: Colors.redAccent,
          onClick: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Reject Confirmation"),
                content: const Text("Are you sure you want to reject this request?"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    child: const Text("Reject"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final rejectParams = TaskStatusChangeParams(taskId: assignment.taskId, status: TaskCurrentStatus.rejected, employeesId: [assignment.employee.id]);
              final rejected = await ref
                  .read(taskManagementProvider.notifier)
                  .taskStatusChange(rejectParams);

              if (rejected) {
                ref.invalidate(loadTaskDetailProvider);
                Navigator.pop(context);
              }
            }
          },
        ),
      
      
        const SizedBox(width: 10),
        MyCustomButton(
          btnText: 'Submit Again',
          color: Colors.brown,
          onClick: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Try Again Request Confirmation"),
                content: const Text("Are you sure you want to request try again"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  ElevatedButton(
                    child: const Text("Reject"),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final rejectParams = TaskStatusChangeParams(taskId: assignment.taskId, status: TaskCurrentStatus.assigned, employeesId: [assignment.employee.id]);
              final rejected = await ref
                  .read(taskManagementProvider.notifier)
                  .taskStatusChange(rejectParams);

              if (rejected) {
                ref.invalidate(loadTaskDetailProvider);
                Navigator.pop(context);
              }
            }
          },
        ),
      
      
      ],
    );
  }
}
