import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';

class TaskAssignmentModel extends TaskAssignmentEntity {
  TaskAssignmentModel({
    required super.taskId,
    required super.status,
    required super.submittedLate,
    required super.deadline,
    required super.faceVerification,
    required super.allowPicture,
    required super.employee,
    super.employeeLocation,
    super.taskLocationRadius,
    super.confidence,
    super.threshold,
    super.validateMethod,
    super.submittedAt,
    super.image,
    required super.taskLocation,
  });

  factory TaskAssignmentModel.fromJson(Map<String, dynamic> json) {
    print("testing.....");
    print(json);
    return TaskAssignmentModel(
      taskId: json['taskId'] ?? '',
      taskLocation: LocationModel.fromJson(json['taskLocation']),
      status: _mapStatus(json['status']),
      taskLocationRadius: json['taskLocationRadius']?.toDouble(),
      submittedLate: json['submittedLate'] ?? false,
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      faceVerification: json['faceVerification'] ?? false,
      allowPicture: json['pictureAllowed'] ?? false,
      confidence:
          (json['confidence'] != null) ? json['confidence'].toDouble() : null,
      threshold:
          (json['threshold'] != null) ? json['threshold'].toDouble() : null,
      validateMethod: _mapValidateMethod(json['validateMethod']),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'])
          : null,
      image: json['employeeImage'],
      employee: EmployeeModel.fromJson(json['employee'] ?? {}),
      employeeLocation: (() {
        final location = json['employeeLocation'];
        if (location != null &&
            location['coordinates'] is List &&
            location['coordinates'].length == 2) {
          return LocationModel.fromJson(location);
        }
        return null;
      })(),
    );
  }

  static TaskAssignmentStatus _mapStatus(String? value) {
    switch (value?.toUpperCase()) {
      case 'ASSIGNED':
        return TaskAssignmentStatus.assigned;
      // case 'INPROGRESS':
      //   return TaskAssignmentStatus.inProgress;
      // case 'COMPLETED':
      //   return TaskAssignmentStatus.completed;
      case 'SUBMITTED':
        return TaskAssignmentStatus.submitted;
      case 'VERIFIED':
        return TaskAssignmentStatus.verified;
      case 'REJECTED':
        return TaskAssignmentStatus.rejected;
      default:
        return TaskAssignmentStatus.assigned;
    }
  }

  static TaskAssignmentValidateMethod? _mapValidateMethod(String? value) {
    switch (value?.toUpperCase()) {
      case 'AUTO':
        return TaskAssignmentValidateMethod.auto;
      case 'MANAULLY':
        return TaskAssignmentValidateMethod.manually;
      default:
        return null;
    }
  }
}

class EmployeeModel extends EmployeeTaskEntity {
  EmployeeModel({
    required super.id,
    required super.userName,
    required super.email,
    super.imageUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['_id'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
