import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/camera_services.dart';
import 'package:my_mobile_app/core/utils/convert_image_uint8list.dart';
import 'package:my_mobile_app/core/utils/process_image.dart';

final imageCaptureProvider =
    StateNotifierProvider<ImageCaptureNotifier, ImageCaptureState>(
  (ref) => ImageCaptureNotifier(CameraService()),
);

class ImageCaptureNotifier extends StateNotifier<ImageCaptureState> {
  final CameraService cameraService;
  int _counter = 0;
  bool _isProcessing = false;

  final List<LivenessAction> requiredConditions = generateRandomConditions();

  ImageCaptureNotifier(this.cameraService) : super(ImageCaptureState.initial());

  Future<void> initializeCamera() async {
    await cameraService.initialize();
    state = state.copyWith(controller: cameraService.controller);
  }

  Future<void> takePicture() async {
    final image = await cameraService.captureImage();
    state = state.copyWith(imageFile: image);
  }

  void disposeCamera() {
    cameraService.dispose();
    dispose();
  }

  void clearImage() {
    cameraService.clearImage();
    state = state.copyWith(imageFile: null);
  }
  closedCameraStream () async {
    await cameraService.stopStream();
  }

  void startDetection() {
    cameraService.startStream((CameraImage rawImage) async {
      if (_isProcessing) return;
      _isProcessing = true;


      final converted = await detectFaces(rawImage);
      print("Response Comed");
      final action = requiredConditions[_counter];
      state = state.copyWith(conditionText: action.name);

      final data = DataCreated(image: converted, condition: action);

      try {
        // print(orientation);
        print("Testing");
        await Future.delayed(Duration(seconds: 1));
        final passed = await processImageFunction(data);
        if (passed) {
          _counter++;
          if (_counter >= requiredConditions.length) {
            // All conditions done ✅
            cameraService.stopStream();
            state = state.copyWith(conditionText: 'Capturing final image...');
            await Future.delayed(const Duration(milliseconds: 400));
            final image = await cameraService.captureImage();
            state = state.copyWith(imageFile: image, conditionText: 'Done');
          }
        }

      } catch (e) {
        print("Error is $e");
      }
      _isProcessing = false;
    });
  }
}

class ImageCaptureState {
  final CameraController? controller;
  final XFile? imageFile;
  final String? conditionText;

  const ImageCaptureState({
    this.controller,
    this.imageFile,
    this.conditionText,
  });

  factory ImageCaptureState.initial() => const ImageCaptureState();

  ImageCaptureState copyWith({
    CameraController? controller,
    XFile? imageFile,
    String? conditionText,
  }) {
    return ImageCaptureState(
      controller: controller ?? this.controller,
      imageFile: imageFile ?? this.imageFile,
      conditionText: conditionText ?? this.conditionText,
    );
  }
}