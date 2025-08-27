import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/services.dart';




  // Detect faces in the camera image
  Future<InputImage> detectFaces(CameraImage image) async {
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

      // final faces = await faceDetector.processImage(inputImage);
      return inputImage;

    } catch (e) {
      debugPrint('Error in face detection: $e');
      throw Exception('Error in face detection: $e');
    }
  }










Future<InputImage?> convertToInputImage(
  CameraImage image,
  InputImageRotation sensorOrientation,
) async {
  try {
    late InputImageFormat format;
    late Uint8List bytes;
    late int bytesPerRow;

    if (Platform.isAndroid) {
      // ✅ Expecting 3 planes for YUV420 format
      if (image.planes.length != 3) {
        print("❌ Unexpected number of planes: ${image.planes.length}");
        return null;
      }

      format = InputImageFormat.yuv420;

      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      bytes = allBytes.done().buffer.asUint8List();

      bytesPerRow = image.planes.first.bytesPerRow;
    } else if (Platform.isIOS) {
      if (image.planes.length != 1) {
        print("❌ iOS: Expected 1 plane, got ${image.planes.length}");
        return null;
      }

      format = InputImageFormat.bgra8888;
      bytes = image.planes.first.bytes;
      bytesPerRow = image.planes.first.bytesPerRow;
    } else {
      print("❌ Unsupported platform");
      return null;
    }

    final metadata = InputImageMetadata(
      // size: Size(image.width.toDouble(), image.height.toDouble()),
      // rotation: sensorOrientation,
      // format: format,
      // bytesPerRow: bytesPerRow,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation270deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  } catch (e, stack) {
    print("❌ Exception in convertToInputImage: $e");
    print(stack);
    return null;
  }
}

InputImageRotation _rotationFromSensorOrientation(int rotation) {
  switch (rotation) {
    case 0:
      return InputImageRotation.rotation0deg;
    case 90:
      return InputImageRotation.rotation90deg;
    case 180:
      return InputImageRotation.rotation180deg;
    case 270:
      return InputImageRotation.rotation270deg;
    default:
      return InputImageRotation.rotation0deg;
  }
}
