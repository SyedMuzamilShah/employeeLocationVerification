import 'package:my_mobile_app/features/task/domain/entities/location_entities.dart';

enum TaskStatus {
  all,
  assigned,
  submitted,
  verified,
  rejected,
  completed,
}



// class TaskEntities {
//   final String id;
//   final String title;
//   final String description;
//   final DateTime dueDate;
//   final TaskStatus status;
//   final bool faceVerification;
//   final bool pictureAllowed;
//   final String organizationId;
//   final String adminId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final LocationEntities? location;
//   final double? aroundDistanceMeter;

//   TaskEntities({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     required this.status,
//     required this.organizationId,
//     required this.adminId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.faceVerification,
//     required this.pictureAllowed,
//     this.location,
//     this.aroundDistanceMeter
//   });
// }


class TaskEntities {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final TaskStatus? status;
  final String? organizationId;
  final String? adminId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? faceVerification;
  final bool? pictureAllowed;
  final LocationEntities? location;
  final double? aroundDistanceMeter;

  // Optional fields after submission
  final LocationEntities? employeeLocation;
  final DateTime? submittedAt;
  final bool? submittedLate;
  final double? threshold;
  final double? confidence;
  final String? validateMethod;

  TaskEntities({
    this.id,
    this.title,
    this.description,
    this.dueDate,
    this.status,
    this.organizationId,
    this.adminId,
    this.createdAt,
    this.updatedAt,
    this.faceVerification,
    this.pictureAllowed,
    this.location,
    this.aroundDistanceMeter,
    this.employeeLocation,
    this.submittedAt,
    this.submittedLate,
    this.threshold,
    this.confidence,
    this.validateMethod,
  });
}
