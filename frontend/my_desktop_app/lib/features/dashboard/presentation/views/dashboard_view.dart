import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/features/dashboard/presentation/providers/view_provider.dart';
import 'package:my_desktop_app/features/organization/presentation/views/organization_view.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/organization_route_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/views/overview_view.dart';

class MyDashBoradOverView extends ConsumerWidget {
  const MyDashBoradOverView({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrg = ref.watch(isOrganizationProvider);
    return isOrg.when(
        loading: () => Center(
              child: MyLoadingWidget(),
            ),
        error: (error, stack) => Center(
              child: Text(error.toString()),
            ),
        data: (data) {
          if (data) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(routeDisplayProvider.notifier).state =
                  RouteDisplayItem(route: OrganizationRoute());
            });
          }
          return data ? OverView() : OrganizationView();
        });
  }
}