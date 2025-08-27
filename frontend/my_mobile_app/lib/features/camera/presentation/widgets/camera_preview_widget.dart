import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/camera/presentation/provider/camera_image_process_provider.dart';

class CameraPreviewScreen extends ConsumerWidget {
  final CameraController controller;

  const CameraPreviewScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final probability =
        ref.watch(cameraImageProcessProvider.select((s) => s.probability));
    final currentStep =
        ref.watch(cameraImageProcessProvider.notifier).currentActionIndex;
    final conditionLength =
        ref.watch(cameraImageProcessProvider.notifier).conditionLength;
    final conditions = ref.watch(cameraImageProcessProvider).condition;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Positioned.fill(
        child: Column(
          children: [
            const SizedBox(height: 40),
      
            // Instruction text
            Text(
              'Please ${conditions ?? ''}',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Step ${currentStep + 1} of $conditionLength',
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
      
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Circular progress indicator
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: conditionLength > 0
                            ? (currentStep) / conditionLength
                            : 0,
                        strokeWidth: 10,
                        color: Colors.green,
                        backgroundColor: Colors.white24,
                      ),
                    ),
      
                    // Clip live camera feed into a circle
                    ClipOval(
                      child: SizedBox(
                        width: 215,
                        height: 215,
                        child: CameraPreview(controller),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            // ✅ Probability bottom left
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Probability of $conditions: ${probability != null ? "${probability.toStringAsFixed(2)}%" : "N/A"}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
