// import 'package:camera/camera.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:my_mobile_app/core/utils/google_ml_function.dart';
// final cameraProvider =
//     StateNotifierProvider.autoDispose<CameraNotifier, CameraState>((ref) {
//   return CameraNotifier();
// });

// class CameraNotifier extends StateNotifier<CameraState> {
//   CameraNotifier() : super(CameraState.initial());

//   final List<LivenessAction> _challengeActions =
//       GoogleMlModelExecutor.generateRandomConditions();

//   int _currentActionIndex = 0;
//   bool _isDetecting = false;
//   int _frameCount = 0;

//   int get currentActionIndex => _currentActionIndex;
//   int get conditionLength => _challengeActions.length;

//   /// Called on every camera frame
//   Future<void> detectFaces(CameraImage image) async {
//     if (_isDetecting) return;
//     if (_frameCount++ % 3 != 0) return; // throttle: every 3rd frame

//     _isDetecting = true;
//     state = state.copyWith(condition: _challengeActions[_currentActionIndex].name);
//     await _processImage(image);
//     _isDetecting = false;
//   }

//   Future<void> _processImage(CameraImage image) async {
//     try {
//       final faces = await GoogleMlModelExecutor.imagePreProcess(image);
//       if (faces is! List<Face> || faces.isEmpty) return;

//       final face = faces.first;
//       double? probability;

//       switch (_challengeActions[_currentActionIndex]) {
//         case LivenessAction.blink:
//           final left = face.leftEyeOpenProbability;
//           final right = face.rightEyeOpenProbability;
//           if (left != null && right != null) {
//             probability = ((left + right) / 2) * 100;
//           }
//           break;

//         case LivenessAction.smile:
//           if (face.smilingProbability != null) {
//             probability = face.smilingProbability! * 100;
//           }
//           break;

//         case LivenessAction.lookLeft:
//           if (face.headEulerAngleY != null) {
//             final angle = face.headEulerAngleY!;
//             probability = angle < -15 ? 100 : 0;
//           }
//           break;

//         case LivenessAction.lookRight:
//           if (face.headEulerAngleY != null) {
//             final angle = face.headEulerAngleY!;
//             probability = angle > 15 ? 100 : 0;
//           }
//           break;
//       }

//       state = state.copyWith(probability: probability);
//       checkChallenge(face);
//     } catch (e) {
//       print('Error in face detection: $e');
//     }
//   }

//   void checkChallenge(Face face) {
//     final currentAction = _challengeActions[_currentActionIndex];
//     final actionCompleted =
//         GoogleMlModelExecutor.challengeActions(face, currentAction);

//     if (actionCompleted) {
//       _currentActionIndex++;
//       if (_currentActionIndex >= _challengeActions.length) {
//         state = state.copyWith(verificationCompleted: true);
//       } else {
//         state = state.copyWith(
//           condition: _challengeActions[_currentActionIndex].name,
//           probability: null,
//         );
//       }
//     }
//   }
// }

// class CameraState {
//   final double? probability;
//   final String? condition;
//   final int currentActionIndex;
//   final bool verificationCompleted;

//   const CameraState(this.probability, this.condition, this.verificationCompleted, this.currentActionIndex);

//   factory CameraState.initial() => const CameraState(null, null, false, 0);

//   CameraState copyWith({
//     double? probability,
//     String? condition,
//     bool? verificationCompleted,
//     int? currentActionIndex,
//     bool resetProbability = false,
//   }) {
//     return CameraState(
//       resetProbability ? null : (probability ?? this.probability),
//       condition ?? this.condition,
//       verificationCompleted ?? this.verificationCompleted,
//       currentActionIndex ?? this.currentActionIndex,
//     );
//   }
// }
