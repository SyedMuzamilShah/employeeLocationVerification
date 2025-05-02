import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';

EmployeeStatus _parseStatus(String status) {
  return EmployeeStatus.values.firstWhere(
    (e) => e.name.toUpperCase() == status.toUpperCase(),
    orElse: () => EmployeeStatus.pending,
  );
}

class EmployeeResponseModel extends EmployeeEntities {
  EmployeeResponseModel({
    required super.id,
    required super.organizationId,
    required super.name,
    required super.email,
    super.phone,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.role,
    super.imageUrl,
    super.uploadNewImage = false,
    super.imageAcceptedForToken = false,
    super.userName,
    super.employeeId,
  });

  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeResponseModel(
      id: json["_id"],
      organizationId: json['organizationId'],
      name: json['name'],
      email: json['email'],
      phone: json['phoneNumber'],
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      role: json['role'],
      imageUrl: json['imageUrl'],
      uploadNewImage: json['uploadNewImage'] ?? false,
      imageAcceptedForToken: json['imageAcceptedForToken'] ?? false,
      userName: json['userName'],
      employeeId: json['employeeId'],
    );
  }
}
