import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';

class TaskDetailView extends ConsumerWidget {
  final TaskEntities task;
  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(task.title);
  }
}