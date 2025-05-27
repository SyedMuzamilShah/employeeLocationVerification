import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';


final splashControllerProvider = FutureProvider.autoDispose<bool>((ref) async {
  // print("object that is called");
  final auth = ref.watch(basicAuthProvider.notifier);
  var response = await auth.isLogin();
  return response.fold(
    (err) => false,
    (succ) => true);
});
