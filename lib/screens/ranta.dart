import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:template/widgets/navigation_bar.dart';

import '../providers/ranta_state.dart';

class RantaScreen extends StatelessWidget {
  const RantaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RantaState>(
      builder: (context, s, _) {
        final titleStyle = Theme.of(
          context,
        ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w600);

        return Scaffold(
          appBar: AppBar(title: const Text("Ränta")),
          body: SafeArea(
            child: s.loading
                ? const Center(child: CircularProgressIndicator())
                : s.error != null
                ? _ErrorView(
                    message:
                        "Kunde inte hämta räntedata.\n${s.error}\n\nKontrollera API-nyckel/endpoint.",
                    onRetry: () => s.load(),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          s.current != null ? s.fmtPct(s.current!) : "–",
                          style: titleStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.delta != null ? s.fmtDelta(s.delta!) : "–",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),

                        // Graf
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 8, 39, 59),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: s.view.isEmpty
                              ? const Center(child: Text("Ingen data"))
                              : LineChart(_chartData(context, s)),
                        ),

                        const SizedBox(height: 12),

                        // Kalender + dropdowns
                        Row(
                          children: [
                            // Kalenderikon (ikon-only)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                top: 20.0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: s.hasCustomRange
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: IconButton(
                                  onPressed: () => s.pickCustomRange(context),
                                  onLongPress: () => s.clearCustomRange(),
                                  icon: const Icon(
                                    Icons.calendar_today_rounded,
                                    size: 18,
                                  ),
                                  tooltip: s.hasCustomRange
                                      ? '${s.rangeLabel()}\n(Long press to clear)'
                                      : 'Choose date range',
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                ),
                              ),
                            ),

                            // Timespan
                            Expanded(
                              child: _RangeDropdown(
                                label: "Timespan",
                                values: const [
                                  "6 months",
                                  "1 year",
                                  "2 years",
                                  "3 years",
                                  "5 years",
                                  "10 years",
                                ],
                                value: s.range,
                                onChanged: (v) {
                                  if (v == null) return;
                                  s.setRange(v);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Show (aggregation)
                            Expanded(
                              child: _RangeDropdown(
                                label: "Show",
                                values: const [
                                  "Monthly average",
                                  "End of month",
                                ],
                                value: s.agg,
                                onChanged: (v) {
                                  if (v == null) return;
                                  s.setAgg(v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          bottomNavigationBar: Navbar(currentPageIndex: 0, showSelected: false),
        );
      },
    );
  }
}

// ---- fl_chart config ----
LineChartData _chartData(BuildContext context, RantaState s) {
  final spots = <FlSpot>[];
  for (var i = 0; i < s.view.length; i++) {
    spots.add(FlSpot(i.toDouble(), s.view[i].value));
  }

  // lite luft så första/sista etikett inte kapas
  final lastIndex = s.view.isEmpty ? 0 : s.view.length - 1;

  final labelFmtShort = DateFormat('MM/yy');
  final labelFmtLong = DateFormat('yyyy');

  String bottomLabel(double x) {
    final idx = x.round();
    if (idx < 0 || idx >= s.view.length) return '';
    final d = s.view[idx].date;
    return s.view.length <= 15
        ? labelFmtShort.format(d)
        : labelFmtLong.format(d);
  }

  return LineChartData(
    minX: -0.5,
    maxX: lastIndex + 0.5,
    gridData: FlGridData(show: true, drawVerticalLine: false),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 44,
          getTitlesWidget: (v, meta) => Text(
            v.toStringAsFixed(1).replaceAll('.', ','),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: _xInterval(s.view.length),
          getTitlesWidget: (v, meta) => Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              bottomLabel(v),
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
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
        color: Colors.greenAccent,
        dotData: const FlDotData(show: false),
      ),
    ],
  );
}

// dynamisk etikettintervall
double _xInterval(int len) {
  if (len <= 6) return 1;
  if (len <= 24) return 3;
  return 12;
}

// --- Små UI-komponenter (oförändrad) ---
class _RangeDropdown extends StatelessWidget {
  final String label;
  final List<String> values;
  final String value;
  final ValueChanged<String?> onChanged;
  const _RangeDropdown({
    required this.label,
    required this.values,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final menuBg = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: textColor),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: textColor),
          style: TextStyle(color: textColor, fontSize: 14),
          dropdownColor: menuBg,
          items: values
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(color: textColor)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: bg,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("Försök igen"),
            ),
          ],
        ),
      ),
    );
  }
}
