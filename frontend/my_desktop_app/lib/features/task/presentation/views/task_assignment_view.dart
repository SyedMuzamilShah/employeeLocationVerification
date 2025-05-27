import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_params_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/tast_detail_load_provider.dart';
import 'package:my_desktop_app/features/task/presentation/views/task_detail_dialog.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/search_employee_assign_widget.dart';

class TaskAssignmentDetailView extends ConsumerWidget {
  final String taskId;
  final ScrollController? scrollController;

  const TaskAssignmentDetailView({
    super.key,
    this.scrollController,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paramsNotifier =
        ref.watch(taskAssignmentDetailParamsProvider(taskId).notifier);
    final currentParams = ref.watch(taskAssignmentDetailParamsProvider(taskId));
    final state = ref.watch(loadTaskDetailProvider(currentParams));

    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: TaskAssignmentStatus.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final value = TaskAssignmentStatus.values[index];
              return FilterChip(
                label: Text(value.name.toUpperCase()),
                selected: currentParams.status != null
                    ? currentParams.status == value
                    : value == TaskAssignmentStatus.all,
                onSelected: (_) {
                  paramsNotifier.state = currentParams.copyWith(status: value);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (list) {
              if (list.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCustomButton(
                      btnText: 'Assign',
                      onClick: () {
                        showMyDialog(
                          context,
                          SearchEmployeeAssignWidget(taskId: taskId),
                        );
                        ref.invalidate(loadTaskDetailProvider);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Center(child: Text('No Task Assignments Found')),
                  ],
                );
              }
              return ListView.builder(
                controller: scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final assignment = list[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showMyDialog(
                            context,
                            TaskAssignmentDetailDialog(assignment: assignment),
                            width: 400,
                          );
                        });
                      },
                      title: Text(assignment.employee.userName),
                      subtitle: Text('Status: ${assignment.status.name}'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (assignment.submittedAt != null)
                            Text('Submitted: ${assignment.submittedAt}'),
                          if (assignment.submittedAt != null)
                            Text('Is Late: ${assignment.submittedLate}'),
                          if (assignment.confidence != null)
                            Text('Confidence: ${assignment.confidence}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
