import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final container = ProviderContainer();

  final notifier = container.read(testinTaskParamsProvider.notifier);
  final state = container.read(testinTaskParamsProvider);
  notifier.state = state.copyWith(taskId: 'taskId Change');
  notifier.state = state.copyWith(userId: 'userId Change');
  // final state = container.read(testinTaskParamsProvider);
  // // Update state correctly using 'notifier.state = ...'
  // notifier.state =
  //     container.read(testinTaskParamsProvider).copyWith(taskId: 'taskid change');

  // notifier.state =
  //     container.read(testinTaskParamsProvider).copyWith(location: 'Change in next page');

  final updated = container.read(testinTaskParamsProvider);
  print(updated.toJson());
}


final testinTaskParamsProvider = StateProvider((ref) {
  return TestingTaskParams(taskId: '', userId: '', search: '', location: '');
});

final class TestingTaskParams extends Equatable {
  final String taskId;
  final String userId;
  final String search;
  final String location;
  const TestingTaskParams(
      {required this.taskId,
      required this.userId,
      required this.search,
      required this.location});

  TestingTaskParams copyWith(
      {String? taskId, String? userId, String? search, String? location}) {
    return TestingTaskParams(
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        search: search ?? this.search,
        location: location ?? this.location);
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId' : taskId,
      'userId' : userId,
      'search' : search,
      'location' : location
    };
  }

  @override
  List<Object?> get props => [taskId, userId, search, location];
}
