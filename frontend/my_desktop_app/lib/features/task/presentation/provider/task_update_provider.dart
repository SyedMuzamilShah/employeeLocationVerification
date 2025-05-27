import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';

final taskUpdateParamsProvider = StateNotifierProvider.autoDispose<
    TaskUpdateParamsNotifier, TaskUpdateParams>((ref) {
  return TaskUpdateParamsNotifier(ref);
});

class TaskUpdateParamsNotifier extends StateNotifier<TaskUpdateParams> {
  final Ref ref;
  TaskUpdateParamsNotifier(this.ref) : super(TaskUpdateParams(id: ''));

  title(String title) {
    state = state.copyWith(title: title);
  }

  description(String description) {
    state = state.copyWith(description: description);
  }

  location(LocationModel location) {
    state = state.copyWith(location: location);
  }

  clearLocation() {
    state = state.copyWith(location: LocationModel(latitude: 0, longitude: 0));
  }

  taskId(String id) {
    state = state.copyWith(id: id);
  }

  dueDate(DateTime dueDate) {
    state = state.copyWith(dueDate: dueDate);
  }
}
