import 'dart:io';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CameraService {
   CameraController? _controller;
  XFile? _capturedImage;
  bool _isInitialized = false;
  String? _errorMessage;

  Future<void> _checkPermissions() async {
    if (kIsWeb) return;

    final status = await Permission.camera.status;

    if (!status.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        _errorMessage = 'Permission Denied';
        print(_errorMessage);
        print("Testing the object");
        throw CameraException(
            'Permission Denied', 'Camera permission not granted');
      }
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _checkPermissions();
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _errorMessage = 'No camera found';
      throw CameraException('No Camera', 'No camera found');
    }

    final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);

    _controller = CameraController(frontCamera, ResolutionPreset.high, enableAudio: false,
      // imageFormatGroup: ImageFormatGroup.yuv420 // FOR ML GOOD

      imageFormatGroup: Platform.isAndroid
          // ? ImageFormatGroup.nv21 // for Android
          ? ImageFormatGroup.yuv420 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  Future<XFile> captureImage() async {
    if (!_isInitialized) await initialize();
    if (_controller == null || !_controller!.value.isInitialized) {
      _errorMessage = 'Camera is not initialized';
      throw CameraException('Not Ready', 'Camera is not initialized');
    }
    _capturedImage = await _controller!.takePicture();
    final file = File(_capturedImage!.path);
    final sizeInKB = (await file.length()) / 1024;
    print('Captured image (${sizeInKB.toStringAsFixed(1)} KB)');
    return _capturedImage!;
  }

  // ✅ use the proper callback type
  void startStream(void Function(CameraImage) onImage) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    _controller!.startImageStream(onImage);
  }

  Future<void> stopStream() async {
    if (_controller?.value.isStreamingImages ?? false) {
      await _controller!.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    _errorMessage = null;
  }

  clearImage() {
    _capturedImage = null;
  }

   CameraController? get controller => _controller;
  XFile? get capturedImage => _capturedImage;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
}
