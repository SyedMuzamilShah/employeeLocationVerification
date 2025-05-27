// import 'package:equatable/equatable.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';


// final taskValidationErrorProvider =
//     StateProvider.autoDispose<TaskValidationError>((ref) => TaskValidationError.empty);


// class TaskValidationError extends Equatable {
//   final String? imageError;
//   final String? locationError;

//   const TaskValidationError({
//     this.imageError,
//     this.locationError,
//   });

//   bool get hasErrors => imageError != null || locationError != null;

//   TaskValidationError copyWith({
//     String? imageError,
//     String? locationError,
//   }) {
//     return TaskValidationError(
//       imageError: imageError ?? this.imageError,
//       locationError: locationError ?? this.locationError,
//     );
//   }

//   static const empty = TaskValidationError();

//   @override
//   List<Object?> get props => [imageError, locationError];
// }
