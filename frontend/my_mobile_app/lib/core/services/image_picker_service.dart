import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickFromCamera() async {
    return await _picker.pickImage(source: ImageSource.camera, maxWidth: 500, maxHeight: 500);
  }

  Future<XFile?> pickFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }
}
