import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/auth/presentation/views/login_view.dart';
import 'package:my_desktop_app/features/auth/presentation/views/register_view.dart';
import 'package:my_desktop_app/features/dashboard/presentation/views/main_view.dart';
import 'package:my_desktop_app/features/splash/presentation/views/splash_view.dart';

class AppRoutes {
  static const String testing = '/testing';

  static const String splash = '/splash';
  static const String login = '/home';
  static const String register = '/register';
  static const String forgot = '/forgot';
  static const String changePassword = '/change-password';

  static const String dashborad = '/dashborad';

  static Route<Widget> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashView());

      case testing:
      //   // return MaterialPageRoute(builder: (_) => PayrollPage());
      //   // return MaterialPageRoute(builder: (_) => MyTaskView());
      //   // return MaterialPageRoute(builder: (_) => ContactListPage());
      //   // return MaterialPageRoute(builder: (_) => MySettingView());
        // return MaterialPageRoute(builder: (_) => MySettingView());
        // return MaterialPageRoute(builder: (_) => TaskDetailViewTesting());

      case login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterView());

      case forgot:
        return MaterialPageRoute(builder: (_) => Container());
      case changePassword:
        return MaterialPageRoute(builder: (_) => Container());

      case dashborad:
        return MaterialPageRoute(builder: (_) => MyDashBorad());
      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
