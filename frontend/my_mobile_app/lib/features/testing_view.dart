import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:my_mobile_app/core/services/camera_services.dart';
import 'package:my_mobile_app/core/utils/google_ml_function.dart';
import 'package:my_mobile_app/features/camera/presentation/views/camera_capture_view.dart';
import 'package:my_mobile_app/features/camera/presentation/views/image_capture_view.dart';
import 'package:my_mobile_app/features/testing_view_provider.dart';

class TestingView extends StatelessWidget {
  const TestingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => FaceDetectionPage()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => FaceDetectionPage()));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => CameraCaptureView()));
            },
            child: Text("Move To Next")),
      ),
    );
  }
}

// class FaceDetectionPage extends ConsumerStatefulWidget {
//   const FaceDetectionPage({super.key});

//   @override
//   FaceDetectionPageState createState() => FaceDetectionPageState();
// }

// class FaceDetectionPageState extends ConsumerState<FaceDetectionPage> {
//   CameraService cameraService = CameraService();

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//     Future<void> initializeCamera() async {
//     await cameraService.initialize();
//     if (mounted) {
//       setState(() {});
//       startFaceDetection();
//     }
//   }

//     void startFaceDetection() {
//     if (cameraService.isInitialized) {
//       cameraService.startStream((CameraImage image) async {
//         ref.read(cameraProvider.notifier).detectFaces(image);
//       });
//     }
//   }


//   @override
//   void dispose() {
//     GoogleMlModelExecutor.faceDetector.close();
//     cameraService.dispose();
//     cameraService.stopStream();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen(cameraProvider, (previous, next) {
//       if (next.verificationCompleted) {
//         Navigator.pop(context);
//       }
//     });
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amberAccent,
//         toolbarHeight: 70,
//         centerTitle: true,
//         title: const Text("..Verify Your Identity,,"),
//       ),
//       body: cameraService.isInitialized
//           ? Stack(
//               children: [
//                 Positioned.fill(
//                   child: CameraPreview(cameraService.controller!),
//                 ),
//                 CustomPaint(
//                   painter: HeadMaskPainter(),
//                   child: Container(),
//                 ),
//                 Positioned(
//                   top: 16,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.black54,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Please ${ref.watch(cameraProvider).condition ?? ''}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 18),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Step ${ref.watch(cameraProvider.notifier).currentActionIndex + 1} of ${ref.read(cameraProvider.notifier).conditionLength}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.black54,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '${ref.watch(cameraProvider).condition}: ${ref.watch(cameraProvider).probability != null ? (ref.watch(cameraProvider).probability!).toStringAsFixed(2) : 'N/A'}%',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// // Custom painter for head mask
// class HeadMaskPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width * 0.4;

//     final path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addOval(Rect.fromCircle(center: center, radius: radius))
//       ..fillType = PathFillType.evenOdd;

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

// class FaceDetectionPage extends ConsumerStatefulWidget {
//   const FaceDetectionPage({super.key});

//   @override
//   FaceDetectionPageState createState() => FaceDetectionPageState();
// }

// class FaceDetectionPageState extends ConsumerState<FaceDetectionPage> {

//   final FaceDetector faceDetector = GoogleMlModelExecutor.faceDetector;

//   late CameraController cameraController;
//   bool isCameraInitialized = false;
//   bool isDetecting = false;
//   List<LivenessAction> challengeActions = GoogleMlModelExecutor.generateRandomConditions();
//   int currentActionIndex = 0;

//   double? probability;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//     challengeActions.shuffle();
//   }

//   // Initialize the camera controller
//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final frontCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front);
//     cameraController = CameraController(frontCamera, ResolutionPreset.high,
//         enableAudio: false);
//     await cameraController.initialize();
//     if (mounted) {
//       setState(() {
//         isCameraInitialized = true;
//       });
//       startFaceDetection();
//     }
//   }

//   // Start face detection on the camera image stream
//   void startFaceDetection() {
//     if (isCameraInitialized) {
//       cameraController.startImageStream((CameraImage image) {
//         if (!isDetecting) {
//           isDetecting = true;
//           detectFaces(image).then((_) {
//             isDetecting = false;
//           });
//         }
//       });
//     }
//   }

//   // Detect faces in the camera image
//   Future<void> detectFaces(CameraImage image) async {
//     try {

//       final faces = await GoogleMlModelExecutor.imagePreProcess(image);

//       if (!mounted) return;
//       if (faces is! List<Face>) return;

//       if (faces.isNotEmpty) {
//         final face = faces.first;
//         setState(() {
//           switch (challengeActions[currentActionIndex]) {
//             case LivenessAction.blink:
//                 var leftEyeOpenProbability = face.leftEyeOpenProbability;
//                 var rightEyeOpenProbability = face.rightEyeOpenProbability;
//                 probability = (((leftEyeOpenProbability! + rightEyeOpenProbability!) / 2) * 100);
//               break;
//             case LivenessAction.smile:
//               probability = face.smilingProbability;
//               break;
//             case LivenessAction.lookLeft:
//               probability = face.leftEyeOpenProbability;
//               break;
//             case LivenessAction.lookRight:
//               probability = face.rightEyeOpenProbability;
//               break;
//           }
//         });
//         checkChallenge(face);
//       }
//     } catch (e) {
//       debugPrint('Error in face detection: $e');
//     }
//   }

//   // Check if the face is performing the current challenge action
//   void checkChallenge(Face face) async {
//     LivenessAction currentAction = challengeActions[currentActionIndex];
//     bool actionCompleted = GoogleMlModelExecutor.challengeActions(face, currentAction);

//     if (actionCompleted) {
//       currentActionIndex++;
//       if (currentActionIndex >= challengeActions.length) {
//         currentActionIndex = 0;
//         if (mounted) {
//           //Take Image
//           if (!mounted)return;
//           Navigator.pop(context, true);
//         }
//       }
//     }
//   }

//   // Check if the face is in a neutral position

//   @override
//   void dispose() {
//     cameraController.stopImageStream();
//     faceDetector.close();
//     cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amberAccent,
//         toolbarHeight: 70,
//         centerTitle: true,
//         title: const Text("...Verify Your Identity..."),
//       ),
//       body: isCameraInitialized
//           ? Stack(
//               children: [
//                 Positioned.fill(
//                   child: CameraPreview(cameraController),
//                 ),
//                 CustomPaint(
//                   painter: HeadMaskPainter(),
//                   child: Container(),
//                 ),
//                 Positioned(
//                   top: 16,
//                   left: 16,
//                   right: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.black54,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Please ${challengeActions[currentActionIndex].name}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 18),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Step ${currentActionIndex + 1} of ${challengeActions.length}',
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     color: Colors.black54,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '${challengeActions[currentActionIndex].name}: ${probability != null ? (probability! * 100).toStringAsFixed(2) : 'N/A'}%',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }

//   // Get the description of the current challenge action
//   String getActionDescription(String action) {
//     switch (action) {
//       case 'smile':
//         return 'smile';
//       case 'blink':
//         return 'blink';
//       case 'lookRight':
//         return 'look right';
//       case 'lookLeft':
//         return 'look left';
//       default:
//         return '';
//     }
//   }
// }

// // Custom painter for head mask
// class HeadMaskPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill;

//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = size.width * 0.4;

//     final path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..addOval(Rect.fromCircle(center: center, radius: radius))
//       ..fillType = PathFillType.evenOdd;

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
