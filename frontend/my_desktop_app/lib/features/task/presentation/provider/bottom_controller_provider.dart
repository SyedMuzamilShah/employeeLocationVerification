import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskDetailBottomControllerProvider = Provider.autoDispose((ref){
  return DraggableScrollableController();
});




// Duration duration = Duration(seconds: 1);

// class TaskDetailBottomControllerHandler {
//   static final DraggableScrollableController searchSheetController = DraggableScrollableController();

//   static searchSheetAnimate (double size) {
//     searchSheetController.animateTo(size, duration: duration, curve: Curves.ease);
//   }
// }