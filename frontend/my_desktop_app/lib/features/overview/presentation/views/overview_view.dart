import 'package:flutter/material.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/card_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/line_chart_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/map_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/pie_chart_widget.dart';

class OverView extends StatefulWidget {
  const OverView({super.key});

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  String selectedMapLocation = 'QUETTA';
  String selectedTableStatus = 'Completed';
  String selectedFilter = 'Today';

  @override
  Widget build(BuildContext context) {
    return dashboard();
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget dashboard() {
    final bool isMobile = MediaQuery.of(context).size.width < 768;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning! I Am Admin, I Ensure Your Location',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // Map Section
          // MyCardWidget(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           _buildDropdown(
          //             value: selectedMapLocation,
          //             items: const ['QUETTA', 'PISHIN', 'KARACHI'],
          //             onChanged: (value) {
          //               setState(() {
          //                 selectedMapLocation = value!;
          //               });
          //             },
          //           ),
          //           const Spacer(),
          //           _buildDropdown(
          //             value: selectedFilter,
          //             items: const ['Today', '1 Week', '1 Month'],
          //             onChanged: (value) {
          //               setState(() {
          //                 selectedFilter = value!;
          //               });
          //             },
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 5),
          //       MapWidget(primaryColor: Colors.blue),
          //       Container(
          //         width: double.infinity,
          //         height: 250,
          //         decoration: BoxDecoration(
          //           color: Theme.of(context).colorScheme.secondary,
          //           borderRadius: BorderRadius.circular(12)
          //         ),
          //         child: const Center(
          //           child: Text('Map Placeholder'),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 24),

          // Charts Row
          isMobile
              ? Column(
                  children: [
                    MyCardWidget(
                      child: LineChartWidget(primaryColor: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    MyCardWidget(
                      child: PieChartWidget(primaryColor: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 3,
                      child: MyCardWidget(
                        child: LineChartWidget(primaryColor: Theme.of(context).colorScheme.primary),
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: MyCardWidget(
                        child: PieChartWidget(
                          primaryColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),

          // // Employee Status Table
          // MyCardWidget(
          //   // padding: EdgeInsets,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(16),
          //         child: Text(
          //           'Employee Status',
          //           style: TextStyle(
          //             fontSize: 20,
          //             fontWeight: FontWeight.bold,
          //             color: Theme.of(context).colorScheme.onSurfaceVariant,
          //           ),
          //         ),
          //       ),
          //       // MyTableWidget(primaryColor: primaryColor),
          //       MyTableWidget(primaryColor: Theme.of(context).colorScheme.primary),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
