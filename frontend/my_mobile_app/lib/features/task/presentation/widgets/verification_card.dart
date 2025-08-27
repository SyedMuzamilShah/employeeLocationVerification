import 'package:flutter/material.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/features/camera/presentation/views/camera_capture_view.dart';
import 'package:my_mobile_app/features/camera/presentation/views/image_capture_view.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/header_section_card.dart';

class TaskRequirements extends StatelessWidget {
  final TaskEntities task;

  const TaskRequirements({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    print("Building task Task Requirement Section for task");

    final theme = Theme.of(context);
    final bool faceVerification = task.faceVerification ?? true;
    final bool pictureAllowed = task.pictureAllowed ?? false;

    final bool showCompletionButton = task.status == TaskStatus.assigned;
    final bool hideButton =
        task.status == TaskStatus.verified || task.status == TaskStatus.submitted;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SectionHeader(
              title: 'Verification Requirements',
              icon: Icons.verified_user,
            ),
            _buildVerificationRow(
              context,
              icon: Icons.face,
              label: 'Face Verification',
              isRequired: faceVerification,
              showStatusInstead: hideButton,
              statusLabel: task.status?.name ?? '',
            ),
            if (faceVerification && pictureAllowed)
              Column(
                children: [
                  const Divider(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'You can submit picture proof if field picture is saved for manual verification.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            if (showCompletionButton && !hideButton)
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: MyCustomButton(
                    btnText: faceVerification
                        ? 'Verify Face & Complete'
                        : 'Capture Proof & Complete',
                    icon: Icons.camera_alt,
                    onClick: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (_) => const CameraCaptureView(),
                        builder: (_) => const FaceDetectionPage(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isRequired,
    required bool showStatusInstead,
    required String statusLabel,
  }) {
    final theme = Theme.of(context);

    final String displayLabel =
        showStatusInstead ? statusLabel.capitalize() : (isRequired ? 'Required' : 'Optional');

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Chip(
          label: Text(displayLabel),
          backgroundColor: theme.colorScheme.surfaceVariant,
          labelStyle: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : this;
}
