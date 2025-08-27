import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_create_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_provider.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/location_mark_widget.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/search_employee_assign_widget.dart';

class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({super.key});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _radiusController;

  final DateTime _dueDate = DateTime.now().add(const Duration(minutes: 30));

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _radiusController  = TextEditingController(text: '1000');
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final org = ref.watch(organizationProvider).selectedOrganization;
    
    final taskParamsNotifier = ref.watch(taskCreateParamsProvider.notifier);
    final taskState = ref.watch(taskProvider);
    final taskNotifier = ref.read(taskProvider.notifier);
    final fieldErrors = {
      for (var e in taskState.errorList ?? []) e['path']: e['msg']
    };

    if (org == null) {
      return const Center(child: Text("Please select an organization first"));
    }

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
                taskParamsNotifier.title(value);
              },
            ),
            MyCustomTextField(
              controller: _descriptionController,
              labelText: "Description",
              hintText: "Enter task description",
              errorText: fieldErrors['description'],
              prefixIcon: Icons.description,
              onChanged: (value) {
                taskParamsNotifier.description(value);
              },
              maxLines: 4,
            ),
            MyCustomTextField(
              controller: _radiusController,
              labelText: "Radius",
              keyboardType: TextInputType.number,
              hintText: "Enter task Radius",
              errorText: fieldErrors['radius'],
              prefixIcon: Icons.circle,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ],
              onChanged: (value) {
                if (value.isEmpty) return;

                taskParamsNotifier.radius(double.tryParse(value)!);
              },
            ),
            _buildDatePicker(taskParamsNotifier),
            _buildLocationSection(taskParamsNotifier),
            MyCustomButton(
              btnText: 'Create Task',
              onClick: () => _submitForm(taskNotifier, taskState, org.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Text(
        'Add New Task',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
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

  Widget _buildDatePicker(TaskCreateParamsNotifier taskParamsNotifier) {
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
          taskParamsNotifier.dueDate(picked);
        }
      },
    );
  }

  Widget _buildLocationSection(TaskCreateParamsNotifier taskParamsNotifier) {
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
              onPressed: () => showMyDialog(context, AddressSearchView(taskParamsNotifier: taskParamsNotifier,), height: 490),
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
    final paramsState = ref.read(taskCreateParamsProvider);
    if (!_formKey.currentState!.validate() || paramsState.location == null) {
      return;
    }

    final success = await notifier.create(model: paramsState);

    if (success && mounted) {
      Navigator.pop(context); // Pop the task created dialog

      // That will load the employee list and we can assign the created tast
      ref.invalidate(loadTaskProvider);
      final task = ref.read(taskProvider).currentTask;

      // Show the employee assign dialog
      showMyDialog(
        context,
        task != null
            ? SearchEmployeeAssignWidget(currentTask: task)
            : const Center(child: Text("Something went wrong")),
      );
    }
  }
}
