import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/provider/use_case_provider.dart';
import 'package:my_mobile_app/features/task/domain/usecases/task_usecase.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_read_provider.dart';


// Provider for task completion state
final taskCompleteProvider = StateNotifierProvider.autoDispose<TaskCompleteNotifier, TaskCompleteState>((ref) {
  return TaskCompleteNotifier(ref.watch(taskCompletingParamsProvider), ref.watch(taskUseCaseProvider), ref);
});

// Notifier for task completion state
class TaskCompleteNotifier extends StateNotifier<TaskCompleteState>{
  final Ref ref;
  final TaskCompletingParams taskCompleteParams;
  final TaskUseCase useCase;

  TaskCompleteNotifier(this.taskCompleteParams, this.useCase, this.ref) : super(TaskCompleteState());

  // Method to complete task asynchronously
  Future<void> completeTask(TaskCompletingParams params) async {
    state = state.clear();
    state = state.copyWith(isLoading: true);

    final result = await useCase.completeTask(taskCompleteParams);

    result.fold(
      (error){
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      }, 
      (succ){
        ref.read(currentTaskProvider.notifier).state = succ.task;
        state = state.copyWith(isLoading: false, successMessage: succ.message);
      });
  }
}

class TaskCompleteState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  const TaskCompleteState({this.errorMessage, this.isLoading = false, this.successMessage});

  TaskCompleteState copyWith ( {bool? isLoading, String? errorMessage, String? successMessage,}) {
    return TaskCompleteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage
    );
  }

  TaskCompleteState clear () => TaskCompleteState();

  @override
  List<Object?> get props => [isLoading, errorMessage, successMessage];
}