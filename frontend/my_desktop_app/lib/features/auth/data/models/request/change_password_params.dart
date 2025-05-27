import 'package:equatable/equatable.dart';

class ChangePasswordParams extends Equatable {
  final String? oldPassword;
  final String? newPassword;
  const ChangePasswordParams({
    this.oldPassword,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    if (oldPassword == null || newPassword == null ){
      throw Exception('Old Password or new password required');
    }
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }

  ChangePasswordParams copyWith ({String? oldPassword, String? newPassword}) {
    return ChangePasswordParams(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword
    );
  } 
  @override
  List<Object?> get props => [oldPassword, newPassword];
}