import 'package:flutter/material.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';

class MyCustomButton extends StatelessWidget {
  final String btnText;
  final Color? color;
  final bool? isLoading;
  final Color? backgroundColor;
  final Function()? onClick;
  const MyCustomButton({super.key, required this.btnText, required this.onClick, this.color, this.backgroundColor, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return isLoading! ?
    MyLoadingWidget() :
    
    ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )),
        // minimumSize: WidgetStatePropertyAll(Size(double.infinity, 50)),
        backgroundColor: WidgetStatePropertyAll(color ?? Theme.of(context).colorScheme.primary),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
      ),
      onPressed: onClick, 
      child: Text(btnText));
  }
}