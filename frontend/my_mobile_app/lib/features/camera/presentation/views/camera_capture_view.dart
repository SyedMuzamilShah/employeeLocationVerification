// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:my_mobile_app/core/services/camera_services.dart';
// import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';

// class CameraCaptureView extends ConsumerStatefulWidget {
//   const CameraCaptureView({super.key});

//   @override
//   ConsumerState<CameraCaptureView> createState() => _CameraCaptureViewState();
// }

// class _CameraCaptureViewState extends ConsumerState<CameraCaptureView> {

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _cameraService.initialize();
//       setState(() {});
//     });
//   }

//   imageDoneProcessToNextStep() async {
//     _cameraService.captureImage().then((XFile image) {
//       ref
//           .read(taskCompletingParamsProvider.notifier)
//           .updateImage(File(image.path));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(_cameraService.controller);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Capture Image'),
//         actions: [
//           if (_cameraService.capturedImage != null)
//             IconButton(
//               icon: const Icon(Icons.done),
//               onPressed: () => imageDoneProcessToNextStep(),
//             ),
//         ],
//       ),
//       body: _cameraService.errorMessage != null
//           ? Center(
//               child: Text(
//                 _cameraService.errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//             )
//           : _cameraService.controller != null
//               ? Stack(
//                   children: [
//                     _cameraService.capturedImage == null
//                         ? CameraPreview(_cameraService.controller!)
//                         : Center(
//                             child: Image.file(
//                                 File(_cameraService.capturedImage!.path))),
//                     // if (_showFlashEffect)
//                     //   AnimatedOpacity(
//                     //     opacity: _showFlashEffect ? 1 : 0,
//                     //     duration: const Duration(milliseconds: 300),
//                     //     child: Container(
//                     //       color: Colors.white.withValues(alpha: 0.8),
//                     //       width: double.infinity,
//                     //       height: double.infinity,
//                     //     ),
//                     //   ),
//                     Positioned(
//                       bottom: 20,
//                       right: 20,
//                       child: FloatingActionButton(
//                         onPressed: _cameraService.capturedImage == null
//                             ? () async {
//                                 await _cameraService.captureImage();
//                                 setState(() {});
//                               }
//                             : _retakeImage,
//                         child: Icon(_cameraService.capturedImage == null
//                             ? Icons.camera
//                             : Icons.refresh),
//                       ),
//                     ),
//                   ],
//                 )
//               : const Center(child: CircularProgressIndicator()),
//     );
//   }

//   @override
//   void dispose() {
//     _cameraService.dispose();
//     super.dispose();
//   }

//   void _retakeImage() {
//     setState(() => _cameraService.clearImage());
//   }
// }

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_mobile_app/features/camera/presentation/provider/image_capture_provider.dart';
// class CameraCaptureView extends ConsumerStatefulWidget {
//   const CameraCaptureView({super.key});

//   @override
//   ConsumerState<CameraCaptureView> createState() => _CameraCaptureViewState();
// }

// class _CameraCaptureViewState extends ConsumerState<CameraCaptureView> {
//   bool _isInitialized = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     // Initialize camera only once
//     if (!_isInitialized) {
//       final ctrl = ref.read(imageCaptureProvider.notifier);
//       ctrl.initializeCamera();
//       _isInitialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(imageCaptureProvider);
//     final ctrl = ref.read(imageCaptureProvider.notifier);

//     if (state.controller == null || !state.controller!.value.isInitialized) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Camera View'), actions: [
//         ElevatedButton(onPressed: () async {
//           await ctrl.closedCameraStream();
//         }, child: Text("Close"))
//       ],),
//       body: Stack(
//         children: [
//           state.imageFile == null
//               ? Stack(
//                   children: [
//                     CameraPreview(state.controller!),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         color: Colors.black54,
//                         padding: const EdgeInsets.all(16),
//                         child: Text(
//                           state.conditionText ?? 'Hold still...',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               : Center(
//                   child: Image.file(
//                     File(state.imageFile!.path),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: FloatingActionButton(
//               onPressed: state.imageFile == null
//                   ? ctrl.startDetection
//                   : ctrl.clearImage,
//               child: Icon(
//                 state.imageFile == null ? Icons.camera : Icons.refresh,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
