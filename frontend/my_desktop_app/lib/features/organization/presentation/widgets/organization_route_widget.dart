import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/route_display_widget.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/organization/presentation/views/organization_view.dart';

class OrganizationRoute extends ConsumerWidget {
  final String? name;
  const OrganizationRoute({super.key, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(organizationProvider);

    return RouteDisplayWidget(
      routeText: 'Organization',
      routeTextClick: () {
        // TODO: if you want to show the oganizationView then clear the saved organization
        // from local data base
        // notifier.clearAll();
        // notifier.read();
        ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
            route: RouteDisplayWidget(routeText: 'Organization'));
        mainContentWidget.value = OrganizationView();
        return;
      },
      subRouteText: name ?? state.selectedOrganization?.name,
    );
  }
}
