import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/camera/presentation/provider/image_capture_provider.dart';

class ImageCaptureView extends ConsumerWidget {
  const ImageCaptureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageCaptureProvider);
    final notifier = ref.read(imageCaptureProvider.notifier);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (state.controller != null)
              AspectRatio(
                aspectRatio: state.controller!.value.aspectRatio,
                child: CameraPreview(state.controller!),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: notifier.captureImage,
              child: const Text('Capture'),
            ),
            if (state.image != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.file(File(state.image!.path)),
              ),
          ],
        ),
      ),
    );
  }
}
