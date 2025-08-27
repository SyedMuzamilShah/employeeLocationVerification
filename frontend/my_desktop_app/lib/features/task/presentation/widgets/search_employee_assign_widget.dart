import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_data_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_search_field_widget.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_managment_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/tast_detail_load_provider.dart';

class SearchEmployeeAssignWidget extends ConsumerStatefulWidget {
  final TaskEntities? currentTask;
  final String? taskId;
  const SearchEmployeeAssignWidget({super.key, this.currentTask, this.taskId});

  @override
  ConsumerState<SearchEmployeeAssignWidget> createState() =>
      _SearchEmployeeAssignWidgetState();
}

class _SearchEmployeeAssignWidgetState
    extends ConsumerState<SearchEmployeeAssignWidget> {
  final TextEditingController _controller = TextEditingController();
  late EmployeeReadParams _params;
  late Map<String, TaskAssignEmployeeParams> selectedEmployees;

  @override
  void initState() {
    final orgId = ref.read(organizationProvider).selectedOrganization!.id;
    selectedEmployees = {};
    _params = EmployeeReadParams(organizationId: orgId);
    super.initState();
  }

  void _onAssignPressed() async {
    final notifier = ref.read(taskManagementProvider.notifier);
    final params = TaskAssignParams(
      taskId: widget.currentTask?.id ?? widget.taskId ?? '',
      employeesId: selectedEmployees.values.toList(),
    );

    var response  = await notifier.taskAssign(params);
    final state = ref.read(taskManagementProvider);

    if (!mounted) return;

    final message = state.error != null
        ? "Error: ${state.error}"
        : "Task assigned successfully.";
    if (response){
      ref.invalidate(loadTaskDetailProvider);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

    if (state.error == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final employeeResponse = ref.watch(loadEmployeeProvider(_params));
    final taskState = ref.watch(taskManagementProvider);

    return Column(
      children: [
        EmployeeSearchBar(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _params = _params.copyWith(searchQuery: value);
            });
          },
          initialParams: _params,
          onAdvancedSearch: (value) {
            setState(() {
              _params = value;
            });
          },
        ),
        const SizedBox(height: 12),
        if (taskState.error != null)
          Text(
            taskState.error!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Theme.of(context).colorScheme.error),
          ),
        Expanded(
          child: employeeResponse.when(
            loading: () => const Center(child: MyLoadingWidget()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (employees) {
              if (employees.isEmpty) {
                return const Center(child: Text('No employees found.'));
              }

              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  final isSelected = selectedEmployees.containsKey(employee.id);
                  final faceAllowed =
                      selectedEmployees[employee.id]?.pictureAllowed ?? false;
                  final faceVerification =
                      selectedEmployees[employee.id]?.faceVerification ?? false;
                  return ListTile(
                    title: Text(employee.name ?? employee.userName!),
                    // subtitle: Text(employee.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isSelected ? Icons.remove_circle : Icons.assignment_add,
                            color: isSelected ? Colors.red : Colors.green,
                          ),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                selectedEmployees.remove(employee.id);
                              } else {
                                selectedEmployees[employee.id] =
                                    TaskAssignEmployeeParams(
                                  employeeId: employee.id,
                                  faceVerification: false,
                                  pictureAllowed: false
                                );
                              }
                            });
                          },
                        ),
                      
                        Builder(builder: (_){
                          if (isSelected) {
                            return Row(
                            spacing: 10,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: faceAllowed,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedEmployees[employee.id] =
                                            selectedEmployees[employee.id]!
                                                .copyWith(pictureAllowed: value);
                                      });
                                    },
                                  ),
                                  const Text("Faild store face"),
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: faceVerification,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedEmployees[employee.id] =
                                            selectedEmployees[employee.id]!
                                                .copyWith(faceVerification: value);
                                      });
                                    },
                                  ),
                                  const Text("Face Verifiection"),
                                ],
                              ),
                            ],
                          );
                          } else {
                            return SizedBox.shrink();
                          }
                        })
                          
                      ],
                    ),
                    // Show checkbox if selected
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.email),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (selectedEmployees.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyCustomButton(
              btnText: taskState.isLoading ? 'Assigning...' : 'Assign',
              onClick: taskState.isLoading ? null : _onAssignPressed,
            ),
          ),
      ],
    );
  }
}
