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
    return RouteDisplayWidget(
      routeText: 'Organization',
      routeTextClick: () async {
        await ref.read(organizationProvider.notifier).clearOrganizationSaved();

        ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
            route: RouteDisplayWidget(routeText: 'Organization'));

          Future.microtask(() {
    mainContentWidget.value = const OrganizationView();
  });
        // mainContentWidget.value = OrganizationView();
        return;
      },
      subRouteText: name,
    );
  }
}
