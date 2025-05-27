import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/provider/camera_services.dart';

final imageCaptureProvider =
    StateNotifierProvider<ImageCaptureNotifier, ImageCaptureState>((ref) {
  return ImageCaptureNotifier(ref);
});

class ImageCaptureNotifier extends StateNotifier<ImageCaptureState> {
  final Ref ref;

  ImageCaptureNotifier(this.ref)
      : super(const ImageCaptureState(isLoading: true)) {
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      state = state.copyWith(isLoading: true);
      await ref.read(cameraServiceProvider).initialize();
      state = state.copyWith(
        controller: ref.read(cameraServiceProvider).controller,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> captureImage() async {
    try {
      final image = await ref.read(cameraServiceProvider).captureImage();
      state = state.copyWith(image: image);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  @override
  void dispose() {
    ref.read(cameraServiceProvider).dispose();
    super.dispose();
  }
}


class ImageCaptureState extends Equatable {
  final XFile? image;
  final CameraController? controller;
  final bool isLoading;
  final String? error;

  const ImageCaptureState({
    this.image,
    this.controller,
    this.isLoading = false,
    this.error,
  });

  ImageCaptureState copyWith({
    XFile? image,
    CameraController? controller,
    bool? isLoading,
    String? error,
  }) {
    return ImageCaptureState(
      image: image ?? this.image,
      controller: controller ?? this.controller,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [image, controller, isLoading, error];
}