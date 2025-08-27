import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TaskAssignmentMapDialog extends StatefulWidget {
  final LatLng taskLocation;
  final LatLng? employeeLocation;
  final double radius;

  const TaskAssignmentMapDialog({
    super.key,
    required this.taskLocation,
    this.employeeLocation,
    required this.radius,
  });

  @override
  State<TaskAssignmentMapDialog> createState() =>
      _TaskAssignmentMapDialogState();
}

class _TaskAssignmentMapDialogState extends State<TaskAssignmentMapDialog> {
  bool showMap = false;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => showMap = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Map View',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 400,
            height: 400,
            child: showMap
                ? FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: widget.taskLocation,
                      // initialCenter: LatLng(30.195768, 67.017245),
                      initialZoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.task_manager',
                      ),
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: widget.taskLocation,
                            radius: widget.radius,
                            useRadiusInMeter: true,
                            color: Colors.blue.withOpacity(0.3),
                            borderColor: Colors.blue,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                      if (widget.employeeLocation != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [
                                widget.taskLocation,
                                widget.employeeLocation!
                              ],
                              color: Colors.orange,
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 40,
                            height: 40,
                            point: widget.taskLocation,
                            child: const Icon(Icons.location_on,
                                color: Colors.red),
                          ),
                          if (widget.employeeLocation != null)
                            Marker(
                              width: 40,
                              height: 40,
                              point: widget.employeeLocation!,
                              child: const Icon(Icons.person_pin_circle,
                                  color: Colors.green),
                            ),
                        ],
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              TextButton(
                onPressed: () => _mapController.move(widget.taskLocation, 14),
                child: const Text('Focus Task Location'),
              ),
              if (widget.employeeLocation != null)
                TextButton(
                  onPressed: () =>
                      _mapController.move(widget.employeeLocation!, 14),
                  child: const Text('Focus Employee Location'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
