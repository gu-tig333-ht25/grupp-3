import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/widgets/navigation_bar.dart';
import '../providers/pristrend_state.dart';
import '../widgets/pristrend_graf.dart';
import '../widgets/spara_sokning_knapp.dart';
import 'package:template/widgets/kpi_card.dart';

class PristrendScreen extends StatelessWidget {
  const PristrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pristrend"), centerTitle: true),
      body: Consumer<ChartProvider>(
        builder: (context, chartProvider, _) {
          if (chartProvider.isLoadingRegions || chartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Dropdown för region
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Område: "),
                      DropdownButton<String>(
                        value: chartProvider.selectedRegionCode,
                        items: chartProvider.regions.map((e) {
                          return DropdownMenuItem(
                            value: e["code"],
                            child: Text(e["name"] ?? ""),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            chartProvider.updateRegion(value);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Dropdown för kvartal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Kvartal: "),
                      DropdownButton<String>(
                        value:
                            chartProvider.selectedQuarter ??
                            chartProvider.tidsperioder.first,
                        items: chartProvider.tidsperioder
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            chartProvider.updateQuarter(value);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Graf
                  SizedBox(
                    height: 220,
                    child: chartProvider.spots.isEmpty
                        ? const Center(child: Text("Ingen data"))
                        : PristrendGraf(
                            spots: chartProvider.spots,
                            labels: chartProvider.latest10Quarters,
                          ),
                  ),
                  const SizedBox(height: 16),

                  KpiCard(
                    title: "Förändring senaste 10 kvartalen",
                    value: chartProvider.totalChangePercent,
                    onPressed: () {},
                    showArrow: false,
                  ),
                  const SizedBox(height: 16),

                  KpiCard(
                    title: "Förändring senaste kvartalet",
                    value: chartProvider.latestQuarterChangePercent,
                    onPressed: () {},
                    showArrow: false,
                  ),
                  const SizedBox(height: 16),

                  // Spara sökning-knapp
                  const SaveSearchButton(),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Navbar(currentPageIndex: 0, showSelected: false),
    );
  }
}
