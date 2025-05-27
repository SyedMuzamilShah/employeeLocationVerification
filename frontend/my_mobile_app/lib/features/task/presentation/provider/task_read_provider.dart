import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/domain/provider/use_case_provider.dart';

final taskListProvider = FutureProvider.family.autoDispose<List<TaskEntities>, TaskReadParams?>((ref, params) async {
  final useCase = ref.read(taskUseCaseProvider);
  final result = await useCase.readTask(params);
  return result.fold(
    (failure) => throw failure,
    (tasks) => tasks,
  );
});


final currentTaskProvider = StateProvider<TaskEntities?>((ref)=> null);