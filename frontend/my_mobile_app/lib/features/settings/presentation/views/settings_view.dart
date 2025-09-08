import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/provider/theme_provider.dart';
import 'package:my_mobile_app/core/routes/routes.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_dialog_box.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';
import 'package:my_mobile_app/features/auth/presentation/views/login_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.changePassword);
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.notifications),
            //   title: const Text('Notifications'),
            //   onTap: () {
            //     // Toggle or configure notifications
            //   },
            // ),
            ListTile(
              leading: Icon(CupertinoIcons.collections),
              title: Text('Dark mode'),
              trailing: Switch(
                inactiveTrackColor: Theme.of(context).secondaryHeaderColor,
                activeColor: Theme.of(context).primaryColor,

                value:
                    ref.watch(themeProvider) == ThemeMode.dark, // Example value
                onChanged: (value) {
                  if (ref.watch(themeProvider) == ThemeMode.dark) {
                    ref.watch(themeProvider.notifier).state = ThemeMode.light;
                  } else {
                    ref.watch(themeProvider.notifier).state = ThemeMode.dark;
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                showMyDialog(context, MyLoadingWidget(), isLoader: true);
                // try {
                //   await ref.read(basicAuthProvider.notifier).logout();
                //   // if (!context.mounted) return;

                // } catch (e) {
                //  print("$e"); 
                // }
                // if (!context.mounted) return;
                Navigator.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (_) {
                //   return LoginView();
                // }));
                Navigator.pushReplacementNamed(context, AppRoutes.login);
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }
}
