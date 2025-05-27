import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_mobile_app/core/provider/theme_provider.dart';
import 'package:my_mobile_app/core/routes/routes.dart';
import 'package:my_mobile_app/core/services/local_database_service.dart';
import 'package:my_mobile_app/core/services/token_service.dart';
import 'package:my_mobile_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenService().initialize();
  await Hive.initFlutter();
  await LocalDatabaseService().init(); // Initialize local database
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
      title: 'Flutter Demo',
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