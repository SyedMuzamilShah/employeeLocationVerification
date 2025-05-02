import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/organization_route_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/views/overview_view.dart';

class OrganizationCardWidget extends ConsumerWidget {
  final OrganizationEntities model;
  final Function() editFunction;
  final Function() deleteFunction;

  const OrganizationCardWidget({
    super.key,
    required this.model,
    required this.editFunction,
    required this.deleteFunction,
  });

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleSelect() async {
    final response = await ref.read(organizationProvider.notifier).organizationSaved(model);
    if (context.mounted && response) {
      mainContentWidget.value = OverView();
      ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
        route: OrganizationRoute(name: ref.read(organizationProvider).selectedOrganization!.name,)
      );
    }
  }
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and organization details
            Text(
              model.name,
              // style: Theme.of(context).textTheme.headline6?.copyWith(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Email: ${model.email}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              "Phone: ${model.phoneNumber}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              "Organization ID: ${model.organizationId}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // Edit and Delete actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => editFunction(),
                  tooltip: 'Edit Organization',
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteFunction(),
                  tooltip: 'Delete Organization',
                ),
              ],
            ),

            // Action buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyCustomButton(
                  onClick: () {
                    // Add action for visiting website if available
                  },
                  btnText: "Visit Website",
                  color: Colors.blueAccent,
                ),
                MyCustomButton(
                  onClick: () async {
                    handleSelect();
                  },
                  btnText: "Select",
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    
  }
  
}
