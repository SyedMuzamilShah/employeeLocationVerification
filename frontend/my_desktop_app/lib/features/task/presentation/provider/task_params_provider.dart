import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';

/// Provides [TaskDetailGetParams] for a given [taskId]
final taskAssignmentDetailParamsProvider = StateProvider.family
    .autoDispose<TaskDetailGetParams, String>((ref, taskId) {
  return TaskDetailGetParams(taskId: taskId);
});
