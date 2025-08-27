import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';

enum TaskAssignmentStatus {
  all,
  assigned,
  submitted,
  // inProgress,
  // completed,
  verified,
  rejected,
}

enum TaskAssignmentValidateMethod {
  auto,
  manually,
}
// Testing

class TaskAssignmentEntity {
  final String taskId;
  final TaskAssignmentStatus status;
  final bool submittedLate;
  final DateTime? deadline;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final bool faceVerification;
  final bool allowPicture;
  final double? confidence;
  final double? threshold;
  final double? taskLocationRadius;
  final TaskAssignmentValidateMethod? validateMethod;
  final LocationModel? employeeLocation;
  final LocationModel taskLocation;
  final DateTime? submittedAt;
  final String? image;
  final EmployeeTaskEntity employee;

  TaskAssignmentEntity({
    required this.taskId,
    required this.status,
    required this.submittedLate,
    required this.deadline,
    required this.faceVerification,
    required this.allowPicture,
    required this.employee,
    required this.taskLocation,
    this.checkIn,
    this.checkOut,
    this.taskLocationRadius,
    this.confidence,
    this.threshold,
    this.employeeLocation,
    this.validateMethod,
    this.submittedAt,
    this.image,
  });
}



class EmployeeTaskEntity {
  final String id;
  final String userName;
  final String email;
  final String? imageUrl;

  EmployeeTaskEntity({
    required this.id,
    required this.userName,
    required this.email,
    this.imageUrl,
  });
}
