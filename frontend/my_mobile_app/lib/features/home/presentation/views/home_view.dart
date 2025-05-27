import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for SystemNavigator.pop()
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/home/presentation/provider/bottom_navigation_provider.dart';
import 'package:my_mobile_app/features/settings/presentation/views/settings_view.dart';
import 'package:my_mobile_app/features/task/presentation/views/task_read_view.dart';
import 'package:my_mobile_app/features/task/presentation/views/task_search_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static final List<Widget> _pages = [
    const TaskReadView(),
    TaskSearchView(),
    SettingsView()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavigationProvider);

    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          // Go back to index 0 instead of exiting
          ref.read(bottomNavigationProvider.notifier).state = 0;
          return false;
        } else {
          // Exit the app or move to background
          SystemNavigator.pop();
          return false;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) =>
              ref.read(bottomNavigationProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
