import 'package:flutter/material.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/detail_section_card.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/header_section_card.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskEntities task;
  const TaskDetailsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    print("Building task Details Section for task");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Task Details', icon: Icons.task),
        DetailSectionCard(
          items: [
            DetailItem(label: 'Title', value: task.title ?? 'No Title'),
            DetailItem(label: 'Due Date', value: task.dueDate?.toLocal().toString() ?? 'No Due Date'),
            DetailItem(label: 'Status', value: task.status?.name ?? 'No Status', isHighlighted: true),
            DetailItem(label: 'Description', value: task.description ?? 'No Description', isMultiLine: true),
          ],
        ),
      ],
    );
  }
}
