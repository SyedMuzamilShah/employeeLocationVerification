import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/data/repositories/task_management_repo_impl.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_managemanat_entities.dart';
import 'package:my_desktop_app/features/task/domain/usecases/task_management_usecase.dart';

final taskManagementProvider =
    StateNotifierProvider<TaskManagmentNotifier, TaskManagementState>((ref) {
  return TaskManagmentNotifier();
});

class TaskManagmentNotifier extends StateNotifier<TaskManagementState> {
  TaskManagmentNotifier() : super(TaskManagementState());

  final TaskManagementUsecase _useCase = TaskManagementUsecaseImpl(
    repo: TaskManagementRepoImpl(
      dataSources: TaskManagamentDataSourcesImpl(services: ApiServices()),
    ),
  );

  Future<bool> taskAssign(TaskAssignParams params) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await _useCase.taskAssign(params);

    return response.fold(
      (err) {
        if (err is ValidationFailure){
          state = state.copyWith(isLoading: false, errorList: err.errors, error: err.message);
          return false;
        }else {
          state = state.copyWith(isLoading: false, error: err.message);
          return false;
        }
      },
      (succ) {
        state = state.copyWith(
          isLoading: false,
          data: succ,
          error: null,
        );
        return true;
      },
    );
  }

  Future taskDeassign(TaskDeAssignParams params) async {
    final response = await _useCase.taskDeassign(params);
    response.fold((err) => err, (succ) => succ);
  }

  Future<bool> taskVerifie(TaskVerifiedParams params) async {
    state = state.clear();
    state = state.copyWith(isLoading: true);

    final response = await _useCase.taskVerified(params);
    return response.fold((err){
      if (err is ValidationFailure){
        print(err.msg);
        state = state.copyWith(isLoading: false, error: err.msg, errorList: err.errors);
        return false;

      }
      print(err.message);

      state = state.copyWith(isLoading: false, error: err.message,);
      return false;

    }, (succ){
        state = state.copyWith(isLoading: false,);
      return true;
    });
  }

  Future taskStatusChange(TaskStatusChangeParams params) async {
    state = state.clear();
    state = state.copyWith(isLoading: true);

    final response = await _useCase.taskStatusChange(params);
    return response.fold((err){
      if (err is ValidationFailure){
        print(err.msg);
        state = state.copyWith(isLoading: false, error: err.msg, errorList: err.errors);
        return false;

      }
      print(err.message);

      state = state.copyWith(isLoading: false, error: err.message,);
      return false;

    }, (succ){
        state = state.copyWith(isLoading: false,);
      return true;
    });
  }
}


class TaskManagementState {
  final bool isLoading;
  final String? error;
  final TaskManagementEntities? data;
  final List<dynamic>? errorList;

  TaskManagementState({
    this.isLoading = false,
    this.error,
    this.data,
    this.errorList,
  });

  TaskManagementState copyWith({
    bool? isLoading,
    String? error,
    TaskManagementEntities? data,
    List<dynamic>? errorList,
  }) {
    return TaskManagementState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
      errorList: errorList,
    );
  }

  TaskManagementState clear ()=> TaskManagementState();
}
