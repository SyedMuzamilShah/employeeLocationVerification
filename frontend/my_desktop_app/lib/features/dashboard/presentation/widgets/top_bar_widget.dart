import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/auth/presentation/providers/basic_auth_provider.dart';
import 'package:my_desktop_app/features/auth/presentation/views/edit_profile_view.dart';
import 'package:my_desktop_app/features/dashboard/presentation/providers/user_profile_provider.dart';
import 'package:my_desktop_app/features/settings/presentation/widgets/setting_route.dart';
import 'package:sidebarx/sidebarx.dart';

class MyTopBarWidget extends ConsumerWidget {
  final SidebarXController? sidebarXController;
  const MyTopBarWidget({super.key, this.sidebarXController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userDataProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Greeting text
        userProfile.when(
          data: (user) => Text.rich(
            TextSpan(
              text: "Hello! ",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(),
              children: [
                TextSpan(
                  text: user.userName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(),
                ),
              ],
            ),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => Text(
            "Failed to load user",
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.red),
          ),
        ),
    
        // Right: Avatar with dropdown
        userProfile.when(
          data: (user) => Stack(
            alignment: Alignment.bottomLeft,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage:
                    user.avatar != null ? NetworkImage(user.avatar!) : null,
                child:
                    user.avatar == null ? const Icon(Icons.person) : null,
              ),
              if (sidebarXController != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _DropDownMenu(sideBarXController: sidebarXController!),
                ),
            ],
          ),
          loading: () => const CircleAvatar(
            radius: 24,
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const CircleAvatar(
            radius: 24,
            child: Icon(Icons.error),
          ),
        ),
      ],
    );
  }
}

class _DropDownMenu extends ConsumerWidget {
  final SidebarXController sideBarXController;
  const _DropDownMenu({required this.sideBarXController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: ref.watch(basicAuthProvider).isLoading
          ? MyLoadingWidget()
          : const Icon(CupertinoIcons.drop, size: 5),
      onSelected: (value) async {
        switch (value) {
          case 'Profile':
            sideBarXController.selectIndex(4);
            ref.read(routeDisplayProvider.notifier).state =
                RouteDisplayItem(route: SettingRoute(name: "Profile"));
            final userData = await ref.read(userDataProvider.future);
            mainContentWidget.value = EditProfileView(userProfile: userData);
            break;

          case 'Settings':
            sideBarXController.selectIndex(3);
            break;

          case 'Logout':
            showMyDialog(context, MyLoadingWidget(), isLoader: true);
            final response = await ref.read(basicAuthProvider.notifier).logout();
            // if (!response)return;
            Navigator.pop(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("User Logout Successfully"),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            Navigator.popAndPushNamed(context, AppRoutes.login);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: "Profile",
          child: Text("Profile", style: Theme.of(context).textTheme.bodySmall),
        ),
        PopupMenuItem(
          value: "Settings",
          child: Text("Settings", style: Theme.of(context).textTheme.bodySmall),
        ),
        PopupMenuItem(
          value: "Logout",
          child: Text("Logout", style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
