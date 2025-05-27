import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';

final profileProvider = FutureProvider.autoDispose<UserEntities>((ref) async {
  final user = await ref.read(basicAuthProvider.notifier).getUser();

  return user.fold(
    (error) => throw Exception(error.message),
    (user) => user);
});