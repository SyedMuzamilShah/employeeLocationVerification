import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_text_field.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';

class OrganizationAddWidget extends StatefulWidget {
  const OrganizationAddWidget({super.key});

  @override
  OrganizationAddWidgetState createState() => OrganizationAddWidgetState();
}

class OrganizationAddWidgetState extends State<OrganizationAddWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountryCode = '+1';
  final List<String> _countryCodes = ['+1', '+44', '+91', '+86', '+33'];

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController websiteController;
  late TextEditingController addressController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    websiteController = TextEditingController();
    addressController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, __) {
            final state = ref.watch(organizationProvider);
            final notifier = ref.watch(organizationProvider.notifier);

            Map<String, String> fieldErrors = {};
            if (state.errorList != null) {
              fieldErrors = {
                for (var e in state.errorList!) e['path']: e['msg']
              };
            }

            return Form(
              key: _formKey,
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Organization',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  

                  // Show loading indicator at the top
                  if (state.isLoading) ...[
                    MyLoadingWidget(),
                    
                  ],

                  // Display error message in a highlighted box
                  if (state.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ),

                  MyCustomTextField(
                    controller: nameController,
                    hintText: "Organization Name",
                    errorText: fieldErrors['name'],
                  ),
                  

                  MyCustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    errorText: fieldErrors['email'],
                  ),
                  

                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField<String>(
                          value: _selectedCountryCode,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountryCode = newValue;
                            });
                          },
                          items: _countryCodes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Code',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MyCustomTextField(
                          controller: phoneController,
                          hintText: 'Phone Number',
                          errorText: fieldErrors['phoneNumber'],
                        ),
                      ),
                    ],
                  ),
                  

                  MyCustomTextField(
                    controller: websiteController,
                    hintText: 'Website',
                    errorText: fieldErrors['website'],
                  ),
                  

                  MyCustomTextField(
                    controller: addressController,
                    hintText: 'Address',
                    errorText: fieldErrors['address'],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          notifier.clearState();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final model = OrganiztionCreatePrams(
                                    name: nameController.text,
                                    email: emailController.text,
                                    phoneNumber:
                                        "$_selectedCountryCode ${phoneController.text}",
                                    website: websiteController.text,
                                    address: addressController.text,
                                  );

                                  bool isCreate = await notifier.create(model: model);
                                  if (isCreate){
                                    if (context.mounted){
                                      ref.invalidate(organizationsLoadProvider);
                                      Navigator.pop(context);
                                    }
                                  }
                                }
                              },
                        child: const Text('Add'),
                      ),
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
