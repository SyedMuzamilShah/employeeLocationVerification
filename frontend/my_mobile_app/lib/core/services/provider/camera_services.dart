import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/camera_services.dart';

final cameraServiceProvider = Provider<CameraService>((ref) => CameraService());