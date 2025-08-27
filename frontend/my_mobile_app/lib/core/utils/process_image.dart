import 'dart:math';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// smile, blink, leftTurn, rightTurn
enum LivenessAction { blink, smile, leftTurn, rightTurn }


List<LivenessAction> generateRandomConditions() {
    final all = LivenessAction.values.toList();
    all.shuffle(Random());
    return all.take(2).toList(); // Pick any 2 random conditions
}


class DataCreated {
  final InputImage image;
  final LivenessAction condition;
  const DataCreated({required this.image, required this.condition});
}

Future<bool> processImageFunction(DataCreated data) async {
  final options = FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      minFaceSize: 0.3,
      performanceMode: FaceDetectorMode.fast
  );

  final faceDetector = FaceDetector(options: options);

  print("Testing.... Data.image.bitmapData");
  final faces = await faceDetector.processImage(data.image);
  // faceDetector.close();

  // if (faces.isEmpty) {
  //   throw Exception('face not dected');
  // }

  bool ok = false;
  print(faces.isNotEmpty);
  print("Resterat");
  await Future.delayed(Duration(seconds: 1));
  if (faces.isNotEmpty){
    final Face face = faces.first;

  final blinkDetected = (face.leftEyeOpenProbability ?? 1.0) < 0.3 &&
      (face.rightEyeOpenProbability ?? 1.0) < 0.3;
  final smileDetected = (face.smilingProbability ?? 0.0) > 0.75;
  final yaw = face.headEulerAngleY ?? 0.0; // left(-), right(+)
  final leftTurn = yaw < -18.0;
  final rightTurn = yaw > 18.0;

  print(data.condition);
  print("Smile Dectected : $smileDetected");
  print("Bline Dectected : $blinkDetected");
  print("Left Dectected : $leftTurn");
  print("right Dectected : $rightTurn");
  switch (data.condition) {
    case LivenessAction.blink:
      ok = blinkDetected;
      break;
    case LivenessAction.smile:
      ok = smileDetected;
      break;
    case LivenessAction.leftTurn:
      ok = leftTurn;
      break;
    case LivenessAction.rightTurn:
      ok = rightTurn;
      break;
  }
  }
  return ok;
}
