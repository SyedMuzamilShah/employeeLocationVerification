import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';

class CameraCaptureView extends ConsumerStatefulWidget {
  const CameraCaptureView({super.key});

  @override
  ConsumerState<CameraCaptureView> createState() => _CameraCaptureViewState();
}

class _CameraCaptureViewState extends ConsumerState<CameraCaptureView> {
  CameraController? _controller;
  bool _isCameraReady = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false, // 🔇 Audio disabled
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraReady = true);
      }
    } catch (e) {
      _showSnackBar('Camera error: $e');
    }
  }

  Future<void> _captureImage() async {
    if (!_isCameraReady || _controller == null) return;

    try {
      final image = await _controller!.takePicture();
      final imageFile = File(image.path);
      final sizeInKB = (await imageFile.length()) / 1024;

      if (mounted) {
        setState(() {
          _capturedImage = image;
          // ref.read(taskCompleteParamsProvider.notifier).state =
          //     ref.read(taskCompleteParamsProvider.notifier).state.copyWith(
          //           image: imageFile,
          //         );
          ref.read(taskCompletingParamsProvider.notifier).updateImage(imageFile);
        });

        _showSnackBar('Image captured (${sizeInKB.toStringAsFixed(1)} KB)');
      }
    } catch (e) {
      _showSnackBar('Capture failed: $e');
    }
  }

  void _retakePicture() {
    setState(() => _capturedImage = null);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Image')),
      body: _isCameraReady
          ? Stack(
              children: [
                _capturedImage == null
                    ? CameraPreview(_controller!)
                    : Center(child: Image.file(File(_capturedImage!.path))),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed:
                        _capturedImage == null ? _captureImage : _retakePicture,
                    child: Icon(
                        _capturedImage == null ? Icons.camera : Icons.refresh),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
