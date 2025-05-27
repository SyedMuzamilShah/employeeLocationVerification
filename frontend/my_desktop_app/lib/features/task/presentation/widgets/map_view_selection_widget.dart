import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/presentation/provider/task_create_provider.dart';

class MapViewWidget extends ConsumerStatefulWidget {
  const MapViewWidget({super.key});

  @override
  ConsumerState<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends ConsumerState<MapViewWidget> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskCreateParamsProvider);
    
    // Move camera to new location when it changes
    if (state.location != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          state.location!.toLatLng(),
          _mapController.camera.zoom,
        );
      });
    }

    return Column(
      children: [
        const Text("Tap on the map to select a location"),
        const SizedBox(height: 10),
        SizedBox(
          height: 400,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: state.location?.toLatLng() ??
                  const LatLng(30.1834, 66.9987),
              initialZoom: 12.0,
              onTap: (_, latLng) {
                final current = ref.read(taskCreateParamsProvider.notifier);
                current.location(LocationModel(
                    latitude: latLng.latitude,
                    longitude: latLng.longitude,
                  ),);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.task_manager',
              ),
              if (state.location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: state.location!.toLatLng(),
                      width: 30,
                      height: 30,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 30),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}