import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/features/devices/presentation/providers/location_provider.dart';
import 'package:my_mobile_app/features/task/data/models/request/location_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/location_entities.dart';
import 'package:my_mobile_app/features/task/presentation/provider/complete_params_provider.dart';

class MapTrackingScreen extends ConsumerStatefulWidget {
  final LocationEntities? employeeLocation;
  final LocationEntities taskLocation;
  final double? radius;

  const MapTrackingScreen({
    super.key,
    this.employeeLocation,
    required this.taskLocation,
    required this.radius,
  });

  @override
  ConsumerState<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends ConsumerState<MapTrackingScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      // if (event is MapEventMove || event is MapEventRotate || event is MapEventDoubleTapZoom) {
      setState(() {
        _currentZoom = _mapController.camera.zoom;
      });
      // }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationAsync = ref.watch(locationStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Location Tracking'),
        centerTitle: true,
        elevation: 0,
      ),
      body: widget.employeeLocation != null
          ? buildMapBodySection(theme, widget.employeeLocation)
          : locationAsync.when(
              loading: () => const Center(child: MyLoadingWidget()),
              error: (e, s) => Center(
                child: ErrorWidgetWithRetry(
                  error: e.toString(),
                  onRetry: () => ref.refresh(locationStreamProvider),
                ),
              ),
              data: (location) {
                final locationParams = LocationParams(
                    longitude: location.longitude!,
                    latitude: location.latitude!);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref
                      .read(taskCompletingParamsProvider.notifier)
                      .updateLocation(locationParams);
                });
                return buildMapBodySection(theme, locationParams);
              },
            ),
    );
  }

  Widget buildMapBodySection(theme, locationParams) {
    final userLatLng = locationParams.toLatLng();
    final taskLatLng = widget.taskLocation.toLatLng();
    final distance = Distance().as(LengthUnit.Meter, userLatLng, taskLatLng);
    final isWithinRadius = widget.radius != null && distance <= widget.radius!;

    const meterInDegrees = 1 / 111000;
    final delta = widget.radius! * meterInDegrees;

    final bounds = LatLngBounds(
      LatLng(widget.taskLocation.latitude - delta,
          widget.taskLocation.longitude - delta),
      LatLng(widget.taskLocation.latitude + delta,
          widget.taskLocation.longitude + delta),
    );

    // Dynamic marker sizing based on zoom level
    final markerSize = _currentZoom > 14 ? 40.0 : 30.0;
    final iconSize = _currentZoom > 14 ? 24.0 : 18.0;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(100),
            ),
            initialZoom: 16.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.my_mobile_app',
              tileBuilder: (context, widget, tile) {
                return widget;
              },
            ),

            if (widget.radius != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: taskLatLng,
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    borderStrokeWidth: 2,
                    borderColor: theme.colorScheme.primary.withOpacity(0.7),
                    radius: widget.radius!,
                    useRadiusInMeter: true,
                  ),
                ],
              ),

            PolylineLayer(
              polylines: [
                Polyline(
                  points: [userLatLng, taskLatLng],
                  strokeWidth: 2,
                  color: theme.colorScheme.secondary.withOpacity(0.7),
                ),
              ],
            ),

            // Task location marker (rotates with map)
            MarkerLayer(
              rotate: true,
              markers: [
                Marker(
                  point: taskLatLng,
                  width: markerSize,
                  height: markerSize,
                  child: _AnimatedMapMarker(
                    icon: Icons.location_pin,
                    color: theme.colorScheme.primary,
                    size: iconSize,
                  ),
                ),
              ],
            ),

            // User location marker (rotates with map)
            MarkerLayer(
              rotate: true,
              markers: [
                Marker(
                  point: userLatLng,
                  width: markerSize,
                  height: markerSize,
                  child: _AnimatedMapMarker(
                    icon: Icons.person_pin_circle,
                    color:
                        isWithinRadius ? Colors.green : theme.colorScheme.error,
                    size: iconSize,
                  ),
                ),
              ],
            ),
          ],
        ),

        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: _StatusCard(
            distance: distance,
            radius: widget.radius!,
            isWithinRadius: isWithinRadius,
          ),
        ),

        // Map controls
        Positioned(
          right: 20,
          bottom: 120,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: () => _mapController.move(
                  _mapController.camera.center,
                  _mapController.camera.zoom + 1,
                ),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: () => _mapController.move(
                  _mapController.camera.center,
                  _mapController.camera.zoom - 1,
                ),
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedMapMarker extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _AnimatedMapMarker({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale: size / 24, // Base size is 24
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final double distance;
  final double radius;
  final bool isWithinRadius;

  const _StatusCard({
    required this.distance,
    required this.radius,
    required this.isWithinRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Task Location Status',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isWithinRadius ? Icons.check_circle : Icons.error_outline,
                  color:
                      isWithinRadius ? Colors.green : theme.colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatusRow(
              icon: Icons.linear_scale,
              color: theme.colorScheme.secondary,
              text: 'Distance: ${(distance / 1000).toStringAsFixed(2)} km',
            ),
            _StatusRow(
              icon: Icons.radio_button_checked,
              color: theme.colorScheme.primary,
              text: 'Allowed Radius: ${(radius / 1000).toStringAsFixed(2)} km',
            ),
            if (!isWithinRadius) ...[
              const SizedBox(height: 12),
              Text(
                'You need to be within the marked area',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _StatusRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class ErrorWidgetWithRetry extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorWidgetWithRetry({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'Location Error',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
