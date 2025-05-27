import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';

enum TaskStatus {
  all,
  created,
  assigned,
  completed,
}



class TaskEntities {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;
  final String organizationId;
  final String adminId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LocationModel? location;
  final double? aroundDistanceMeter;

  TaskEntities({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.organizationId,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.aroundDistanceMeter
  });
}
