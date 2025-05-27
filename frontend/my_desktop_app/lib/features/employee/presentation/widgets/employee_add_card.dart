import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_data_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_provider.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';

class EmployeeAddWidget extends StatefulWidget {
  const EmployeeAddWidget({super.key});

  @override
  EmployeeAddWidgetState createState() => EmployeeAddWidgetState();
}

class EmployeeAddWidgetState extends State<EmployeeAddWidget> {
  final _formKey = GlobalKey<FormState>();
  // final List<String> _roles = ['Servant', 'Manager', 'Security'];
  final List<String> _countryCodes = ['+92'];

  String? _selectedCountryCode = '+92';
  String? _selectedRole;
  File? _profileImage;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organizationIdController =
      TextEditingController();

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _profileImage = File(result.files.single.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, ref, __) {
            final orgState =
                ref.watch(organizationProvider).selectedOrganization;
            final organizationId =
                orgState?.id ?? 'No organization selected';
            final state = ref.watch(employeeProvider);
            final notifier = ref.watch(employeeProvider.notifier);

            Map<String, String> fieldErrors = {
              for (var e in state.errorList ?? []) e['path']: e['msg']
            };

            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // spacing: 10,
                children: [
                  Center(
                    child: Text(
                      'Add New Employee',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (state.isLoading) const Center(child: MyLoadingWidget()),

                  // Display error message in a highlighted box
                  if (state.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),

                  // Profile picture section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: colorScheme.surfaceVariant,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const NetworkImage(
                                      'https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_1280.png',
                                    ) as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.surface,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 12,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to change photo',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form fields
                  Text(
                    'Basic Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MyCustomTextField(
                    controller: userNameController,
                    labelText: "Username",
                    hintText: "Enter your username",
                    errorText: fieldErrors['userName'],
                    prefixIcon: Icons.person_outline,
                  ),
                  MyCustomTextField(
                    controller: nameController,
                    labelText: "Full Name",
                    hintText: "Enter your full name",
                    errorText: fieldErrors['name'],
                    prefixIcon: Icons.badge_outlined,
                  ),
                  MyCustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    errorText: fieldErrors['email'],
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  MyCustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: 'Password',
                    errorText: fieldErrors['password'],
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                  ),

                  // Phone number
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          onChanged: (value) =>
                              setState(() => _selectedCountryCode = value),
                          items: _countryCodes
                              .map((code) => DropdownMenuItem(
                                    value: code,
                                    child: Text(code),
                                  ))
                              .toList(),
                          decoration: InputDecoration(
                            labelText: 'Country Code',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MyCustomTextField(
                          controller: phoneController,
                          // labelText: 'Phone Number',
                          hintText: 'Phone Number',
                          errorText: fieldErrors['phoneNumber'],
                          // keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Role and Organization
                  // Role and Organization section
                  Text(
                    'Employment Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    onChanged: (value) => setState(() => _selectedRole = value),
                    items: EmployeeRole.values.map((role) {
                      return DropdownMenuItem<String>(
                        value: role.name, // Convert enum to string
                        child: Text(role.name),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Role',
                      prefixIcon: const Icon(Icons.work_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: colorScheme.outline.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surfaceVariant.withOpacity(0.4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.business_outlined,
                            color: colorScheme.onSurface.withOpacity(0.6)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Organization ID',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              organizationId,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          notifier.clearState();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          side: BorderSide(color: colorScheme.outline),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      const SizedBox(width: 16),
                      MyCustomButton(
                          btnText: 'Create Employee',
                          onClick: state.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final prams = EmployeeCreateParams(
                                      userName: userNameController.text.trim(),
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      phoneNumber:
                                          "${_selectedCountryCode ?? ''}${phoneController.text.trim()}",
                                      role: _selectedRole ?? 'Servant',
                                      organizationId: organizationId,
                                      image: _profileImage,
                                    );

                                    final created =
                                        await notifier.addEmployee(prams);
                                    if (created && context.mounted) {
                                      ref.invalidate(loadEmployeeProvider);
                                      Navigator.pop(context);
                                    }
                                  }
                                }),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    organizationIdController.dispose();
    super.dispose();
  }
}
