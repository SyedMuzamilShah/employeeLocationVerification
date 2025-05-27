import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/routes/routes.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/features/splash/presentation/providers/splash_provider.dart';

class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashControllerProvider, (previous, next) {
      next.when(
        data: (isAuthenticated) {
          if (isAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRoutes.dashborad);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
        loading: () {},
        error: (_, __) => Navigator.pushReplacementNamed(context, AppRoutes.login),
      );
    });

    return const Scaffold(
      body: Center(child: MyLoadingWidget()),
    );
  }
}
