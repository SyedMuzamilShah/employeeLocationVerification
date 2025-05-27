import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_provider.dart';

final taskAssignParamsProvider = StateProvider.autoDispose<TaskAssignParams>((ref) {
  return TaskAssignParams(
    taskId : ref.read(taskProvider).currentTask?.id ?? '',
    employeesId: []
  );
});