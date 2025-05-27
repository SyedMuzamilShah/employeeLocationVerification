import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';

final taskSearchProvider = StateNotifierProvider.autoDispose<TaskSearchNotifier, TaskReadParams>(
  (ref) => TaskSearchNotifier(),
);

class TaskSearchNotifier extends StateNotifier<TaskReadParams> {
  TaskSearchNotifier() : super(const TaskReadParams());

  void updateSearch(String search) {
    state = state.copyWith(search: search.isEmpty ? null : search);
  }

  void updateStatus(TaskStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateDueDate(DateTime? dueDate) {
    state = state.copyWith(dueDate: dueDate);
  }

  void resetFilters() {
    state = const TaskReadParams();
  }
}