import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_create_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_update_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/tast_detail_load_provider.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/task_update_location_view.dart';

class TaskUpdateDialogView extends ConsumerStatefulWidget {
  final TaskEntities task;
  const TaskUpdateDialogView(this.task, {super.key});

  @override
  ConsumerState<TaskUpdateDialogView> createState() =>
      _TaskUpdateDialogViewState();
}

class _TaskUpdateDialogViewState extends ConsumerState<TaskUpdateDialogView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  final DateTime _dueDate = DateTime.now().add(const Duration(minutes: 30));
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final org = ref.watch(organizationProvider).selectedOrganization;

    final taskState = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);
    final fieldErrors = {
      for (var e in taskState.errorList ?? []) e['path']: e['msg']
    };

    if (org == null) {
      return const Center(child: Text("Please select an organization first"));
    }

    final updateParamsNotifier = ref.watch(taskUpdateParamsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateParamsNotifier.taskId(widget.task.id);
    });
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 10,
          children: [
            _buildHeader(theme, colorScheme),
            if (taskState.isLoading) const MyLoadingWidget(),
            if (taskState.errorMessage != null)
              _buildErrorBox(taskState.errorMessage!, colorScheme),
            MyCustomTextField(
              controller: _titleController,
              labelText: "Title",
              hintText: "Enter task title",
              errorText: fieldErrors['title'],
              prefixIcon: Icons.title,
              onChanged: (value) {
                updateParamsNotifier.title(value);
              },
            ),
            MyCustomTextField(
              controller: _descriptionController,
              labelText: "Description",
              hintText: "Enter task description",
              errorText: fieldErrors['description'],
              prefixIcon: Icons.description,
              onChanged: (value) {
                updateParamsNotifier.description(value);
              },
              maxLines: 4,
            ),
            _buildDatePicker(updateParamsNotifier),
            _buildLocationSection(updateParamsNotifier),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyCustomButton(
                  btnText: 'Cancel',
                  onClick: () => Navigator.pop(context),
                ),
                MyCustomButton(
                  btnText: 'Update Task',
                  onClick: () => _submitForm(taskNotifier, taskState, org.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Text(
        'Update Task',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildErrorBox(String message, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: colorScheme.error,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(TaskUpdateParamsNotifier updateParamsNotifier) {
    return ListTile(
      title: const Text('Due Date'),
      subtitle: Text(DateFormat('MMM dd, yyyy – hh:mm a').format(_dueDate)),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _dueDate,
          firstDate: DateTime.now().add(const Duration(minutes: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          updateParamsNotifier.dueDate(picked);
        }
      },
    );
  }

  Widget _buildLocationSection(TaskUpdateParamsNotifier updateParamsNotifier) {
    final state = ref.watch(taskCreateParamsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () => showMyDialog(
                  context,
                  AddressSearchUpdateView(
                      taskParamsNotifier: updateParamsNotifier),
                  height: 490),
            ),
          ],
        ),
        if (state.location != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              children: [
                const Icon(Icons.location_pin, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                if (state.location!.address != null)
                  Text(state.location!.address!),
                Text(
                  'Lat: ${state.location!.latitude.toStringAsFixed(4)}, '
                  'Lng: ${state.location!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _submitForm(TaskNotifier notifier, TaskState state, String orgId) async {
    final paramsState = ref.read(taskUpdateParamsProvider);
    if (!_formKey.currentState!.validate() || paramsState.id.isEmpty) {
      return;
    }

    final success = await notifier.update(paramsState);

    if (success && mounted) {
      Navigator.pop(context); // Pop the task created dialog

      // That will load the employee list and we can assign the created tast
      ref.invalidate(loadTaskDetailProvider);
      ref.invalidate(loadTaskProvider);
    }
  }
}
