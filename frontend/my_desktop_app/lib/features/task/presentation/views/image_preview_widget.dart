import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String image;
  const ImagePreviewWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageDialog(context, image),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                image,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, err, sta) {
                  return Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.error,
                  );
                },
              ),
              Container(
                height: 160,
                width: 160,
                color: Colors.black.withOpacity(0.25),
                // child: const Icon(Icons.zoom_in, color: Colors.white, size: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  errorBuilder: (_, err, sta) {
                    return Icon(Icons.error);
                  },
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
