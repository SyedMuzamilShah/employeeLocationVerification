import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/core/widgets/my_dialog_box.dart';
import 'package:my_mobile_app/core/widgets/toast_msg_widget.dart';
import 'package:my_mobile_app/features/devices/presentation/providers/location_provider.dart';
import 'package:my_mobile_app/features/devices/presentation/providers/permission_provider.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_check_out_provider.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_complete_provider.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_read_provider.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/location_status_section.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/permission_warning_card.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/task_details_section.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/verification_card.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskCompleteView extends ConsumerStatefulWidget {
  final TaskEntities task;
  const TaskCompleteView({super.key, required this.task});

  @override
  ConsumerState<TaskCompleteView> createState() => _TaskCompleteViewState();
}

class _TaskCompleteViewState extends ConsumerState<TaskCompleteView> {
  @override
  void initState() {
    super.initState();

    // Set the initial task entity in provider
    Future.microtask(() {
      ref.read(currentTaskProvider.notifier).state = widget.task;
    });
  }

  bool isLoadingShow = false;

  @override
  Widget build(BuildContext context) {
    final currentTask = ref.watch(currentTaskProvider);
    print("Task COmplete View Called");
    
    if (currentTask == null) {
      return const Scaffold(
        body: Center(child: MyLoadingWidget()),
      );
    }
    // Watch permission provider
    final permissionsAsync = ref.watch(permissionsProvider);

    // Listen to task completion state changes
    ref.listen(taskCompleteProvider, (previous, next) {
      if (next.isLoading) {
        showMyDialog(
          context,
          const MyLoadingWidget(),
          isLoader: true,
          height: 50,
        );
      }

      if (next.errorMessage != null) {
        Navigator.pop(context);
        showToastMessage(next.errorMessage!, false);
      }

      if (next.successMessage != null) {
        Navigator.pop(context);
        showToastMessage(next.successMessage!, true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Completion'),
        centerTitle: true,
        elevation: 0,
      ),
      body: permissionsAsync.when(
        loading: () =>
            const Center(child: MyLoadingWidget(color: Colors.yellow)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (permissions) {
          final locationStatus = permissions[Permission.location];
          final cameraStatus = permissions[Permission.camera];
          final isFaceRequired = currentTask.faceVerification ?? false;

          final locationDenied = locationStatus?.isDenied == true ||
              locationStatus?.isPermanentlyDenied == true;
          final cameraDenied = isFaceRequired &&
              (cameraStatus?.isDenied == true ||
                  cameraStatus?.isPermanentlyDenied == true);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (widget.task.employeeLocation == null)
                  Column(
                    children: [
                      if (locationDenied)
                        PermissionWarningCard(
                          icon: Icons.location_off,
                          title: 'Location Access Required',
                          description:
                              'Enable location to verify task completion',
                          status: locationStatus,
                          onFix: () => locationStatus!.isPermanentlyDenied
                              ? openAppSettings()
                              : ref.refresh(permissionsProvider),
                        ),
                      if (cameraDenied)
                        PermissionWarningCard(
                          icon: Icons.camera_alt,
                          title: 'Camera Access Required',
                          description: 'Enable camera for face verification',
                          status: cameraStatus,
                          onFix: () => cameraStatus!.isPermanentlyDenied
                              ? openAppSettings()
                              : ref.refresh(permissionsProvider),
                        ),
                    ],
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskDetailsSection(task: currentTask),
                        const SizedBox(height: 20),
                        TaskRequirements(task: currentTask),
                        LocationStatusSection(
                          task: currentTask,
                          locationPermissionGranted: !locationDenied,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (currentTask.status == TaskStatus.assigned)
                  Consumer(builder: (context, innerRef, _) {
                    return MyCustomButton(
                      btnText: 'Submit the Result',
                      icon: Icons.done,
                      onClick: () =>
                          _validateAndSubmit(context, innerRef, currentTask),
                    );
                  }),
                const SizedBox(height: 12),
                if (currentTask.status != TaskStatus.assigned &&
                    currentTask.checkIn != null &&
                    currentTask.checkOut == null &&
                    !locationDenied)
                  Consumer(builder: (context, innerRef, _) {
                    return MyCustomButton(
                      btnText: 'Checkout',
                      icon: Icons.logout,
                      onClick: () async {
                        await _checkOut(context, innerRef, currentTask);
                        // innerRef.invalidate(taskListProvider); // refresh tasks
                      },
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkOut(
      BuildContext context, WidgetRef ref, TaskEntities task) async {
    final response =
        await ref.read(taskCompleteCheckoutProvider(task.id ?? '').future);
    response.fold(
      (failure) {
        // handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (successMessage) {
        // handle success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(successMessage)),
        );
      },
    );
  }

  void _validateAndSubmit(
      BuildContext context, WidgetRef ref, TaskEntities task) async {
    final taskParams = ref.read(taskCompletingParamsProvider);
    final notifier = ref.read(taskCompletingParamsProvider.notifier);

    // Update timestamp
    notifier.updateCurrentTime(DateTime.now());

    String? locationError;
    String? imageError;

    if ((task.faceVerification ?? true) && taskParams.image == null) {
      imageError = 'Image proof is required.';
    }

    if (taskParams.location.latitude == 0.0 ||
        taskParams.location.longitude == 0.0) {
      locationError = 'Valid location is required.';
    }

    if (locationError != null) showToastMessage(locationError, false);
    if (imageError != null) showToastMessage(imageError, false);

    if (imageError == null && locationError == null) {
      await ref.read(taskCompleteProvider.notifier).completeTask(taskParams);
    }
  }
}
