
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/profile/data/models/request/image_upload_params.dart';
import 'package:my_mobile_app/features/profile/domain/repositories/image_upload_repo.dart';

class UploadImageUseCase {
  final ImageUploadRepo repository;

  UploadImageUseCase(this.repository);

  Future<Either<Failure, void>> call(ImageUploadParams params) {
    return repository.uploadImage(params);
  }
}
