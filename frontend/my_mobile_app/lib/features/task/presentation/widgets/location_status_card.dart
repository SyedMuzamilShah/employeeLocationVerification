import 'package:flutter/material.dart';
import 'package:my_mobile_app/core/theme/app_theme.dart';

class LocationStatusCard extends StatelessWidget {
  final bool isWithinRadius;
  final double? distance;
  final double radius;

  const LocationStatusCard({super.key, 
    required this.isWithinRadius,
    required this.distance,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: isWithinRadius
          // ? theme.colorScheme.secondary.withValues(alpha: 0.5)
          ? theme.colorScheme.success.withValues(alpha: 0.5)
          : theme.colorScheme.errorContainer.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  isWithinRadius ? Icons.check_circle : Icons.error,
                  color: isWithinRadius 
                      ? theme.colorScheme.primary 
                      : theme.colorScheme.error,
                ),
                const SizedBox(width: 12),
                Text(
                  isWithinRadius ? 'Within Task Area' : 'Outside Task Area',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isWithinRadius 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (distance != null) ...[
              _buildDistanceRow(
                context,
                icon: Icons.linear_scale,
                label: 'Your Distance',
                value: '${(distance! / 1000).toStringAsFixed(2)} km',
              ),
              const SizedBox(height: 8),
            ],
            _buildDistanceRow(
              context,
              icon: Icons.radio_button_checked,
              label: 'Allowed Radius',
              value: '${(radius / 1000).toStringAsFixed(2)} km',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}