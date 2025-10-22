import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pristrend_state.dart';
import 'pristrend_graf.dart';
import 'spara_sökning_knapp.dart';

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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dropdown för region
                Row(
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

                // Dropdown för kvartal/år
                Row(
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
                Expanded(
                  child: chartProvider.spots.isEmpty
                      ? const Center(child: Text("Ingen data"))
                      : PristrendGraf(
                          spots: chartProvider.spots,
                          labels: chartProvider.latest10Quarters,
                        ),
                ),
                // Spara sökning-knapp
                const SaveSearchButton(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}
