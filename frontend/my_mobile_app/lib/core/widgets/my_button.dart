import 'package:flutter/material.dart';

class MyCustomButton extends StatelessWidget {
  final String btnText;
  final Color? color;
  final IconData? icon;
  final Function()? onClick;

  const MyCustomButton({
    super.key,
    required this.btnText,
    required this.onClick,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // This makes the button full width
      child: ElevatedButton.icon(
        label: Text(btnText),
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)), // Optional: set height
          backgroundColor: WidgetStatePropertyAll(color ?? Colors.blue),
          foregroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        onPressed: onClick,
        icon: Icon(icon, color: Colors.white,),
      ),
    );
  }
}
