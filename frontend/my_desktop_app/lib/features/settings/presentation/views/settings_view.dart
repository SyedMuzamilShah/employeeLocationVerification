import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/provider/theme_provider.dart';
import 'package:my_desktop_app/features/auth/presentation/views/change_password_view.dart';
import 'package:my_desktop_app/features/auth/presentation/views/edit_profile_view.dart';
import 'package:my_desktop_app/features/dashboard/presentation/providers/user_profile_provider.dart';
import 'package:my_desktop_app/features/settings/presentation/widgets/setting_route.dart';

class MySettingView extends ConsumerWidget {
  const MySettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // User Profile Settings
        _buildSectionTitle('Account'),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Edit Profile'),
          onTap: () async {
            // Navigate to Edit Profile screen
            ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
                route: SettingRoute(
              name: 'Edit Profile',
            ));
            var userData = await ref.read(userDataProvider.future);
            mainContentWidget.value = EditProfileView(userProfile: userData);
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Change Password'),
          onTap: () {
            // Navigate to Edit Profile screen
            ref.read(routeDisplayProvider.notifier).state = RouteDisplayItem(
                route: SettingRoute(
              name: 'Change password',
            ));
            mainContentWidget.value = ChangePasswordView();
          },
        ),
        Divider(),
        // Notification Settings | Langauge | Mode
        _buildSectionTitle("App Preferences"),
        // ListTile(
        //   leading: Icon(Icons.notifications),
        //   title: Text('Notification Settings'),
        //   onTap: () {
        //     // Navigate to Notification Settings screen
        //   },
        // ),
        // ListTile(
        //   leading: Icon(Icons.language),
        //   title: Text('Language and Region'),
        //   onTap: () {
        //     // Navigate to Language Settings screen
        //   },
        // ),

        ListTile(
          leading: Icon(CupertinoIcons.collections),
          title: Text('Dark mode'),
          trailing: Switch(
            inactiveTrackColor: Theme.of(context).secondaryHeaderColor,
            activeColor: Theme.of(context).primaryColor,

            value: ref.watch(themeProvider) == ThemeMode.dark, // Example value
            onChanged: (value) {
              if (ref.watch(themeProvider) == ThemeMode.dark) {
                ref.watch(themeProvider.notifier).state = ThemeMode.light;
              } else {
                ref.watch(themeProvider.notifier).state = ThemeMode.dark;
              }
            },
          ),
        ),
        // Divider(),

        //     // Privacy & Support
        //     _buildSectionTitle('Privacy & Support'),
        //     ListTile(
        //       leading: Icon(Icons.privacy_tip),
        //       title: Text('Privacy and Security'),
        //       onTap: () {
        //         // Navigate to Privacy Settings screen
        //       },
        //     ),
        //     // Help and Support
        //     ListTile(
        //       leading: Icon(Icons.help),
        //       title: Text('Help and Support'),
        //       onTap: () {
        //         // Navigate to Help Center
        //       },
        //     ),
      ],
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600],
      ),
    ),
  );
}
