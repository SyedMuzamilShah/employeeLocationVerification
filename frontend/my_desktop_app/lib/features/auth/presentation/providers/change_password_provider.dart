import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/auth/data/models/request/change_password_params.dart';
import 'package:my_desktop_app/features/auth/presentation/providers/auth_provider_register.dart';

final changePasswordProvider = FutureProvider.family.autoDispose(
  (ref, ChangePasswordParams params) async {
    final authUsecase = ref.read(authUsecaseProvider);
    return await authUsecase.changePassword(params);
  },
);