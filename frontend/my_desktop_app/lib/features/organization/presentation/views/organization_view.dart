import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/organization_add_card.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/organization_card_widget.dart';
import 'package:my_desktop_app/features/organization/presentation/widgets/show_box.dart';

class OrganizationView extends ConsumerStatefulWidget {
  const OrganizationView({super.key});

  @override
  ConsumerState<OrganizationView> createState() => _OrganizationViewState();
}

class _OrganizationViewState extends ConsumerState<OrganizationView> {
  @override
  void initState() {
    super.initState();
    // Load data when the widget is initialized
    // Future.microtask(() => ref.read(organizationProvider.notifier).read());
    // Future.microtask(
    //     () => ref.read(organizationProvider.notifier).isOrganizationSaved());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizationProvider);
    final notifier = ref.read(organizationProvider.notifier);
    return Scaffold(
      body: _buildBody(state, context, notifier),
      floatingActionButton: (state.selectedOrganization == null)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                FloatingActionButton(
                  onPressed: () => notifier.read(),
                  heroTag: 'refresh',
                  tooltip: 'refresh',
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  onPressed: () =>
                      showMyDialog(context, OrganizationAddWidget()),
                  heroTag: 'add',
                  tooltip: 'add',
                  child: const Icon(Icons.add),
                )
              ],
            )
          : null,
    );
  }

  Widget _buildBody(OrganizationState state, BuildContext context,
      OrganizationNotifier notifier) {
    final loadOrganization = ref.watch(organizationsLoadProvider);
    return loadOrganization.when(
        data: (data) { 
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No organizations found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        showMyDialog(context, OrganizationAddWidget()),
                    child: const Text('Create Organization'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => notifier.read(),

            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getGridColumns(context),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.45, // Adjusts the aspect ratio of the cards
              ),
              itemCount: state.organizations.length,
              itemBuilder: (context, index) {
                final org = state.organizations[index];
                return OrganizationCardWidget(
                  model: org,
                  editFunction: () =>
                      showEditOrganizationDialog(context, notifier, org),
                  deleteFunction: () =>
                      showDeleteConfirmationDialog(context, notifier, org.id),
                );
              },
            ),
          );
          
        },
        error: (error, stack) => Center(
              child: Text(error.toString()),
            ),
        loading: () => Center(
              child: MyLoadingWidget(),
            ));
  }

// Function to determine the number of columns based on screen size
  int _getGridColumns(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return 3; // Show 3 cards per row on large screens
    } else if (width >= 800) {
      return 2; // Show 2 cards per row on medium screens
    } else {
      return 1; // Show 1 card per row on small screens
    }
  }

  @override
  void dispose() {
    // Clear the state when the widget is disposed
    // ref.read(organizationProvider.notifier).clearState();
    super.dispose();
  }
}