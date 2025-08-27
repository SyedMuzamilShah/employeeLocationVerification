import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';


// void showAddOrganizationDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: ConstrainedBox(

//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.4, // Responsive width
//             minWidth: 200,
//             minHeight: 100
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: OrganizationAddWidget(),
//               ),
//             ),
//       );
//     },
//   );
// }


// Edit organization dialog
void showEditOrganizationDialog(BuildContext context,
    OrganizationNotifier notifier, OrganizationEntities org) {
  final nameController = TextEditingController(text: org.name);
  final emailController = TextEditingController(text: org.email);
  final phoneController = TextEditingController(text: org.phoneNumber);
  final websiteController = TextEditingController(text: org.website);
  final addressController = TextEditingController(text: org.address);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Organization'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
                keyboardType: TextInputType.url,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                final model = OrganizationUpdatePrams(
                  id: org.id, 
                  name: nameController.text, 
                  email: emailController.text, 
                  phoneNumber: phoneController.text, 
                  website: websiteController.text, 
                  address: addressController.text);
                await notifier.update(
                 model: model
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}


void showDeleteConfirmationDialog(
  BuildContext context,
  OrganizationNotifier notifier,
  String orgId,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this organization? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context); // Close the dialog first
              try {
                final model = OrganizationDeletePrams(organizationId: orgId);
                await notifier.delete(model);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Organization deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}