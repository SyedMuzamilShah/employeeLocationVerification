// // Enhanced Models with Location
// import 'package:latlong2/latlong.dart';

// enum TaskPriority { low, medium, high }

// enum TaskStatus { pending, created, assigned, inProgress, completed, cancelled }

// class TaskLocation {
//   final double latitude;
//   final double longitude;
//   final String? address;

//   const TaskLocation({
//     required this.latitude,
//     required this.longitude,
//     this.address,
//   });

//   LatLng toLatLng() => LatLng(latitude, longitude);
// }

// class Task {
//   final String id;
//   final String title;
//   final String description;
//   final DateTime dueDate;
//   final TaskPriority priority;
//   TaskStatus status;
//   final String creatorId;
//   String? assigneeId;
//   final DateTime createdAt;
//   DateTime? completedAt;
//   final TaskLocation? location;
//     final String? completedBy; // Employee ID who marked as complete
//   final String? verifiedBy; // Admin ID who verified
//   final DateTime? verifiedAt;
//   final String? completionNotes;
//   final List<String>? completionMediaUrls; // Photos/docs of completed work

//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     this.priority = TaskPriority.medium,
//     this.status = TaskStatus.pending,
//     required this.creatorId,
//     this.assigneeId,
//     required this.createdAt,
//     this.completedAt,
//     this.location,
//     this.completedBy,
//     this.verifiedBy,
//     this.verifiedAt,
//     this.completionNotes,
//     this.completionMediaUrls,
//   });
// }

// class AppUser {
//   final String id;
//   final String name;
//   final String email;
//   final String? avatarUrl;

//   AppUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.avatarUrl,
//   });
// }