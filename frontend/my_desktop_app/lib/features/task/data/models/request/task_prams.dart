import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';

class TaskCreateParams extends Equatable {
  final String title;
  final String description;
  final DateTime dueDate;
  final String organizationId;
  final LocationModel? location;
  final double? radius;

  const TaskCreateParams(
      {required this.title,
      required this.organizationId,
      required this.description,
      required this.dueDate,
      this.location,
      this.radius
      });

  toJson() {
    return {
      'title': title,
      'description': description,
      'organizationId': organizationId,
      'dueDate': dueDate.toLocal().toIso8601String(),
      'radius': radius,
      'location': location?.toJson()
    };
  }

  TaskCreateParams copyWith(
      {String? title,
      String? description,
      DateTime? dueDate,
      String? organizationId,
      double? radius,
      LocationModel? location}) {
    return TaskCreateParams(
        title: title ?? this.title,
        organizationId: organizationId ?? this.organizationId,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        radius: radius ?? this.radius,
        location: location ?? this.location
        );
  }

  @override
  List<Object?> get props => [title, description, dueDate, organizationId, location, radius];
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeId;
  final String? placeName;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeId,
    this.placeName,
  })  : assert(latitude >= -90 && latitude <= 90, 'Invalid latitude'),
        assert(longitude >= -180 && longitude <= 180, 'Invalid longitude');

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
      if (address != null) 'address': address,
      if (placeId != null) 'placeId': placeId,
      if (placeName != null) 'placeName': placeName,
    };
  }

  LatLng toLatLng() => LatLng(latitude, longitude);

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeId,
    String? placeName,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
  final coords = json['coordinates'];
  if (coords is List && coords.length == 2) {
    final lon = coords[0];
    final lat = coords[1];
    if (lon is num && lat is num) {
      return LocationModel(
        longitude: lon.toDouble(),
        latitude: lat.toDouble(),
        address: json['address'] as String?,
      );
    }
  }
  // Handle invalid data by throwing or returning a default value
  throw FormatException('Invalid coordinates: $coords');
}


  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude, '
        'address: $address, placeId: $placeId, placeName: $placeName)';
  }
}

class TaskUpdateParams extends Equatable {
  final String id;

  final String? title;
  final String? description;
  final DateTime? dueDate;
  final LocationModel? location;
  final TaskStatus? status;

  const TaskUpdateParams({
    required this.id,
    this.title,
    this.description,
    this.dueDate,
    this.location,
    this.status,
  });
  toJson() {
    return {
      'taskId': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'dueDate': dueDate!.toLocal().toIso8601String(),
      if (location != null) 'location': location!.toJson(),
      if (status != null) 'status': status!.name,
    };
  }
  TaskUpdateParams copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    LocationModel? location,
    TaskStatus? status,
  }) {
    return TaskUpdateParams(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }
  @override
  List<Object?> get props => [id, title, description, dueDate, location, status];
}

class TaskDeleteParams {
  final String id;

  TaskDeleteParams({required this.id});
  toJson() {
    return {'taskId': id};
  }
}

class TaskReadParams extends Equatable {
  final String? organizationId;
  final String? adminId;
  final String? status;
  final String? search;
  final DateTime? dueDate;
  final int? page;
  final int? limit;
  final String? sort;

  const TaskReadParams({
    this.organizationId,
    this.adminId,
    this.status,
    this.search,
    this.dueDate,
    this.page,
    this.limit,
    this.sort,
  });

  TaskReadParams copyWith({
    String? organizationId,
    String? adminId,
    String? status,
    String? search,
    DateTime? dueDate,
    int? page,
    int? limit,
    String? sort,
  }) {
    return TaskReadParams(
      organizationId: organizationId ?? this.organizationId,
      adminId: adminId ?? this.adminId,
      status: status ?? this.status,
      search: search ?? this.search,
      dueDate: dueDate ?? this.dueDate,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (organizationId != null) 'organizationId': organizationId,
      if (adminId != null) 'adminId': adminId,
      if (status != null) 'status': status,
      if (search != null) 'search': search,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (sort != null) 'sort': sort,
    };
  }

  @override
  List<Object?> get props => [
        organizationId,
        adminId,
        status,
        search,
        dueDate,
        page,
        limit,
        sort,
      ];
}


class TaskDetailGetParams extends Equatable {
  final String taskId;
  final TaskAssignmentStatus? status;
  const TaskDetailGetParams({
    required this.taskId,
    this.status
  });

  TaskDetailGetParams copyWith({
    String? taskId,
    TaskAssignmentStatus? status
  }) {
    return TaskDetailGetParams(
      taskId: taskId ?? this.taskId, 
      status: status ?? this.status
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "taskId" : taskId,
    };
    if (status != null) data['status'] = status!.name;

    // if (organizationId != null) data['organizationId'] = organizationId;
    // if (adminId != null) data['adminId'] = adminId;
    // if (status != null) data['status'] = status;
    // if (search != null) data['search'] = search;
    // if (dueDate != null) data['dueDate'] = dueDate!.toIso8601String();
    // if (page != null) data['page'] = page;
    // if (limit != null) data['limit'] = limit;
    // if (sort != null) data['sort'] = sort;

    return data;
  }

  @override
  List<Object?> get props => [
        taskId,
        status,
      ];
}


