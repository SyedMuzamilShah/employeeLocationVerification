import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/provider/image_picker_provider.dart';
import 'package:my_mobile_app/core/url/url.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_dialog_box.dart';
import 'package:my_mobile_app/core/widgets/toast_msg_widget.dart';
import 'package:my_mobile_app/features/profile/data/models/request/image_upload_params.dart';
import 'package:my_mobile_app/features/profile/presentation/provider/image_upload_provider.dart';
class ProfileImageSection extends ConsumerWidget {
  final String? image;
  const ProfileImageSection({super.key, this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to state changes here where it's allowed
    ref.listen<ImageUploadState>(imageUploadNotifierProvider, (_, state) {
      if (state.errorMessage != null) {
        showToastMessage(state.errorMessage!, false);
      }
      if (state.message != null) {
        print("Testing working");
        showToastMessage(state.message!, true);
      }
    });

    return CircleAvatar(
      radius: 50,
      backgroundImage: image != null
          ? NetworkImage(ServerUrl.replaceLocalhost(image!))
          : null,
      child: image == null
          ? InkWell(
              onTap: () => _showImageSourceOptions(context, ref),
              child: const Icon(Icons.person, size: 50))
          : null,
    );
  }

  void _showImageSourceOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ref
                      .read(imagePickerServiceProvider)
                      .pickFromCamera();
                  if (image != null) {
                    _uploadImage(context, ref, File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ref
                      .read(imagePickerServiceProvider)
                      .pickFromGallery();
                  if (image != null) {
                    _uploadImage(context, ref, File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImage(BuildContext context, WidgetRef ref, File imageFile) async {
    final notifier = ref.read(imageUploadNotifierProvider.notifier);
    
    showMyDialog(context, MyLoadingWidget(), isLoader: true, height: 50);

    try {
      await notifier.uploadImage(ImageUploadParams(image: imageFile));
      Navigator.pop(context); // Close loading dialog
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      showToastMessage(e.toString(), false);
    }
  }
}