
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/profile/data/models/request/image_upload_params.dart';

abstract class ImageUploadRepo {
  Future<Either<Failure, void>> uploadImage(ImageUploadParams params);
}