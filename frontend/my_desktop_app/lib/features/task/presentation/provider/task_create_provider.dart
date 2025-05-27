import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';

// final taskCreateParamsProvider =
//     StateProvider.autoDispose<TaskCreateParams>((ref) {
//   return TaskCreateParams(
//     title: '',
//     description: '',
//     dueDate: DateTime.now(),
//     organizationId:
//         ref.read(organizationProvider).selectedOrganization?.id ?? '',
//     location: null,
//   );
// });

final taskCreateParamsProvider =
    StateNotifierProvider.autoDispose<TaskCreateParamsNotifier, TaskCreateParams>((ref) {
  return TaskCreateParamsNotifier(ref);
});

class TaskCreateParamsNotifier extends StateNotifier<TaskCreateParams> {
  final Ref ref;
  TaskCreateParamsNotifier(this.ref)
      : super(TaskCreateParams(
            title: '',
            description: '',
            organizationId: ref.read(organizationProvider).selectedOrganization?.id ?? '',
            dueDate: DateTime.now().add(const Duration(minutes: 33)),
            location: null
            ));

  title(String title) {
    state = state.copyWith(title: title);
  }

  description (String description) {
    state = state.copyWith(description: description);
  }

  location (LocationModel location) {
    state = state.copyWith(location: location);
  }

  clearLocation () {
    state = state.copyWith(location: LocationModel(latitude: 0, longitude: 0));
  }

  dueDate (DateTime dueDate) {
    state = state.copyWith(dueDate: dueDate);
  }

  radius (double radius) {
    state = state.copyWith(radius: radius);
  }
}
