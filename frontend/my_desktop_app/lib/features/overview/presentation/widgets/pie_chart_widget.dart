import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/widgets/loading_widget.dart';
import 'package:my_desktop_app/features/overview/presentation/providers/overview_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWidget extends ConsumerWidget {
  final Color primaryColor;
  const PieChartWidget({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(loadEmployeeRollStatisticsProvider);

    return provider.when(
      loading: () => const MyLoadingWidget(),
      error: (error, _) => Center(child: Text(error.toString())),
      data: (data) {
        final chartData = data.roles
            .map((e) => ChartData(e.role.name, e.count.toDouble()))
            .toList();

        final colors = _generateColorPalette(chartData.length, primaryColor);

        return SfCircularChart(
          title: ChartTitle(text: 'Job Distribution'),
          palette: colors,
          
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) =>
                  '${data.x}: ${data.y.toInt()}',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                
                labelPosition: ChartDataLabelPosition.outside,
                overflowMode: OverflowMode.trim,
              ),
              explode: true,
              explodeIndex: 0,
              explodeOffset: '10%',
            ),
          ],
        );
      },
    );
  }

  /// Generates a dynamic color palette from the primary color
  List<Color> _generateColorPalette(int count, Color baseColor) {
    final hslBase = HSLColor.fromColor(baseColor);
    return List.generate(count, (index) {
      final hue = (hslBase.hue + (360 / count) * index) % 360;
      return HSLColor.fromAHSL(
        1.0,
        hue,
        (hslBase.saturation + 0.2).clamp(0.5, 1.0),
        (hslBase.lightness + 0.1).clamp(0.4, 0.7),
      ).toColor();
    });
  }
}

/// Basic chart data model
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
