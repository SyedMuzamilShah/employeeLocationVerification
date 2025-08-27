import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/bottom_controller_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_provider.dart';
import 'package:my_desktop_app/features/task/presentation/views/my_task_view.dart';
import 'package:my_desktop_app/features/task/presentation/views/task_assignment_view.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/Function/confirm_delete_task.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/task_route.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/task_update_dialog.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/Function/time_formate_func.dart';
import 'package:readmore/readmore.dart';

class TaskDetailView extends ConsumerStatefulWidget {
  final TaskEntities task;

  const TaskDetailView({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends ConsumerState<TaskDetailView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controllerState = ref.watch(taskDetailBottomControllerProvider);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerSection(theme),
                  const SizedBox(height: 20),
                  _infoTile("Description", widget.task.description),

                  _infoTile(
                      "Due Date", showTimeInFormattedFunction(widget.task.dueDate)),

                  _infoTile("Address", widget.task.location?.address ?? 'N/A'),
                  // const SizedBox(height: 12),
                  _infoTile('Coordinates', "${widget.task.location?.longitude.toStringAsFixed(4) ?? 'N/A'} | ${widget.task.location?.latitude.toStringAsFixed(4) ?? 'N/A'} Radius : ~${widget.task.aroundDistanceMeter} meter"),
                  SizedBox(height: 150,)
                  // ListTile(
                  //   contentPadding: EdgeInsets.zero,
                  //   leading: const Icon(Icons.map),
                  //   title: Text(
                  //     "Coordinates",
                  //     style: theme.textTheme.titleMedium
                  //         ?.copyWith(fontWeight: FontWeight.bold),
                  //   ),
                  //   subtitle: Text(
                  //     "${widget.task.location?.longitude.toStringAsFixed(4) ?? 'N/A'} | ${widget.task.location?.latitude.toStringAsFixed(4) ?? 'N/A'}\nRadius : ~${widget.task.aroundDistanceMeter}",
                  //     style: theme.textTheme.bodyMedium,
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: _infoTile('Coordinates', "${widget.task.location?.longitude.toStringAsFixed(4) ?? 'N/A'} | ${widget.task.location?.latitude.toStringAsFixed(4) ?? 'N/A'} Radius : ~${widget.task.aroundDistanceMeter}"),
                  // )
                ],
              ),
            ),
          ),

          // Default shown bottom popup with scrollable area
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.98,
            controller: controllerState,
            builder: (context, scrollController) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                          blurRadius: 1,
                          spreadRadius: 1),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: TaskAssignmentDetailView(
                    scrollController: scrollController,
                    taskId: widget.task.id,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Task Details",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                IconButton(
                  onPressed: () async {
                    // Add delete logic
                    showMyDialog(context, TaskUpdateDialogView(widget.task));
                    
                  },
                  icon: Icon(Icons.edit),
                  color: theme.colorScheme.primary,
                ),
                IconButton(
                  onPressed: () async {
                    // Add delete logic
                    await showDeleteConfirmationDialogForTask(context, ref.read(taskProvider.notifier), widget.task.id);
                    ref.invalidate(loadTaskProvider);
                    mainContentWidget.value = MyTaskView();
                    ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
                      route: TaskRoute()
                    );
                  },
                  icon: Icon(Icons.delete),
                  color: theme.colorScheme.error,
                )
              ],
            )
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.task.title, style: theme.textTheme.headlineMedium),
            _statusBadge(widget.task.status.name),
          ],
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, // You can adjust this value based on your layout
          child: Text(
            "$label :",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Expanded(
          // child: Text(
          //   value,
          //   style: const TextStyle(fontSize: 16),
          // ),
          child: ReadMoreText(
            value,
            trimLines: 2,
            style: const TextStyle(fontSize: 16),
            ),
        ),
      ],
    ),
  );
}


  Widget _statusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'CREATED':
        color = Colors.grey;
        break;
      case 'ASSIGNED':
        color = Colors.blue;
        break;
      case 'COMPLETED':
        color = Colors.green;
        break;
      case 'VERIFIED':
        color = Colors.purple;
        break;
      default:
        color = Colors.black;
    }
    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
