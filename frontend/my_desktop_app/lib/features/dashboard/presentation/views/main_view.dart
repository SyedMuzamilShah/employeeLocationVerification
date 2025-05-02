import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/route_display_widget.dart';
import 'package:my_desktop_app/features/attandence/presentation/views/attendence_view.dart';
import 'package:my_desktop_app/features/dashboard/presentation/providers/view_provider.dart';
import 'package:my_desktop_app/features/dashboard/presentation/widgets/sidebar_widget.dart';
import 'package:my_desktop_app/features/dashboard/presentation/widgets/top_bar_widget.dart';
import 'package:my_desktop_app/features/employee/presentation/views/employee_view.dart';
import 'package:my_desktop_app/features/organization/presentation/views/organization_view.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/organization_route_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/views/overview_view.dart';
import 'package:my_desktop_app/features/settings/presentation/views/settings_view.dart';
import 'package:my_desktop_app/features/task/presentation/views/my_task_view.dart';
import 'package:sidebarx/sidebarx.dart';

class MyDashBoradView extends ConsumerWidget {
  const MyDashBoradView({super.key});

  // Method to check if organization is saved
  // Future<bool> _checkOrganizationStatus(WidgetRef ref) async {
  //   return await ref.read(organizationProvider.notifier).isOrganizationSaved();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrg = ref.watch(isOrganizationProvider);
    return isOrg.when(
        loading: () => Center(
              child: MyLoadingWidget(),
            ),
        error: (error, stack){
          return Center(
              child: Text(error.toString()),
            );
        },
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



class MyDashBorad extends ConsumerStatefulWidget {
  const MyDashBorad({super.key});

  @override
  ConsumerState<MyDashBorad> createState() => _MyDashBoradState();
}

class _MyDashBoradState extends ConsumerState<MyDashBorad> {
  late SidebarXController sideBarController;
  late TextStyle? routeStyle;

  @override
  void initState() {
    super.initState();
    sideBarController = ref.read(sideBarXControllerProvider);

    sideBarController.addListener(_updateSidebar);
  }

  void _updateSidebar() {
    if (!mounted) return; // Prevents execution if the widget is disposed

    updateMainContent();
    sidebarState.value = sideBarController.extended
        ? SidebarState(scale: 1.0, marginTop: 0.0, borderRadius: 0.0)
        : SidebarState(scale: 0.99, marginTop: 12.0, borderRadius: 8.0);
  }

  void updateMainContent() {
    // if (!mounted) return;

    final breadcrumbNotifier = ref.read(routeDisplayProvider.notifier);
    switch (sideBarController.selectedIndex) {
      case 0:
        mainContentWidget.value = MyDashBoradView();
        break;
      case 1:
        breadcrumbNotifier.state =
            RouteDisplayItem(route: RouteDisplayWidget(routeText: 'Employee'));
        mainContentWidget.value = MyEmployeeView();
        break;
      case 2:
        breadcrumbNotifier.state =
            RouteDisplayItem(route: RouteDisplayWidget(routeText: 'Attendance'));
        mainContentWidget.value = MyAttendenceView();

        break;
      case 3:
        breadcrumbNotifier.state =
            RouteDisplayItem(route: RouteDisplayWidget(routeText: 'Tasks'));
        mainContentWidget.value = MyTaskView();

        break;
      case 4:
        breadcrumbNotifier.state =
            RouteDisplayItem(route: RouteDisplayWidget(routeText: 'Settings'));
        mainContentWidget.value = MySettingView();
        break;
    }
  }

  @override
  void dispose() {
    sideBarController.removeListener(_updateSidebar);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = ref.watch(routeDisplayProvider);
    routeStyle =
        Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey);

    bool isMobile = MediaQuery.of(context).size.width <= 800;

    return Scaffold(
      appBar: isMobile ? AppBar() : null,
      drawer: ExampleSidebarX(controller: sideBarController),
      body: Row(
        children: [
          if (!isMobile) ExampleSidebarX(controller: sideBarController),
          Expanded(
            child: Column(
              children: [
                if (!isMobile)
                  ValueListenableBuilder<SidebarState>(
                    valueListenable: sidebarState,
                    builder: (context, state, child) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        transform: Matrix4.identity()..scale(state.scale),
                        margin: EdgeInsets.only(top: state.marginTop),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(state.borderRadius),
                          ),
                        ),
                        child: MyTopBarWidget(),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        breadcrumbs.name ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      breadcrumbs.route ?? const SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<SidebarState>(
                    valueListenable: sidebarState,
                    builder: (context, state, child) {
                      return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()..scale(state.scale),
                          margin: EdgeInsets.only(bottom: state.marginTop),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(state.borderRadius),
                            ),
                          ),
                          child: ValueListenableBuilder<Widget>(
                            valueListenable: mainContentWidget,
                            builder: (context, widget, child) {
                              return widget;
                            },
                          ));

                          // child: Consumer(builder: (context, ref, __) {
                          //   return ref.watch(mainContentProvider);
                          // }));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
