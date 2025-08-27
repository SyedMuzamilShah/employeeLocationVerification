import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/providers/overview_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends ConsumerWidget {
  final Color primaryColor;

  const LineChartWidget({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(loadTaskStatisticsProvider);
    
    return provider.when(
        error: (error, _) => ErrorWidget(error),
        loading: () => MyLoadingWidget(),
        data: (data) {
          final chartData = data.map((d) {
            return YearRecord(d.month, d.taskNo.toDouble());
          }).toList();
          
          return SfCartesianChart(
            title: ChartTitle(
              text: 'Organization Task 2025'
            ),
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(fontSize: 12),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: const TextStyle(fontSize: 12),
            ),
            series: <LineSeries<YearRecord, String>>[
              LineSeries<YearRecord, String>(
                dataSource: chartData,
                xValueMapper: (YearRecord sales, _) => sales.month,
                yValueMapper: (YearRecord sales, _) => sales.taskNumber,
                color: primaryColor,
                width: 3,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  borderWidth: 2,
                ),
              ),
            ],
          );
        });
  }
}

class YearRecord {
  final String month;
  final double taskNumber;

  YearRecord(this.month, this.taskNumber);
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
