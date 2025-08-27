import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/camera_services.dart';
import 'package:my_mobile_app/core/utils/google_ml_function.dart';
import 'package:my_mobile_app/features/camera/presentation/provider/camera_image_process_provider.dart';
import 'package:my_mobile_app/features/camera/presentation/widgets/camera_preview_widget.dart';
import 'package:my_mobile_app/features/camera/presentation/widgets/image_show_widget.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';

class FaceDetectionPage extends ConsumerStatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  FaceDetectionPageState createState() => FaceDetectionPageState();
}

class FaceDetectionPageState extends ConsumerState<FaceDetectionPage> {
  CameraService cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    GoogleMlModelExecutor.faceDetector.close();
    cameraService.dispose();
    cameraService.stopStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cameraImageProcessProvider, (previous, next) async {
      if (next.verificationCompleted) {
        // Stop the stream and release buffers
        await cameraService.stopStream();
        GoogleMlModelExecutor.faceDetector.close();
        // Capture the image
        XFile image = await cameraService.captureImage();
        ref
            .read(taskCompletingParamsProvider.notifier)
            .updateImage(File(image.path));

        // Update the state with the captured image
        ref.read(cameraImageProcessProvider.notifier).updateImage(image);
      }
    });

    if (ref.watch(cameraImageProcessProvider).image != null) {
      return ImagePreviewScreen(onOkPressed: () {
        Navigator.pop(context);
      }, onRetakePressed: () {
        ref.read(cameraImageProcessProvider.notifier).updateImage(null);
        startFaceDetection();
      });
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text("Verify Your Identity"),
      ),
      body: cameraService.isInitialized
          ? CameraPreviewScreen(controller: cameraService.controller!)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> initializeCamera() async {
    try {
      await cameraService.initialize();
      if (mounted) {
        setState(() {});
        startFaceDetection();
      }
    } catch (e, _) {
      debugPrint("Camera initialization failed: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera initialization failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void startFaceDetection() {
    if (cameraService.isInitialized) {
      cameraService.startStream((CameraImage image) async {
        ref.read(cameraImageProcessProvider.notifier).detectFaces(image);
      });
    }
  }
}
