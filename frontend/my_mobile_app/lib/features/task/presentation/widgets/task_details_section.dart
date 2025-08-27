import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/detail_section_card.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/header_section_card.dart';

class TaskDetailsSection extends StatelessWidget {
  final TaskEntities task;
  const TaskDetailsSection({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Task Details', icon: Icons.task),
        DetailSectionCard(
          items: [

            // Title
            DetailItem(label: 'Title', value: task.title ?? 'No Title'),


            //Due Time
            if (task.dueDate != null)
            DetailItem(label: 'Due Date', value: showTimeInFormattedFunction(task.dueDate!)),
            if (task.dueDate == null)
            DetailItem(label: 'Due Date', value: 'No Due Date'),


            DetailItem(label: 'Status', value: task.status?.name ?? 'No Status', isHighlighted: true),
            DetailItem(label: 'Description', value: task.description ?? 'No Description', isMultiLine: true),



            if (task.checkIn != null)
            DetailItem(label: 'Check in', value: showTimeInFormattedFunction(task.checkIn!)),
            if (task.checkOut != null)
            DetailItem(label: 'Check Out', value: showTimeInFormattedFunction(task.checkOut!)),
          ],
        ),
      ],
    );
  }
}


String showTimeInFormattedFunction (DateTime time){
  return DateFormat('h:mm a, MMM d, y').format(time);
}