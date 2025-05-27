import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/profile/data/models/request/image_upload_params.dart';
import 'package:my_mobile_app/features/profile/data/sources/image_upload_remote.dart';
import 'package:my_mobile_app/features/profile/domain/repositories/image_upload_repo.dart';

class ImageUploadRepoIml extends ImageUploadRepo {
  final ImageUploadRemote dataSource;
  ImageUploadRepoIml({required this.dataSource});

  @override
  Future<Either<Failure, void>> uploadImage(ImageUploadParams params) async {
    final FormData data = await params.toFormData();
    final response = await dataSource.uploadImage(data);
    return response.fold(
      (err) => Left(err),
      (succ) {
        print(succ);
        return const Right(null);
      },
    );
  }
}
