import 'dart:io';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';

class TaskGetByIdParams extends Equatable {
  final String taskId;

  const TaskGetByIdParams({required this.taskId});
  TaskGetByIdParams copyWith({String? taskId}) {
    return TaskGetByIdParams(
      taskId: taskId ?? this.taskId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
    };
  }
  @override
  List<Object?> get props => [taskId];
}


class TaskCompletingParams extends Equatable {
  final String taskAssignmentId;
  final DateTime currentTime;
  final File? image;
  final LocationParams location;
  const TaskCompletingParams(
      {required this.taskAssignmentId,
      required this.currentTime,
      this.image,
      required this.location,
      });

  toJson() {
    return {
      'taskAssignmentId': taskAssignmentId,
      'currentTime': currentTime.toIso8601String(),
      'image': image,
      'location': location.toJson()
    };
  }

  TaskCompletingParams copyWith(
      {String? taskAssignmentId,
      DateTime? currentTime,
      File? image,
      LocationParams? location}) {
    return TaskCompletingParams(
        taskAssignmentId: taskAssignmentId ?? this.taskAssignmentId,
        currentTime: currentTime ?? this.currentTime,
        image: image ?? this.image,
        location: location ?? this.location);
  }


    Future<FormData> toFormData() async {
    final formData = FormData.fromMap(toJson());
    if (image != null) {
      formData.files.add(MapEntry(
        'image',
        await MultipartFile.fromFile(
          image!.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: DioMediaType('image', 'jpg')
        ),
      ));
    }
    return formData;
  }
  
  @override
  List<Object?> get props =>
      [taskAssignmentId, currentTime, image, location];
}

// class LocationModel extends LocationEntities {
//   LocationModel({
//     required super.latitude,
//     required super.longitude,
//     super.address,
//     super.placeId,
//     super.placeName,
//   })  : assert(latitude >= -90 && latitude <= 90, 'Invalid latitude'),
//         assert(longitude >= -180 && longitude <= 180, 'Invalid longitude');

//   Map<String, dynamic> toJson() {
//     return {
//       'type': 'Point',
//       'coordinates': [longitude, latitude],
//       if (address != null) 'address': address,
//       if (placeId != null) 'placeId': placeId,
//       if (placeName != null) 'placeName': placeName,
//     };
//   }

//   LatLng toLatLng() => LatLng(latitude, longitude);

//   LocationModel copyWith({
//     double? latitude,
//     double? longitude,
//     String? address,
//     String? placeId,
//     String? placeName,
//   }) {
//     return LocationModel(
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       address: address ?? this.address,
//       placeId: placeId ?? this.placeId,
//       placeName: placeName ?? this.placeName,
//     );
//   }

//   factory LocationModel.fromJson(Map<String, dynamic> json) {
//   final coords = json['coordinates'];
//   if (coords is List && coords.length == 2) {
//     final lon = coords[0];
//     final lat = coords[1];
//     if (lon is num && lat is num) {
//       return LocationModel(
//         longitude: lon.toDouble(),
//         latitude: lat.toDouble(),
//         address: json['address'] as String?,
//       );
//     }
//   }
//   // Handle invalid data by throwing or returning a default value
//   throw FormatException('Invalid coordinates: $coords');
// }


//   @override
//   String toString() {
//     return 'LocationModel(latitude: $latitude, longitude: $longitude, '
//         'address: $address, placeId: $placeId, placeName: $placeName)';
//   }
// }

class TaskReadParams extends Equatable {
  final TaskStatus? status;
  final String? search;
  final DateTime? dueDate;
  final int? page;
  final int? limit;
  final String? sort;

  const TaskReadParams({
    this.status,
    this.search,
    this.dueDate,
    this.page,
    this.limit,
    this.sort,
  });

  TaskReadParams copyWith({
    TaskStatus? status,
    String? search,
    DateTime? dueDate,
    int? page,
    int? limit,
    String? sort,
  }) {
    return TaskReadParams(
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
        status,
        search,
        dueDate,
        page,
        limit,
        sort,
      ];
}