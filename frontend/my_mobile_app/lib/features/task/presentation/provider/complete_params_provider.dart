import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';

final taskCompletingParamsProvider = StateNotifierProvider.autoDispose<
    TaskCompletingParamsNotifier, TaskCompletingParams>(
  (ref) => TaskCompletingParamsNotifier(),
);

class TaskCompletingParamsNotifier extends StateNotifier<TaskCompletingParams> {
  TaskCompletingParamsNotifier()
      : super(TaskCompletingParams(
          taskAssignmentId: '',
          currentTime: DateTime.now(),
          image: null,
          location: LocationParams(
            latitude: 0.0,
            longitude: 0.0,
          ),
        ));

  void updateTaskAssigedId(String taskAssignmentId) {
    if (state.taskAssignmentId != taskAssignmentId.trim()) {
      state = state.copyWith(taskAssignmentId: taskAssignmentId.trim());
    }
  }

  void updateCurrentTime(DateTime currentTime) {
    state = state.copyWith(currentTime: currentTime);
  }

  void updateImage(File? image) {
    state = state.copyWith(image: image);
  }

  void updateLocation(LocationParams location) {
    if (state.location != location) {
      state = state.copyWith(location: location);
    }
  }

  void resetFilters() {
    state = TaskCompletingParams(
      taskAssignmentId: '',
      currentTime: DateTime.now(),
      image: null,
      location: LocationParams(
        latitude: 0.0,
        longitude: 0.0,
      ),
    );
  }
}
