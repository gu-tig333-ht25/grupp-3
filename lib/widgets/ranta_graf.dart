import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../data/rate_point.dart';

class RateChart extends StatelessWidget {
  final List<RatePoint> points;

  const RateChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return LineChart(_chartData(context, points));
  }
}

LineChartData _chartData(BuildContext context, List<RatePoint> points) {
  // Bygg datapunkter (avrundade till 2 decimaler)
  final spots = <FlSpot>[];
  for (var i = 0; i < points.length; i++) {
    final raw = points[i].value;
    final rounded = double.parse(raw.toStringAsFixed(2));
    spots.add(FlSpot(i.toDouble(), rounded));
  }

  final lastIndex = points.isEmpty ? 0 : points.length - 1;
  final labelFmtShort = DateFormat('MM/yy');
  final labelFmtLong = DateFormat('yyyy');

  String bottomLabel(double x) {
    final idx = x.round();
    if (idx < 0 || idx >= points.length) return '';
    final d = points[idx].date;
    return points.length <= 15
        ? labelFmtShort.format(d)
        : labelFmtLong.format(d);
  }

  // Gemensam stil för axelvärden (matchar x och y)
  final axisLabelStyle = TextStyle(
    fontSize: 11,
    color: Theme.of(context).colorScheme.primary.withAlpha(80),
    fontWeight: FontWeight.w500,
  );

  return LineChartData(
    minX: -0.5,
    maxX: lastIndex + 0.5,

    // Tooltip (bakgrund, typsnitt, placering nära punkten)
    lineTouchData: LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: const Color.fromARGB(255, 8, 39, 59),
        tooltipRoundedRadius: 8,
        // Sätt true/false beroende på om du vill att rutan ska försöka hålla sig inom grafen.
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((barSpot) {
            final yVal = barSpot.y.toStringAsFixed(2).replaceAll('.', ',');
            return LineTooltipItem(
              "$yVal %",
              const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList();
        },
      ),
      // Valfri highlight av punkt/linje när man drar
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((index) {
          return TouchedSpotIndicatorData(
            FlLine(color: Colors.black87, strokeWidth: 1, dashArray: [4, 4]),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, idx) => FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.black87,
              ),
            ),
          );
        }).toList();
      },
    ),

    gridData: FlGridData(show: true, drawVerticalLine: false),

    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 44,
          getTitlesWidget: (v, meta) => Text(
            v.toStringAsFixed(2).replaceAll('.', ','),
            style: axisLabelStyle,
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: _xInterval(points.length),
          getTitlesWidget: (v, meta) => Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(bottomLabel(v), style: axisLabelStyle),
          ),
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    ),

    borderData: FlBorderData(show: false),

    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: false,
        barWidth: 2,
        color: Colors.teal,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(80),
              Theme.of(context).colorScheme.primary.withAlpha(80),
            ],
          ),
        ),
      ),
    ],
  );
}

double _xInterval(int len) {
  if (len <= 6) return 1;
  if (len <= 24) return 3;
  return 12;
}
