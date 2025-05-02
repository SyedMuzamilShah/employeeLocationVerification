import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/route_display_widget.dart';
import 'package:my_desktop_app/features/employee/presentation/views/employee_view.dart';

class EmployeeRoute extends ConsumerWidget {
  final String? name;
  const EmployeeRoute({super.key, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final routeStyle = theme.textTheme.bodySmall?.copyWith(
      // color: Colors.blue.shade700, // Updated color
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
    );

    return RouteDisplayWidget(
      routeText: 'Employee',
      routeTextClick: () {
        ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
            route: Text(
          'Employee',
          style: routeStyle,
        ));
        mainContentWidget.value = MyEmployeeView();
        return;
      },
      subRouteText: name,
    );
  }
}
