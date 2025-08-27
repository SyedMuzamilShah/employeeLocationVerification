import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/core/widgets/loading_widget.dart';
import 'package:my_mobile_app/core/widgets/my_button.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_read_provider.dart';
import 'package:my_mobile_app/features/task/presentation/views/task_complet_view.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/task_card.dart';

class TaskReadView extends ConsumerWidget {
  const TaskReadView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = TaskReadParams();
    final taskState = ref.watch(taskListProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: taskState.when(
        loading: () => const MyLoadingWidget(),
        error: (error, _) {
          String message =
              error is Failure ? error.message : 'Failed to load tasks';
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(message),
                  MyCustomButton(
                    btnText: 'Refresh',
                    onClick: () => ref.invalidate(taskListProvider),
                    icon: Icons.assignment,
                  )
                ],
              ),
            ),
          );
        },
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("No tasks assigned yet"),
                  SizedBox(
                    width: 150,
                    child: MyCustomButton(
                      btnText: 'Refresh',
                      onClick: () => ref.invalidate(taskListProvider),
                      icon: Icons.assignment,
                    ),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(taskListProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                final task = tasks[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskCompleteView(task: task),
                        ),
                      );
                    },
                    child: TaskCard(task: task));
              },
            ),
          );
        },
      ),
    );
  }
}
