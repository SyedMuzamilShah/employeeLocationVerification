import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool? enabled;
  final IconData? prefixIcon;
  final String? labelText;
  final Function(String?)? validatorFuncation;
  final Function(String)? onChanged;
  final int maxLines;
  final bool obscureText;

  const MyCustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.inputFormatters,
    this.maxLines = 1,
    this.obscureText = false,
    this.validatorFuncation,
    this.prefixIcon, this.labelText, this.keyboardType, this.textInputAction, this.focusNode, this.enabled, this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: enabled,
        focusNode: focusNode,
        textInputAction: textInputAction,


        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        
        onChanged: onChanged,
        validator: (value) =>
            validatorFuncation != null ? validatorFuncation!(value) : null,
        decoration: InputDecoration(
          errorText: hasError ? '' : null,
          errorStyle: const TextStyle(height: 0),
          label: labelText != null
              ? Text(labelText!)
              : null,
          hintText: hintText,
          prefix: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(prefixIcon),
                )
              : null,
          border: OutlineInputBorder(),
          suffixIcon: hasError
              ? Tooltip(
                  message: errorText!,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.error),
                )
              : null,
        ),
      ),
    );
  }
}
