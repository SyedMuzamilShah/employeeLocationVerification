import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_data_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_detail_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_update_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/views/employee_view.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/detailwidget/delete_confirm_dialog.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/detailwidget/image_preview.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_route.dart';

class EmployeeDetailView extends ConsumerStatefulWidget {
  final EmployeeEntities employee;
  const EmployeeDetailView({super.key, required this.employee});

  @override
  ConsumerState<EmployeeDetailView> createState() => _EmployeeDetailViewState();
}

class _EmployeeDetailViewState extends ConsumerState<EmployeeDetailView> {
  late String selectedRole;
  late String selectedStatus;
  late bool imageAcceptedForToken;
  String? imageUrl;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.employee.role?.toLowerCase() ?? '';
    selectedStatus = widget.employee.status.name.toLowerCase();
    imageAcceptedForToken = widget.employee.imageAcceptedForToken;
    imageUrl = widget.employee.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final updateNotifier = ref.watch(employeeUpdateProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateNotifier.employeeId(widget.employee.id);
    });
    final detailState = ref.watch(employeeDetailProvider);
    final detailNotifier = ref.read(employeeDetailProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Delete Icon Show
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Employee Details",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await showDeleteConfirmationDialogForEmployee(
                    context,
                    detailNotifier,
                    widget.employee.id,
                  );
                  if (confirmed) {
                    mainContentWidget.value = MyEmployeeView();
                    ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
                      route: EmployeeRoute(),
                    );
                  }
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              )
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final imageWidget = detailState.isLoading
                  ? const MyLoadingWidget()
                  : ImagePreview(
                      image: imageUrl,
                      imageAcceptedForToken: imageAcceptedForToken,
                      onBtnClick: () async => _handleImageAccept(),
                      onBtnReject: () async => _handleImageReject(),
                    );

              return constraints.maxWidth > 600
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageWidget,
                        const SizedBox(width: 32),
                        Expanded(child: _buildForm(context, updateNotifier)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageWidget,
                        const SizedBox(height: 16),
                        _buildForm(context, updateNotifier),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageAccept() async {
    final params = EmployeeImageAllowParams(employeeId: widget.employee.id);
    await ref.read(employeeDetailProvider.notifier).imageAllow(params);
    setState(() {
      imageAcceptedForToken = true;
      hasChanges = true;
    });
    ref.invalidate(loadEmployeeProvider);
  }

  Future<void> _handleImageReject() async {
    final params = EmployeeImageAllowParams(employeeId: widget.employee.id);
    await ref.read(employeeDetailProvider.notifier).rejectImage(params);
    setState(() {
      imageAcceptedForToken = false;
      hasChanges = true;
    });
    ref.invalidate(loadEmployeeProvider);
  }

  Widget _buildForm(BuildContext context, EmployeeUpdateNotifier notifier) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.employee.name != null)
          _buildRow("Name", widget.employee.name!, textColor),
        _buildRow("Email", widget.employee.email, textColor),
        if (widget.employee.phone != null)
          _buildRow("Phone", widget.employee.phone!, textColor),
        if (widget.employee.employeeId != null)
          _buildRow("Employee ID", widget.employee.employeeId!, textColor),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Role",
          value: selectedRole,
          items: EmployeeRole.values.map((e) => e.name.toLowerCase()).toList(),
          onChanged: (val) {
            if (val != null && val != selectedRole) {
              final role = EmployeeRole.values.firstWhere(
                (e) => e.name.toLowerCase() == val.toLowerCase(),
              );
              notifier.employeeRoleChange(role);
              setState(() {
                selectedRole = val;
                hasChanges = true;
              });
            }
          },
        ),
        _buildDropdown(
          label: "Status",
          value: selectedStatus,
          items: EmployeeStatus.values.map((e) => e.name.toLowerCase()).toList(),
          onChanged: (val) {
            if (val != null && val != selectedStatus) {
              final status = EmployeeStatus.values.firstWhere(
                (e) => e.name.toLowerCase() == val.toLowerCase(),
              );
              notifier.employeeStateChnage(status);
              setState(() {
                selectedStatus = val;
                hasChanges = true;
              });
            }
          },
        ),
        const SizedBox(height: 24),
        if (hasChanges)
          MyCustomButton(
            btnText: 'Save Changes',
            onClick: () {
              ref.read(employeeProvider.notifier).updateEmployee(
                    ref.read(employeeUpdateProvider),
                  );
              setState(() => hasChanges = false);
              ref.invalidate(loadEmployeeProvider);
            },
          ),
      ],
    );
  }

  Widget _buildRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              isExpanded: true,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item[0].toUpperCase() + item.substring(1)),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
