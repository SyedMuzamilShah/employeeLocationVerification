import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';


TaskStatus _parseStatus(String status) {
  print(status);
  return TaskStatus.values.firstWhere(
    (e) => e.toString().split('.').last.toUpperCase() == status.toUpperCase(),
    orElse: () => TaskStatus.created, // Default to pending if invalid status
  );
}


class TaskResponseModel extends TaskEntities {
  TaskResponseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.status,
    required super.organizationId,
    required super.adminId,
    required super.createdAt,
    required super.updatedAt,
    super.location,
    super.aroundDistanceMeter
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      status: _parseStatus(json['status']),
      organizationId: json['organizationId'],
      adminId: json['adminId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      aroundDistanceMeter: json['aroundDistanceMeter']?.toDouble()

    );
  }
}
