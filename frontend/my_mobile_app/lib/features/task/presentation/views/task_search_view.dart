import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_read_provider.dart';
import 'package:my_mobile_app/features/task/presentation/provider/task_search_provider.dart';
import 'package:intl/intl.dart';
import 'package:my_mobile_app/features/task/presentation/views/task_complet_view.dart';
import 'package:my_mobile_app/features/task/presentation/widgets/task_card.dart';

class TaskSearchView extends ConsumerWidget {
  const TaskSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final searchParams = ref.watch(taskSearchProvider);
    // final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasks'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(taskSearchProvider.notifier).resetFilters();
              ref.invalidate(taskListProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _SearchField(ref: ref),
                const SizedBox(height: 16),
                _StatusFilter(ref: ref),
                const SizedBox(height: 16),
                _DateFilter(ref: ref),
              ],
            ),
          ),
          Expanded(
            // child: _TaskResultsList(searchParams: searchParams),
            child: _TaskResultsList(),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerWidget {
  final WidgetRef ref;

  const _SearchField({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var searchText =
        ref.read(taskSearchProvider.select((value) => value.search));

    return TextField(
      decoration: InputDecoration(
        labelText: 'Search tasks',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchText != null
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  ref.read(taskSearchProvider.notifier).updateSearch('');
                  ref.invalidate(taskListProvider);
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        ref.read(taskSearchProvider.notifier).updateSearch(value);
        ref.invalidate(taskListProvider);
      },
      controller: TextEditingController(text: searchText ?? ''),
    );
  }
}

class _StatusFilter extends ConsumerWidget {
  final WidgetRef ref;

  const _StatusFilter({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus =
        ref.read(taskSearchProvider.select((value) => value.status));
    // final theme = Theme.of(context);

    return DropdownButtonFormField<TaskStatus>(
      value: currentStatus,
      decoration: InputDecoration(
        labelText: 'Filter by status',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('All Statuses'),
        ),
        ...TaskStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status.name.toUpperCase()),
          );
        }),
      ],
      onChanged: (value) {
        ref.read(taskSearchProvider.notifier).updateStatus(value);
        ref.invalidate(taskListProvider);
      },
    );
  }
}

class _DateFilter extends ConsumerWidget {
  final WidgetRef ref;

  const _DateFilter({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate =
        ref.watch(taskSearchProvider.select((value) => value.dueDate));
    // final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Filter by due date',
              prefixIcon: const Icon(Icons.calendar_today),
              suffixIcon: selectedDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref
                            .read(taskSearchProvider.notifier)
                            .updateDueDate(null);
                        ref.invalidate(taskListProvider);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            controller: TextEditingController(
              text: selectedDate != null
                  ? DateFormat('MMM dd, yyyy').format(selectedDate)
                  : '',
            ),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                ref.read(taskSearchProvider.notifier).updateDueDate(pickedDate);
                ref.invalidate(taskListProvider);
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TaskResultsList extends ConsumerWidget {
  const _TaskResultsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchParams = ref.watch(taskSearchProvider);
    final tasksAsync = ref.watch(taskListProvider(searchParams));

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error: ${error.toString()}'),
      ),
      data: (tasks) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks found matching your criteria'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
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
        );
      },
    );
  }
}
