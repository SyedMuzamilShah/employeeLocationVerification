import 'package:flutter/material.dart';

void showMyDialog(
  BuildContext context,
  Widget child, {
  double? width,
  double? height,
  bool isLoader = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: !isLoader,
    builder: (context) {
      final size = MediaQuery.of(context).size;

      Widget dialogContent = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width ?? size.width * 0.9,
              maxHeight: height ?? size.width * 0.9
            ),
            child: child),
        ),
      );

      if (isLoader) {
        return PopScope(
          canPop: false,
          child: dialogContent,
        );
      }

      return dialogContent;
    },
  );
}
