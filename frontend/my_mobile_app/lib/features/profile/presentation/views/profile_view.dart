import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_mobile_app/features/profile/presentation/provider/profile_provider.dart';
import 'package:my_mobile_app/features/profile/presentation/views/profile_image_view.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        onRefresh: () async {
          return await ref.refresh(profileProvider.future);
        },
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (user) => _ProfileContent(user: user),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final UserEntities user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        
          children: [
            ProfileImageSection(image: user.imageUrl,),
            const SizedBox(height: 16),
            if (user.name != null)
            Text(
              user.name!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(user.userName ?? user.email),
            const SizedBox(height: 20),
            // Add update button if needed
            ElevatedButton(
              onPressed: () {
                // Navigate to profile update screen
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}