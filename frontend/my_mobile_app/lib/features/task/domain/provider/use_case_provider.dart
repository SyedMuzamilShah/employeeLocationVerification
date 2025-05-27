import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/data/provider/task_data_providers.dart';
import 'package:my_mobile_app/features/task/domain/usecases/task_usecase.dart';

final taskUseCaseProvider = Provider<TaskUseCase>(
  (ref) => TaskUseCaseImpl(repo: ref.read(taskRepoProvider)),
);