import 'package:flutter/material.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/detailwidget/image_preview.dart';

class EmployeeDetailView extends StatefulWidget {
  final EmployeeEntities employee;
  const EmployeeDetailView({super.key, required this.employee});

  @override
  State<EmployeeDetailView> createState() => _EmployeeDetailViewState();
}

class _EmployeeDetailViewState extends State<EmployeeDetailView> {
  late String selectedRole;
  late String selectedStatus;
  late bool imageAcceptedForToken;
  late bool uploadNewImage;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.employee.role!.toLowerCase();
    selectedStatus = widget.employee.status.name.toLowerCase();
    imageAcceptedForToken = widget.employee.imageAcceptedForToken;
    uploadNewImage = widget.employee.uploadNewImage;
    imageUrl = widget.employee.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Employee Details", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Wide layout
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImagePreview(image: imageUrl, imageAcceptedForToken: imageAcceptedForToken),
                    const SizedBox(width: 32),
                    Expanded(child: _buildForm(context)),
                  ],
                );
              } else {
                // Narrow layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImagePreview(image: imageUrl, imageAcceptedForToken: imageAcceptedForToken),
                    const SizedBox(height: 16),
                    _buildForm(context),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow("Name", widget.employee.name, textColor),
        _buildRow("Email", widget.employee.email, textColor),
        if (widget.employee.phone != null) _buildRow("Phone", widget.employee.phone!, textColor),
        if (widget.employee.employeeId != null) _buildRow("Employee ID", widget.employee.employeeId!, textColor),
        const SizedBox(height: 16),

        _buildDropdown(
          "Role",
          selectedRole,
          EmployeeRole.values.map((e) => e.name.toLowerCase()).toList(),
          (val) => setState(() => selectedRole = val ?? selectedRole),
        ),

        _buildDropdown(
          "Status",
          selectedStatus,
          EmployeeStatus.values.map((e) => e.name.toLowerCase()).toList(),
          (val) => setState(() => selectedStatus = val ?? selectedStatus),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(
              value: uploadNewImage,
              onChanged: (val) => setState(() => uploadNewImage = val ?? false),
            ),
            const Text("Upload new image"),
          ],
        ),

        if (uploadNewImage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MyCustomButton(
              btnText: 'Select Image',
              onClick: () {
                setState(() {
                  imageUrl = null;
                  imageAcceptedForToken = false;
                });
              },
            ),
          ),

        const SizedBox(height: 24),
        MyCustomButton(
          btnText: 'Save Changes',
          onClick: () {
            print("Updated role: $selectedRole");
            print("Updated status: $selectedStatus");
            print("Image accepted: $imageAcceptedForToken");
            print("Upload new image: $uploadNewImage");
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
          SizedBox(width: 120, child: Text("$label:", style: TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text("$label:", style: TextStyle(fontWeight: FontWeight.w600))),
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
