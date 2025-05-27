import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/location_services.dart';

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());