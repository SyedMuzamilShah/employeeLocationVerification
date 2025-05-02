import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/route_display_widget.dart';
import 'package:my_desktop_app/features/task/presentation/views/my_task_view.dart';

class TaskRoute extends ConsumerWidget {
  final String? name;
  const TaskRoute({super.key, this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RouteDisplayWidget(
      routeText: 'Task',
      routeTextClick: () {
        ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
            route: RouteDisplayWidget(
          routeText: 'Task',
        ));
        mainContentWidget.value = MyTaskView();
        return;
      },
      subRouteText: name,
    );
  }
}
