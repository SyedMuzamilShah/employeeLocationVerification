import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/constants/app_colors.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_button.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_managment_provider.dart';
import 'package:my_desktop_app/features/task/presentation/provider/tast_detail_load_provider.dart';
import 'package:my_desktop_app/features/task/presentation/views/image_preview_widget.dart';
import 'package:my_desktop_app/features/task/presentation/views/map_confirm_widget.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/Function/time_formate_func.dart';
import 'package:my_desktop_app/features/task/presentation/widgets/manual_verification_buttons.dart';

class TaskAssignmentDetailDialog extends ConsumerWidget {
  final TaskAssignmentEntity assignment;

  const TaskAssignmentDetailDialog({super.key, required this.assignment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employee = assignment.employee;
    print(assignment.status);
    print(assignment.status != TaskAssignmentStatus.verified);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        // spacing: 5,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Assignment Detail',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          _buildInfoRow('Employee:', employee.userName),
          _buildInfoRow('Email:', employee.email),
          _buildInfoRow('Status:',
              "${assignment.status.name} | ${assignment.validateMethod?.name}"),
          if (assignment.submittedAt != null) ...[
            _buildInfoRow('Submitted At:',
                showTimeInFormattedFunction(assignment.submittedAt!)),
            if (assignment.checkIn != null)
            _buildInfoRow('Check In:',
                showTimeInFormattedFunction(assignment.checkIn!)),

            if (assignment.checkOut != null)
            _buildInfoRow('Check Out:',
                showTimeInFormattedFunction(assignment.checkOut!)),

            if (assignment.checkIn != null && assignment.checkOut == null)
            _buildInfoRow('Check Out:', 'Not check out yet'),

            assignment.submittedLate
                ? _buildInfoRow(
                    'Submitted Late:', assignment.submittedLate.toString(), color: Theme.of(context).colorScheme.error)
                : _buildInfoRow(
                    'Submitted Late:', assignment.submittedLate.toString(), color: AppColors.success),
            if (assignment.confidence != null)
              _buildInfoRow(
                  'Confidence:', '${assignment.confidence?.toInt()}%'),
          ],
         
          if (assignment.allowPicture == true && assignment.image != null) ...[
            // const SizedBox(height: 10),
            if (assignment.status.name != TaskAssignmentStatus.verified.name)
              Row(
                // spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Submitted Image:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ImagePreviewWidget(image: assignment.image!),
                ],
              ),
            // const SizedBox(height: 10),
            if (assignment.status != TaskAssignmentStatus.verified)
              Builder(builder: (_) {
                if (assignment.status != TaskAssignmentStatus.verified) {
                  return ManualVerificationButtons(assignment: assignment);
                }
                return SizedBox.shrink();
              }),
          ],
          const SizedBox(height: 10),
          MyCustomButton(
            btnText: 'View Map',
            onClick: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showMyDialog(
                  context,
                  TaskAssignmentMapDialog(
                    taskLocation: assignment.taskLocation.toLatLng(),
                    employeeLocation: assignment.employeeLocation?.toLatLng(),
                    radius: assignment.taskLocationRadius!,
                  ),
                  // width: 700,
                  // height: 700,
                );
              });
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(title,
                  style: TextStyle(fontWeight: FontWeight.w600),)),
          color != null ?
          Expanded(child: Text(value.toUpperCase(), style: TextStyle(color: color),))
          : Expanded(child: Text(value, style: TextStyle(color: color),))
        ],
      ),
    );
  }
}
