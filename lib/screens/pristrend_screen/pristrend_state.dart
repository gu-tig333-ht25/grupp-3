import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class ChartProvider extends ChangeNotifier {
  // Regioner
  List<Map<String, String>> regions = [];
  bool isLoadingRegions = false;

  // Kvartal
  List<String> tidsperioder = [];

  // Grafdata
  List<FlSpot> spots = [];

  // Val
  String? selectedRegionCode;
  String? selectedRegionName;
  String? selectedQuarter;

  List<String> get latest10Quarters {
    if (selectedQuarter == null || tidsperioder.isEmpty) return [];
    final index = tidsperioder.indexOf(selectedQuarter!);
    final start = index - 9 < 0 ? 0 : index - 9;
    return tidsperioder.sublist(start, index + 1);
  }

  bool isLoading = false;

  ChartProvider() {
    fetchInitialData();
  }

  // Initiering: hämta regioner och kvartal, sätt default och hämta graf
  Future<void> fetchInitialData() async {
    await Future.wait([fetchRegions(), fetchTidsperioder()]);

    if (regions.isNotEmpty && tidsperioder.isNotEmpty) {
      // Standard: Stockholms län och senaste kvartalet
      selectedRegionCode ??= "01";
      selectedRegionName ??= regions.firstWhere(
        (r) => r["code"] == "01",
      )["name"];
      selectedQuarter ??= tidsperioder.last;

      await fetchChartData();
    }
  }

  // Hämtar regioner från SCB
  Future<void> fetchRegions() async {
    isLoadingRegions = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.scb.se/OV0104/v1/doris/sv/ssd/START/BO/BO0501/BO0501B/FastprisPSRegKv',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final regionVar = (data["variables"] as List).firstWhere(
          (v) => v["code"] == "Region",
        );
        final codes = List<String>.from(regionVar["values"]);
        final names = List<String>.from(regionVar["valueTexts"]);

        regions = List.generate(
          codes.length,
          (i) => {"code": codes[i], "name": names[i]},
        );
      } else {
        print("Fel vid hämtning av regioner: ${response.statusCode}");
      }
    } catch (e) {
      print("Fel vid hämtning av regioner: $e");
    }

    isLoadingRegions = false;
    notifyListeners();
  }

  // Hämtar kvartal från SCB
  Future<void> fetchTidsperioder() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.scb.se/OV0104/v1/doris/sv/ssd/START/BO/BO0501/BO0501B/FastprisPSRegKv',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final tidVar = (data["variables"] as List).firstWhere(
          (v) => v["code"] == "Tid",
        );
        tidsperioder = List<String>.from(tidVar["values"]);
      } else {
        print("Fel vid hämtning av kvartal: ${response.statusCode}");
      }
    } catch (e) {
      print("Fel vid hämtning av kvartal: $e");
    }

    selectedQuarter ??= tidsperioder.isNotEmpty ? tidsperioder.last : null;
    notifyListeners();
  }

  // Uppdatera region och hämta nya spots
  Future<void> updateRegion(String code) async {
    final region = regions.firstWhere(
      (r) => r["code"] == code,
      orElse: () => regions.first,
    );
    selectedRegionCode = region["code"];
    selectedRegionName = region["name"];
    notifyListeners();
    await fetchChartData();
  }

  // Uppdatera kvartal och hämta nya spots
  Future<void> updateQuarter(String quarter) async {
    selectedQuarter = quarter;
    notifyListeners();
    await fetchChartData();
  }

  // Hämtar grafdata baserat på vald region och kvartal
  Future<void> fetchChartData() async {
    if (selectedRegionCode == null || tidsperioder.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      // Hämta de 10 senaste kvartalen (failsafe om färre finns)
      final index = tidsperioder.indexOf(selectedQuarter ?? tidsperioder.last);
      final start = index - 9 < 0 ? 0 : index - 9;
      final latest10 = tidsperioder.sublist(start, index + 1);

      final url = Uri.parse(
        "https://corsproxy.io/?https://api.scb.se/OV0104/v1/doris/sv/ssd/START/BO/BO0501/BO0501B/FastprisPSRegKv",
      );

      final body = {
        "query": [
          {
            "code": "Region",
            "selection": {
              "filter": "vs:RegionLän99EjAggr",
              "values": [selectedRegionCode],
            },
          },
          {
            "code": "ContentsCode",
            "selection": {
              "filter": "item",
              "values": ["BO0501L3"], // Medelvärde i tkr
            },
          },
          {
            "code": "Tid",
            "selection": {"filter": "item", "values": latest10},
          },
        ],
        "response": {"format": "json"},
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final values = data["data"] as List<dynamic>;

        // Skapa grafpunkter
        spots = [];
        for (int i = 0; i < values.length; i++) {
          final raw = values[i]["values"][0];
          final y = double.tryParse(raw) ?? 0.0;
          spots.add(FlSpot(i.toDouble(), y));
        }
      }
    } catch (e) {
      print("Fel vid hämtning av grafdata: $e");
      spots = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
