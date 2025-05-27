import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_desktop_app/core/provider/theme_provider.dart';
import 'package:my_desktop_app/core/routes/routes.dart';
import 'package:my_desktop_app/core/services/local_database_service.dart';
import 'package:my_desktop_app/core/services/token_service.dart';
import 'package:my_desktop_app/core/theme/app_theme.dart';
import 'package:my_desktop_app/di/di_registration.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(600, 700));
    setWindowMaxSize(Size.infinite);
  }
  await TokenService().initialize();
  await Hive.initFlutter();
  await LocalDatabaseService().init(); // Initialize local database
  await registerDi();

  runApp(ProviderScope(child: const MyApp()));
}

// ValueNotifier<Widget> valueNotifier = ValueNotifier(MyHomePage());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // static final GlobalKey<NavigatorState> navigatorKey =
  //     GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    // ValueNotifier<Widget> valueNotifier = ValueNotifier(Container());
    return MaterialApp(
      // navigatorKey: navigatorKey,
      title: 'LOCAFI',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // routes: {
      //   '/': (context) => SidebarXExampleApp(),
      //   '/': (context) => const MyDrawerWidget(),
      //   '/': (context) => const DashboardScreen(),
      //   '/': (context) => MyTestingApp(),
      //   '/about': (context) => const AboutPage(),
      //   '/contact': (context) => const ContactPage(),
      // },
    );
  }
}

// class MyHomePage extends BaseViewClass {
//   const MyHomePage({super.key});

//   @override
//   Widget buildMainContentArea() {
//     // return Container(
//     //   color: Colors.amber,
//     //   child: ListView.builder(
//     //     itemCount: 100,
//     //     itemBuilder: (context, index) {
//     //       return ListTile(
//     //         title: Text("database $index"),
//     //       );
//     //     },
//     //   ),
//     // );
//     return OverviewContent();
//   }

//   @override
//   Widget buildSideBarArea() {
//     return _buildDrawer();
//   }

//   @override
//   Widget buildTopBarArea() {
//     return _buildTopBar();
//   }
// }

// class AboutPage extends BaseViewClass {
//   const AboutPage({super.key});

//   @override
//   Widget buildMainContentArea() {
//     return Center(
//       child: Text(
//         "This is the About Page",
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }

//   @override
//   Widget buildSideBarArea() {
//     return _buildDrawer();
//   }

//   @override
//   Widget buildTopBarArea() {
//     return _buildTopBar();
//   }
// }

// class ContactPage extends BaseViewClass {
//   const ContactPage({super.key});

//   @override
//   Widget buildMainContentArea() {
//     return Center(
//       child: Text(
//         "This is the Contact Page",
//         style: TextStyle(fontSize: 24),
//       ),
//     );
//   }

//   @override
//   Widget buildSideBarArea() {
//     return _buildDrawer();
//   }

//   @override
//   Widget buildTopBarArea() {
//     return _buildTopBar();
//   }
// }

// /// Helper functions for Sidebar and TopBar (used in all pages)
// Widget _buildDrawer() {
//   return Drawer(
//     backgroundColor: Colors.red,
//     child: Column(
//       children: [
//         ListTile(
//           leading: const CircleAvatar(),
//           title: const Text("Home"),
//           onTap: () => _navigateTo('/'),
//         ),
//         ListTile(
//           leading: const CircleAvatar(),
//           title: const Text("About"),
//           onTap: () => _navigateTo('/about'),
//         ),
//         ListTile(
//           leading: const CircleAvatar(),
//           title: const Text("Contact"),
//           onTap: () => _navigateTo('/contact'),
//         ),
//         ListTile(
//           leading: const CircleAvatar(),
//           title: const Text("Location Testing.."),
//           onTap: () async {},
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildTopBar() {
//   // final bool isMobile = MediaQuery.of(context).size.width < 600;
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: LayoutBuilder(builder: (_, size) {
//       double width = size.maxWidth;
//       return Container(
//         height: 60,
//         color: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         child: Row(
//           children: [
//             // if (isMobile)
//             IconButton(
//               icon: Icon(Icons.menu),
//               onPressed: () {
//                 // Open drawer for mobile
//               },
//             ),
//             if (width > 555)
//               Text(
//                 'HELLO SCARLETTE!',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             if (width > 555) Spacer(),
//             // if (!isMobile)
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.notifications),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Icon(Icons.message),
//               onPressed: () {},
//             ),
//             CircleAvatar(
//               backgroundImage: NetworkImage(
//                   'https://www.hubspot.com/hubfs/parts-url_1.webp'),
//             ),
//           ],
//         ),
//       );
//     }),
//   );
// }

// /// Navigation Helper
// void _navigateTo(String route) {
//   BuildContext? context = MyApp.navigatorKey.currentContext;
//   if (context != null) {
//     Navigator.of(context).pushNamed(route);
//   }
// }
