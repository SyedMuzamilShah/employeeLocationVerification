import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/provider/main_content_provider.dart';
import 'package:my_desktop_app/core/provider/route_provider.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/core/widgets/my_dialog_box.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_data_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/providers/employee_read_params_provider.dart';
import 'package:my_desktop_app/features/employee/presentation/views/employee_detail_view.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_add_card.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_card_widget.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_error_widget.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_route.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_search_field_widget.dart';
import 'package:my_desktop_app/features/employee/presentation/widgets/employee_state_widget.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';

class MyEmployeeView extends ConsumerStatefulWidget {
  const MyEmployeeView({super.key});

  @override
  ConsumerState<MyEmployeeView> createState() => _MyEmployeeViewState();
}

class _MyEmployeeViewState extends ConsumerState<MyEmployeeView> {
  late TextEditingController _searchController;

  EmployeeReadParams _employeeParams = EmployeeReadParams();

  EmployeeStatus _selectedFilter = EmployeeStatus.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    // Check the organization is selected
    final selectedOrg = ref.watch(organizationProvider).selectedOrganization;

    // If organization is not selected then show the message and return;
    if (selectedOrg == null) {
      return const Center(child: Text("Please select organization first"));
    }
    
    // if the organization is selected so picked the organizationId
    final params = _employeeParams.copyWith(organizationId: selectedOrg.id);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 10,
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: EmployeeStatus.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final status = EmployeeStatus.values[index];
                  final String label = status.name.toUpperCase();
                  final bool isSelected = _selectedFilter == status;
                  return FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => {
                      setState(() {
                        _selectedFilter = status;
                        _employeeParams =
                            _employeeParams.copyWith(status: status.name);
                      })
                    },
                    backgroundColor: isSelected
                        ? _getColorForStatus(label, context)
                        : Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                },
              ),
            ),

            // Search bar with animation
            EmployeeSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              initialParams: _employeeParams,
              onAdvancedSearch: (value) {
                print("Advanced search");
              },
            ),

            // Employee list
            Consumer(builder: (conext, innerRef, _) {
              final employee = ref.watch(loadEmployeeProvider(params));
              return Expanded(
                child: RefreshIndicator(
                  // the function which hit the server
                  onRefresh: () async {
                    ref.invalidate(loadEmployeeProvider);
                  },
                  child: employee.when(
                    loading: () => const Center(child: MyLoadingWidget()),
                    error: (error, stack) => EmployeeErrorWidget(
                      error: error,
                      onRetry: () async {
                        ref.invalidate(loadEmployeeProvider);
                      },
                    ),
                    data: (data) {
                      if (data.isEmpty) {
                        // if the data is empty then this widget is show
                        return EmptyStateWidget(
                          message: 'No ${_selectedFilter.name} employees found',
                          onRefresh: () async {
                            ref.invalidate(loadEmployeeProvider);
                          },
                        );
                      }
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            // On Click the detial of the employee open
                            onTap: () {
                              // Change the route
                              ref.read(routeDisplayProvider.notifier).state =
                                  RouteDisplayItem(
                                      route: EmployeeRoute(
                                name: data[index].employeeId,
                              ));

                              // change the main content
                              mainContentWidget.value =
                                  EmployeeDetailView(employee: data[index]);
                            },
                            child: EmployeeCard(
                              readParams: params,
                              onStatusChanged: null,
                              employee: data[index],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showMyDialog(context, const EmployeeAddWidget()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getColorForStatus(String status, context) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'blocked':
        return Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _employeeParams = _employeeParams.copyWith(searchQuery: value);
    });
  }
}
