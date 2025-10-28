import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PristrendGraf extends StatelessWidget {
  const PristrendGraf({
    super.key,
    required this.spots,
    required this.labels, // kvartal för x-axeln
  });

  final List<FlSpot> spots;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final yValues = spots.map((e) => e.y).toList();
    final minYValue = (yValues.reduce((a, b) => a < b ? a : b)) - 100;
    final maxYValue = (yValues.reduce((a, b) => a > b ? a : b)) + 100;

    return AspectRatio(
      aspectRatio: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: LineChart(
          LineChartData(
            minY: minYValue < 0 ? 0 : minYValue,
            maxY: maxYValue,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 20,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index == 0 ||
                        index == labels.length - 1 ||
                        index % 5 == 0) {
                      return Text(
                        labels[index],
                        style: const TextStyle(fontSize: 10),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index == meta.min || index == meta.max) {
                      // visa min och maxvärde
                      return Text(
                        index.toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    final yValue = touchedSpot.y.toStringAsFixed(0);
                    final xIndex = touchedSpot.x.toInt();
                    final label = xIndex >= 0 && xIndex < labels.length
                        ? labels[xIndex]
                        : "";
                    return LineTooltipItem(
                      '$label\n$yValue tkr',
                      const TextStyle(fontSize: 12, color: Colors.white),
                    );
                  }).toList();
                },
              ),
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Colors.teal,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
