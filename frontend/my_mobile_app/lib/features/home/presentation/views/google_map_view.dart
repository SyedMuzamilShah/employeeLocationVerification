import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';


class GoogleMapView extends ConsumerWidget {
  final TaskEntities task;
  const GoogleMapView({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

    );
  }
}

