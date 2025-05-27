import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/route_display_widget.dart';
import 'package:my_desktop_app/features/settings/presentation/views/settings_view.dart';

class SettingRoute extends ConsumerWidget {
  final String? name;
  const SettingRoute({super.key, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RouteDisplayWidget(
      routeText: 'Settings',
      routeTextClick: () {
        ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
            route: RouteDisplayWidget(
          routeText: 'Settings',
        ));
        mainContentWidget.value = MySettingView();
        return;
      },
      subRouteText: name,
    );
  }
}
