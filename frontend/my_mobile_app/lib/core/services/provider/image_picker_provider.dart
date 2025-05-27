import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/image_picker_service.dart';


final imagePickerServiceProvider = Provider((ref) => ImagePickerService());