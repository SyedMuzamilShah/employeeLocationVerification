import 'package:flutter/material.dart';

class MyLoadingWidget extends StatelessWidget {
  final Color? color;
  const MyLoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? Colors.red,
      ),
    );
  }
}