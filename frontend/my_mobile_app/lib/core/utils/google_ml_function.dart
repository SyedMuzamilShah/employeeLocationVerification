// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

enum LivenessAction { blink, smile, lookLeft, lookRight }

class GoogleMlModelExecutor {
  static final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
          enableContours: true,
          enableClassification: true,
          minFaceSize: 0.3,
          performanceMode: FaceDetectorMode.fast));

  static imagePreProcess(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation270deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await faceDetector.processImage(inputImage);

      return faces;
    } catch (e) {
      debugPrint('Error in face detection: $e');
    }
  }

  static challengeActions(Face face, LivenessAction action) {
    bool actionCompleted = false;

    switch (action) {
      // case 'smile':
      case LivenessAction.smile:
        actionCompleted =
            face.smilingProbability != null && face.smilingProbability! > 0.5;
        break;
      // case 'blink':
      case LivenessAction.blink:
        actionCompleted = (face.leftEyeOpenProbability != null &&
                face.leftEyeOpenProbability! < 0.3) ||
            (face.rightEyeOpenProbability != null &&
                face.rightEyeOpenProbability! < 0.3);
        break;
      // case 'lookRight':
      case LivenessAction.lookRight:
        actionCompleted =
            face.headEulerAngleY != null && face.headEulerAngleY! < -10;
        break;
      // case 'lookLeft':
      case LivenessAction.lookLeft:
        actionCompleted =
            face.headEulerAngleY != null && face.headEulerAngleY! > 10;
        break;
    }
    return actionCompleted;
  }

  static List<LivenessAction> generateRandomConditions() {
    final all = LivenessAction.values.toList();
    all.shuffle(Random());
    return all; // Pick any 2 random conditions
  }
}
