import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraService {
  CameraController? _controller;
  bool _isInitialized = false;

  Future<void> _checkPermissions() async {
    if (kIsWeb) return;

    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        throw CameraException('Permission Denied', 'Camera permission not granted');
      }
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _checkPermissions();
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw CameraException('No Camera', 'No camera found');

    _controller = CameraController(
      cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      ),
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  Future<XFile> captureImage() async {
    if (!_isInitialized) await initialize();
    if (_controller == null || !_controller!.value.isInitialized) {
      throw CameraException('Not Ready', 'Camera is not initialized');
    }

    return await _controller!.takePicture();
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  CameraController? get controller => _controller;
}
