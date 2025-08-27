import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/card_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/line_chart_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/widgets/pie_chart_widget.dart';

class OverView extends ConsumerStatefulWidget {
  const OverView({super.key});

  @override
  ConsumerState<OverView> createState() => _OverViewState();
}

class _OverViewState extends ConsumerState<OverView> {
  String selectedMapLocation = 'QUETTA';
  String selectedTableStatus = 'Completed';
  String selectedFilter = 'Today';

  @override
  Widget build(BuildContext context) {
    return dashboard();
  }


  Widget dashboard() {
    final bool isMobile = MediaQuery.of(context).size.width < 768;

    if (!mounted) return SizedBox.shrink();
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
                      flex: 4,
                      child: MyCardWidget(
                        child: LineChartWidget(primaryColor: Theme.of(context).colorScheme.primary),
                      ),
                    ),
    
                    Expanded(
                      flex: 3,
                      child: MyCardWidget(
                        child: PieChartWidget(
                          primaryColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
