import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/features/camera/presentation/provider/camera_image_process_provider.dart';

class ImagePreviewScreen extends ConsumerWidget {
  final VoidCallback onOkPressed;
  final VoidCallback onRetakePressed;

  const ImagePreviewScreen({
    super.key,
    required this.onOkPressed,
    required this.onRetakePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(cameraImageProcessProvider).image;

    return Scaffold(
      appBar: AppBar(title: const Text("Preview Image")),
      body: Center(
        child: image == null
            ? const SizedBox(
                height: 200,
                child: Center(child: Text("No image captured")),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16), // rounded corners
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0), // same padding for both buttons
                    child: Row(
                      children: [
                        Expanded(
                          child: MyCustomButton(
                            btnText: 'Retake',
                            onClick: onRetakePressed,
                            icon: Icons.refresh,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: MyCustomButton(
                            btnText: 'OK',
                            onClick: onOkPressed,
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }
}
