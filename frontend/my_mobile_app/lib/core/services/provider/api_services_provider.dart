import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/api_services.dart';

final apiServiceProvider = Provider<ApiServices>((ref) => ApiServices());