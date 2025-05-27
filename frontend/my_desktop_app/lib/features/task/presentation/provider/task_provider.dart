import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/data/repositories/task_repo_impl.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/domain/usecases/task_usecase.dart';

final loadTaskProvider =
    FutureProvider.family.autoDispose((ref, TaskReadParams prams) async {
  await ref.read(taskProvider.notifier).read(prams);
  if (ref.read(taskProvider).errorMessage != null) {
    throw Exception(ref.read(taskProvider).errorMessage);
  }
  return ref.read(taskProvider).task;
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<TaskState> {
  TaskNotifier() : super(TaskState.initial());

  final TaskUseCase _useCase = TaskUseCaseImpl(
    repo: TaskRepoImpl(
      dataSources: TaskDataSourcesImpl(services: ApiServices()),
    ),
  );

  // Clear all state including task
  void clearAll() {
    state = TaskState.initial();
  }

  // Clear only error and loading states
  void clearState() {
    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      errorList: null,
    );
  }

  Future<bool> create({required TaskCreateParams model}) async {
    try {
      state = TaskState.initial();
      state = state.copyWith(isLoading: true);
      final response = await _useCase.create(model);

      return response.fold(
        (failure) {
          if (failure is ValidationFailure) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
              errorList: failure.errors,
            );
            return false;
          } else {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            );
            return false;
          }
        },
        (task) {
          state = state.copyWith(
            currentTask: task,
            isLoading: false,
            task: [...state.task, task],
            errorMessage: null,
            errorList: null,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error occurred: $e',
      );
      return false;
    }
  }

  Future<void> read([TaskReadParams? model]) async {
    try {
      // state =
      //     state.copyWith(isLoading: true, errorMessage: null, errorList: null);
      final response = await _useCase.get(model);

      response.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
        },
        (data) {
          state = state.copyWith(
            isLoading: false,
            task: data,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load task: $e',
      );
    }
  }

  Future<bool> update(TaskUpdateParams model) async {
    print(model.toJson());
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _useCase.update(model);

      return response.fold(
        (failure){
          state = state.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          );
          return false;
        },
        (updatedOrg){
          final updatedList = state.task
              .map((org) => org.id == updatedOrg.id ? updatedOrg : org)
              .toList();

          state = state.copyWith(
            isLoading: false,
            task: updatedList,
            errorMessage: null,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update organization: $e',
      );
      return false;
    }
  }

  Future<void> delete(TaskDeleteParams model) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _useCase.delete(model);
      response.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (_) => state = state.copyWith(
          isLoading: false,
          task: state.task.where((org) => org.id != model.id).toList(),
          errorMessage: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete organization: $e',
      );
    }
  }
}

class TaskState {
  final List<TaskEntities> task;
  final TaskEntities? currentTask;
  final bool isLoading;
  final String? errorMessage;
  final List<dynamic>? errorList;

  TaskState({
    required this.task,
    required this.isLoading,
    this.currentTask,
    this.errorMessage,
    this.errorList,
  });

  // Initial state
  factory TaskState.initial() => TaskState(
      task: [],
      isLoading: false,
      errorMessage: null,
      errorList: null,
      currentTask: null);

  TaskState copyWith({
    List<TaskEntities>? task,
    TaskEntities? currentTask,
    bool? isLoading,
    String? errorMessage,
    List<dynamic>? errorList,
  }) {
    return TaskState(
      currentTask: currentTask,
      task: task ?? this.task,
      isLoading: isLoading ?? this.isLoading,
      errorList: errorList,
      errorMessage: errorMessage,
    );
  }
}
