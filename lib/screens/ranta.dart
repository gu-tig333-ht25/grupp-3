import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/widgets/navigation_bar.dart';
import 'package:template/widgets/kpi_card.dart';
import 'package:template/widgets/ranta_graf.dart';
import 'package:template/widgets/ranta_dropdown.dart';
import 'package:template/widgets/error_view.dart';

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
          appBar: AppBar(title: const Text("Ränta"), centerTitle: true),
          body: SafeArea(
            child: s.loading
                ? const Center(child: CircularProgressIndicator())
                : s.error != null
                ? ErrorView(
                    // ⬅️ extern widget
                    message:
                        "Kunde inte hämta räntedata.\n${s.error}\n\nKontrollera API-nyckel/endpoint.",
                    onRetry: () => s.load(),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Aktuell ränta + delta
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
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: s.view.isEmpty
                              ? const Center(child: Text("Ingen data"))
                              : RateChart(points: s.view), // ⬅️ extern widget
                        ),

                        const SizedBox(height: 12),

                        // Filter (kalender + dropdowns)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    minWidth: 45,
                                    minHeight: 45,
                                  ),
                                ),
                              ),
                            ),

                            // Timespan (smalare)
                            Expanded(
                              flex: 4,
                              child: RangeDropdown(
                                // ⬅️ extern widget
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

                            // Show (bredare)
                            Expanded(
                              flex: 6,
                              child: RangeDropdown(
                                // ⬅️ extern widget
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

                        const SizedBox(height: 16),

                        // KPI-kort: %-enheter (1m / 12m)
                        Column(
                          children: [
                            KpiCard(
                              title: "Förändring senaste månaden",
                              value: s.change1mRaw != null
                                  ? double.parse(
                                      s.change1mRaw!.toStringAsFixed(2),
                                    )
                                  : 0,
                              loading: s.loading,
                              onPressed: () {},
                              showArrow: false,
                            ),
                            const SizedBox(height: 16),
                            KpiCard(
                              title: "Förändring 12 månader",
                              value: s.change1yRaw != null
                                  ? double.parse(
                                      s.change1yRaw!.toStringAsFixed(2),
                                    )
                                  : 0,
                              loading: s.loading,
                              onPressed: () {},
                              showArrow: false,
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
