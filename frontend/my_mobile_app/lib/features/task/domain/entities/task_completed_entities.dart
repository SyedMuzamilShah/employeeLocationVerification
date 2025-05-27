import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';

class TaskCompletedEntities {
  final TaskEntities task;
  final String message;
  const TaskCompletedEntities({
    required this.task,
    required this.message,
  });
}