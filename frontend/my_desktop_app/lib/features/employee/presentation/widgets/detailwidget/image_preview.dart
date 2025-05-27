import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';

class ImagePreview extends ConsumerWidget {
  final String? image;
  final bool imageAcceptedForToken;
  final Function()? onBtnClick;
  final Function ()? onBtnReject;
  const ImagePreview(
      {super.key,
      this.image,
      required this.imageAcceptedForToken,
      this.onBtnClick,
      this.onBtnReject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Image Preview:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(image!,
                height: 250, width: 250, fit: BoxFit.cover),
          )
        else
          Container(
            height: 250,
            width: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("No image uploaded"),
          ),
        const SizedBox(height: 8),
        if (!imageAcceptedForToken)
          if (image != null)
          Column(
            spacing: 10,
            children: [
            MyCustomButton(
              btnText: 'Accept image for token',
              onClick: onBtnClick
            ),
            MyCustomButton(
              btnText: 'Reject Image for Token',
              onClick: onBtnReject,
              color: Colors.red,
            ),

            ],
          )
        // Row(
        //   children: [
        //     Checkbox(
        //       value: imageAcceptedForToken,
        //       onChanged: uploadNewImage
        //           ? null
        //           : (val) => setState(() => imageAcceptedForToken = val ?? false),
        //     ),
        //     const Text("Accept image for token"),
        //   ],
        // ),
      ],
    );
  }
}
