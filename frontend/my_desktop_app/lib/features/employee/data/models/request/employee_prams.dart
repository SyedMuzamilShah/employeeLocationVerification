import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';

class EmployeeCreateParams extends Equatable {
  final String userName;
  final String name;
  final String email;
  final String password;
  final File? image;
  final String phoneNumber;
  final String role;
  final String organizationId;

  const EmployeeCreateParams({
    required this.userName,
    required this.name,
    required this.email,
    required this.password,
    this.image,
    required this.phoneNumber,
    required this.role,
    required this.organizationId,
  });

  @override
  List<Object?> get props => [
        userName,
        name,
        email,
        password,
        image,
        phoneNumber,
        role,
        organizationId,
      ];

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'organizationId': organizationId,
    };
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap(toJson());
    if (image != null) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      ));
    }
    return formData;
  }
}

class EmployeeUpdateParams extends Equatable {
  final String id;
  final String? userName;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final EmployeeRole? role;
  final File? image;
  final EmployeeStatus? status;

  const EmployeeUpdateParams(
      {required this.id,
      this.userName,
      this.name,
      this.email,
      this.phoneNumber,
      this.role,
      this.image,
      this.status});

  @override
  List<Object?> get props =>
      [id, userName, name, email, phoneNumber, role, image, status];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'employeeId': id};
    if (userName != null) map['userName'] = userName;
    if (name != null) map['name'] = name;
    if (email != null) map['email'] = email;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;
    if (role != null) map['role'] = role!.name;
    if (status != null) map['status'] = status!.name;
    return map;
  }

  EmployeeUpdateParams copyWith({
    String? id,
    String? userName,
    String? name,
    String? email,
    String? phoneNumber,
    EmployeeRole? role,
    File? image,
    EmployeeStatus? status,
  }) {
    return EmployeeUpdateParams(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap(toJson());
    if (image != null) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      ));
    }
    return formData;
  }
}

class EmployeeDeleteParams extends Equatable {
  final String employeeId;

  const EmployeeDeleteParams({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];

  Map<String, dynamic> toJson() => {'employeeId': employeeId};
}

class EmployeeReadParams extends Equatable {
  final String? id;
  final String? organizationId;
  final String? status;
  final String? employeeId;
  final bool? isEmailVerified;
  final String? role;
  final int page;
  final int limit;
  final String? searchQuery;

  const EmployeeReadParams({
    this.id,
    this.organizationId,
    this.status,
    this.employeeId,
    this.isEmailVerified,
    this.role,
    this.page = 1,
    this.limit = 10,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
        id,
        organizationId,
        status,
        employeeId,
        isEmailVerified,
        role,
        page,
        limit,
        searchQuery,
      ];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (id != null) map['id'] = id;
    if (organizationId != null) map['organizationId'] = organizationId;
    if (status != null) map['status'] = status;
    if (employeeId != null) map['employeeId'] = employeeId;
    if (isEmailVerified != null) map['isEmailVerified'] = isEmailVerified;
    if (role != null) map['role'] = role;
    if (searchQuery != null) map['search'] = searchQuery;
    return map;
  }

  EmployeeReadParams copyWith({
    String? id,
    String? organizationId,
    String? status,
    String? employeeId,
    bool? isEmailVerified,
    String? role,
    int? page,
    int? limit,
    String? searchQuery,
  }) {
    return EmployeeReadParams(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      status: status ?? this.status,
      employeeId: employeeId ?? this.employeeId,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class EmployeeStatusChangeParams {
  final String employeeId;
  final EmployeeStatus status;

  const EmployeeStatusChangeParams({
    required this.employeeId,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'status': status.name,
      };
}

class EmployeeImageAllowParams {
  final String employeeId;

  const EmployeeImageAllowParams({
    required this.employeeId,
  });

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
      };
}
