// import 'package:latlong2/latlong.dart';

// class TaskCreateParams {
//   final String title;
//   final String description;
//   final DateTime dueDate;
//   final String organizationId;
//   final LocationModel? location;
//   final List<String>? pdfFileUrls;
//   final int? aroundDistanceMeter;
//   final List<String>? assignedEmployeeIds;
//   final String status;

//   TaskCreateParams({
//     required this.title,
//     required this.description,
//     required this.dueDate,
//     required this.organizationId,
//     this.location,
//     this.pdfFileUrls,
//     this.aroundDistanceMeter = 1000, // Default 1000 meters
//     this.assignedEmployeeIds,
//     this.status = 'CREATED', // Default status
//   });
  
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': description,
//       'dueDate': dueDate.toIso8601String(),
//       'organizationId': organizationId,
//       'location': location?.toJson(),
//       'pdfFiles': pdfFileUrls,
//       'aroundDistanceMeter': aroundDistanceMeter,
//       'assignedEmployees': assignedEmployeeIds,
//       'status': status,
//     }..removeWhere((key, value) => value == null);
//   }

//   TaskCreateParams copyWith({
//     String? title,
//     String? description,
//     DateTime? dueDate,
//     String? organizationId,
//     LocationModel? location,
//     List<String>? pdfFileUrls,
//     int? aroundDistanceMeter,
//     List<String>? assignedEmployeeIds,
//     String? status,
//   }) {
//     return TaskCreateParams(
//       title: title ?? this.title,
//       description: description ?? this.description,
//       dueDate: dueDate ?? this.dueDate,
//       organizationId: organizationId ?? this.organizationId,
//       location: location ?? this.location,
//       pdfFileUrls: pdfFileUrls ?? this.pdfFileUrls,
//       aroundDistanceMeter: aroundDistanceMeter ?? this.aroundDistanceMeter,
//       assignedEmployeeIds: assignedEmployeeIds ?? this.assignedEmployeeIds,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   String toString() {
//     return 'TaskCreateParams(title: $title, description: $description, '
//         'dueDate: $dueDate, organizationId: $organizationId, '
//         'location: $location, pdfFileUrls: $pdfFileUrls, '
//         'aroundDistanceMeter: $aroundDistanceMeter, '
//         'assignedEmployeeIds: $assignedEmployeeIds, status: $status)';
//   }
// }

// class LocationModel {
//   final double latitude;
//   final double longitude;
//   final String? address;
//   final String? placeId;
//   final String? placeName;

//   LocationModel({
//     required this.latitude,
//     required this.longitude,
//     this.address,
//     this.placeId,
//     this.placeName,
//   }) : assert(latitude >= -90 && latitude <= 90, 'Invalid latitude'),
//        assert(longitude >= -180 && longitude <= 180, 'Invalid longitude');

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

//   @override
//   String toString() {
//     return 'LocationModel(latitude: $latitude, longitude: $longitude, '
//         'address: $address, placeId: $placeId, placeName: $placeName)';
//   }
// }