import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/auth/data/models/request/change_password_params.dart';

final changePasswordProvider = StateNotifierProvider((ref){
  return ChangePasswordNotifier();
});

class ChangePasswordNotifier extends StateNotifier<ChangePasswordParams> {
  ChangePasswordNotifier(): super(ChangePasswordParams());

  oldPassowrd (String oldPassword) {
    state = state.copyWith(oldPassword: oldPassword);
  }

  newPassword (String newPassword) {
    state = state.copyWith(newPassword: newPassword);
  }
}


