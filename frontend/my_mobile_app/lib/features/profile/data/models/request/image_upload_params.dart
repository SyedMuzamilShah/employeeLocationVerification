import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class ImageUploadParams extends Equatable {
  final File image;
  const ImageUploadParams({required this.image});

  Map<String, dynamic> toJson() {
    return {'image': image};
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap(toJson());
    formData.files.add(MapEntry(
      'image',
      await MultipartFile.fromFile(image.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: DioMediaType('image', 'jpg')),
    ));
    return formData;
  }

  @override
  List<Object?> get props => [image];
}
