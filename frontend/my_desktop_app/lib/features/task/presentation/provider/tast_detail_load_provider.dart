import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/data/repositories/task_repo_impl.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/usecases/task_usecase.dart';

// Provider for loading task details based on params
final loadTaskDetailProvider = FutureProvider.family.autoDispose<List<TaskAssignmentEntity>, TaskDetailGetParams>(
  (ref, params) async {
    final useCase = TaskUseCaseImpl(
      repo: TaskRepoImpl(
        dataSources: TaskDataSourcesImpl(services: ApiServices()),
      ),
    );

    final result = await useCase.getTaskDetail(params);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  },
);

// State management provider
final taskDetailProvider = StateNotifierProvider.autoDispose<TaskDetailNotifier, TaskDetailState>(
  (ref) => TaskDetailNotifier(
    useCase: TaskUseCaseImpl(
      repo: TaskRepoImpl(
        dataSources: TaskDataSourcesImpl(services: ApiServices()),
      ),
    ),
  ),
);

// Notifier
class TaskDetailNotifier extends StateNotifier<TaskDetailState> {
  final TaskUseCase useCase;

  TaskDetailNotifier({required this.useCase}) : super(TaskDetailState.initial());

  void clearAll() {
    state = TaskDetailState.initial();
  }

  void clearState() {
    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      errorList: null,
    );
  }

  Future<void> getTaskDetail(TaskDetailGetParams params) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await useCase.getTaskDetail(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (data) {
        state = state.copyWith(
          isLoading: false,
          taskDetail: data,
        );
      },
    );
  }
}

// State class
class TaskDetailState {
  final List<TaskAssignmentEntity> taskDetail;
  final bool isLoading;
  final String? errorMessage;
  final List<dynamic>? errorList;

  const TaskDetailState({
    required this.taskDetail,
    required this.isLoading,
    this.errorMessage,
    this.errorList,
  });

  factory TaskDetailState.initial() => const TaskDetailState(
        taskDetail: [],
        isLoading: false,
        errorMessage: null,
        errorList: null,
      );

  TaskDetailState copyWith({
    List<TaskAssignmentEntity>? taskDetail,
    bool? isLoading,
    String? errorMessage,
    List<dynamic>? errorList,
  }) {
    return TaskDetailState(
      taskDetail: taskDetail ?? this.taskDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorList: errorList ?? this.errorList,
    );
  }
}
