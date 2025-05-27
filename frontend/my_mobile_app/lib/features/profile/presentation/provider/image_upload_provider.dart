import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/services/api_services.dart';
import 'package:my_mobile_app/features/auth/presentation/providers/basic_auth_provider.dart';
import 'package:my_mobile_app/features/profile/data/models/request/image_upload_params.dart';
import 'package:my_mobile_app/features/profile/data/repositories/image_upload_repo_iml.dart';
import 'package:my_mobile_app/features/profile/data/sources/image_upload_remote.dart';
import 'package:my_mobile_app/features/profile/domain/usecase/image_upload_usecase.dart';

final imageUploadNotifierProvider =
    StateNotifierProvider.autoDispose<ImageUploadNotifier, ImageUploadState>((ref) {
  // final useCase = ref.watch(uploadImageUseCaseProvider);
  final useCase = UploadImageUseCase(ImageUploadRepoIml(
      dataSource: ImageUploadRemoteImpl(services: ApiServices())));

  return ImageUploadNotifier(useCase, ref);
});

class ImageUploadNotifier extends StateNotifier<ImageUploadState> {
  final UploadImageUseCase useCase;
  final Ref ref;
  ImageUploadNotifier(this.useCase, this.ref) : super(const ImageUploadState());

  Future<void> uploadImage(ImageUploadParams params) async {
    state = state.clearState();
    state = state.copyWith(loading: true);
    final result = await useCase(params);

    result.fold(
      (Failure f) => state =
          state.copyWith(loading: false, errorMessage: f.message),
      (succ) {
        ref.read(basicAuthProvider.notifier).getUser();
        state = state.copyWith(loading: false, message: "Image Uploaded successfully");
      },
    );
  }

  void reset() {
    state = const ImageUploadState(loading: false);
  }
}

class ImageUploadState extends Equatable {
  final bool loading;
  final String? errorMessage;
  final String? message;

  const ImageUploadState({
    this.loading = false,
    this.errorMessage,
    this.message,
  });

  ImageUploadState copyWith({bool? loading, String? message, String? errorMessage}) {
    return ImageUploadState(
      loading: loading ?? this.loading,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
  ImageUploadState clearState()=> ImageUploadState(loading: false);

  @override
  List<Object?> get props => [errorMessage, message, loading];
}
