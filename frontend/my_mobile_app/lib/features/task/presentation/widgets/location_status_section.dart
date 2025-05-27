import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/features/devices/presentation/providers/location_provider.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';
import 'package:my_mobile_app/features/task/presentation/views/google_map_view.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/header_section_card.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/location_status_card.dart';

class LocationStatusSection extends ConsumerWidget {
  final TaskEntities task;
  final bool locationPermissionGranted;

  const LocationStatusSection({
    super.key,
    required this.task,
    required this.locationPermissionGranted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final locationAsync = ref.watch(getCurrentLocationProvider);
    final locationAsync = ref.watch(currentLocationProvider);

    // Params called
    final paramsSet = ref.read(taskCompletingParamsProvider.notifier);

    if (task.status == TaskStatus.verified || task.status == TaskStatus.submitted) {
      return _buildLocationBodySection(context, null);
    }

    if (!locationPermissionGranted) return const SizedBox.shrink();
    return locationAsync.when(
      data: (location) {
        final params = LocationParams(
          longitude: location.longitude!,
          latitude: location.latitude!,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          paramsSet.updateLocation(params);
          paramsSet.updateTaskAssigedId(task.id ?? '');
        });
        return _buildLocationBodySection(context, params);
      },
      loading: () => const MyLoadingWidget(color: Colors.black),
      error: (error, _) => Text("Error: $error"),
    );
  }

  Widget _buildLocationBodySection(BuildContext context, LocationParams? userLocation) {

    if (task.location == null) {
      return Center(child: Text("Task Submited and it's status is : ${task.status?.name}"),);
    }
    final distance = Distance().as(
      LengthUnit.Meter,
      task.employeeLocation?.toLatLng() ?? userLocation!.toLatLng(),
      task.location!.toLatLng(),
    );

    final isWithinRadius = task.aroundDistanceMeter != null &&
        distance <= task.aroundDistanceMeter!;
        
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const SectionHeader(
            title: 'Location Status',
            icon: Icons.location_on,
          ),
          trailing: SizedBox(
            width: 130,
            height: 40,
            child: MyCustomButton(
              btnText: 'View on Map',
              icon: Icons.map,
              onClick: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapTrackingScreen(
                    employeeLocation: task.employeeLocation,
                    taskLocation: task.location!,
                    radius: task.aroundDistanceMeter,
                  ),
                ),
              ),
            ),
          ),
        ),

        // display the current location card with warning in case if the task is not verified
        // if (!(task.status == TaskStatus.verified))
          LocationStatusCard(
            isWithinRadius: isWithinRadius,
            distance: distance,
            radius: task.aroundDistanceMeter!,
          ),
      ],
    );
  }
}
