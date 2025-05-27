import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWarningCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final PermissionStatus? status;
  final VoidCallback onFix;

  const PermissionWarningCard({super.key, 
    required this.icon,
    required this.title,
    required this.description,
    required this.status,
    required this.onFix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.errorContainer.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.error.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: onFix,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.onErrorContainer,
                ),
                child: Text(
                  status?.isPermanentlyDenied == true 
                      ? 'Open Settings' 
                      : 'Allow Permission',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}