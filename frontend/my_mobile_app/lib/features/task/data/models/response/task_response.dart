import 'package:my_mobile_app/features/task/data/models/response/location_response.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';

TaskStatus? _parseStatus(dynamic status) {
  if (status is String) {
    try {
      return TaskStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toUpperCase() == status.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
  return null;
}

class TaskResponseModel extends TaskEntities {
  TaskResponseModel({
    super.id,
    super.title,
    super.description,
    super.dueDate,
    super.status,
    super.organizationId,
    super.adminId,
    super.createdAt,
    super.updatedAt,
    super.faceVerification,
    super.pictureAllowed,
    super.location,
    super.aroundDistanceMeter,
    super.employeeLocation,
    super.submittedAt,
    super.submittedLate,
    super.threshold,
    super.checkIn,
    super.checkOut,
    super.confidence,
    super.validateMethod,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    // print(json);  // Null Error Debugging
    return TaskResponseModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      dueDate: _tryParseDate(json['dueDate'] ?? json['deadline']),
      status: _parseStatus(json['status']),
      organizationId: json['organizationId'] as String?,
      adminId: json['adminId'] ?? json['assignedBy'],
      createdAt: _tryParseDate(json['createdAt']),
      updatedAt: _tryParseDate(json['updatedAt']),
      faceVerification: json['faceVerification'] as bool?,
      pictureAllowed: json['pictureAllowed'] as bool?,
      location: json['location'] != null
          ? LocationResponseModel.fromJson(json['location'])
          : null,
      employeeLocation: (json['employeeLocation'] != null && json['employeeLocation']['coordinates'].isNotEmpty)
          ? LocationResponseModel.fromJson(json['employeeLocation'])
          : null,
      aroundDistanceMeter: (json['aroundDistanceMeter'] is num)
          ? (json['aroundDistanceMeter'] as num).toDouble()
          : null,
      submittedAt: _tryParseDate(json['submittedAt']),
      checkIn: _tryParseDate(json['checkIn']),
      checkOut: _tryParseDate(json['checkOut']),
      submittedLate: json['submittedLate'] as bool?,
      threshold: (json['threshold'] is num)
          ? (json['threshold'] as num).toDouble()
          : null,
      confidence: (json['confidence'] is num)
          ? (json['confidence'] as num).toDouble()
          : null,
      validateMethod: json['validateMethod'] as String?,
    );
  }
}

DateTime? _tryParseDate(dynamic value) {
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}



// class TaskResponseModel extends TaskEntities {
//   TaskResponseModel(
//       {required super.id,
//       required super.title,
//       required super.description,
//       required super.dueDate,
//       required super.status,
//       required super.organizationId,
//       required super.adminId,
//       required super.createdAt,
//       required super.updatedAt,
//       required super.faceVerification,
//       required super.pictureAllowed,
//       super.location,
//       super.aroundDistanceMeter});

//   factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
//     print("Task Response Model");
//     print("Task Models/Response/task_response.dart");
//     print(json);
//     return TaskResponseModel(
//         id: json['_id'] ?? '',
//         title: json['title'] ?? 'title',
//         faceVerification: json['faceVerification'],
//         pictureAllowed: json['pictureAllowed'],
//         description: json['description'] ?? 'description',
//         dueDate: DateTime.parse(json['dueDate'] ?? json['deadline']),
//         status: _parseStatus(json['status']),
//         organizationId: json['organizationId'] ?? '',
//         adminId: json['adminId'] ?? '',
//         createdAt: DateTime.parse(json['createdAt']),
//         updatedAt: DateTime.parse(json['updatedAt']),
//         // location: json['location'] != null
//         //     ? LocationModel.fromJson(json['location'])
//         //     : null,
//         location: json['location'] != null
//             ? LocationResponseModel.fromJson(json['location'])
//             : null,
//         aroundDistanceMeter: json['aroundDistanceMeter']?.toDouble());
//   }
// }

