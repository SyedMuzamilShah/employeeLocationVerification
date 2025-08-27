import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/devices/presentation/providers/location_provider.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/provider/use_case_provider.dart';


final taskCompleteCheckoutProvider = AutoDisposeFutureProvider.family<Either<Failure, String>, String>((ref, taskAssignmentId) async {
  final locationAsync = ref.watch(currentLocationProvider);

  late LocationParams location;
  await locationAsync.when(
    data: (data) {
      location = LocationParams(
        longitude: data.longitude ?? 0.0,
        latitude: data.latitude ?? 0.0,
      );
    },
    error: (e, s) => throw Exception(e.toString()),
    loading: () {},
  );

  final params = TaskCompletingCheckOutParams(
    taskAssignmentId: taskAssignmentId,
    currentTime: DateTime.now(),
    location: location,
  );

  final useCase = ref.watch(taskUseCaseProvider);
  return await useCase.completeTaskCheckOutUseCase(params);
});
