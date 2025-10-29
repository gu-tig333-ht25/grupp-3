import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' show FlSpot;
import 'package:http/http.dart' as http;

class PristrendApi {
  // Regioner
  List<Map<String, String>> _regions = [];

  // Kvartal
  List<String> _tidsperioder = [];

  PristrendApi();

  Future<void> init() async {
    await _fetchTidsperioder();
  }

  // Hämtar kvartal från SCB
  Future<void> _fetchTidsperioder() async {
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
        _tidsperioder = List<String>.from(tidVar["values"]);
      } else {
        debugPrint("Fel vid hämtning av kvartal: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Fel vid hämtning av kvartal: $e");
    }
  }

  // Hämtar grafdata baserat på vald region och kvartal
  Future<double> fetchTrendForRegion({
    required String selectedRegionCode,
  }) async {
    // Län
    String filter = "vs:RegionLän99EjAggr";

    // Riksområde
    if (selectedRegionCode.startsWith("00") ||
        selectedRegionCode.startsWith("RIKS")) {
      filter = "vs:Region99Riks11v";
    }

    // Riket
    if (selectedRegionCode.compareTo("00") == 0) {
      filter = "vs:RegionRiket99";
    }

    if (_tidsperioder.isEmpty) {
      await _fetchTidsperioder();
    }

    try {
      final index = _tidsperioder.indexOf(_tidsperioder.last);
      final start = index - 3 < 0 ? 0 : index - 3;

      final kvartalAttHamta = _tidsperioder.sublist(start, index + 1);

      final url = Uri.parse(
        "https://corsproxy.io/?https://api.scb.se/OV0104/v1/doris/sv/ssd/START/BO/BO0501/BO0501B/FastprisPSRegKv",
      );

      final body = {
        "query": [
          {
            "code": "Region",
            "selection": {
              "filter": filter,
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
            "selection": {"filter": "item", "values": kvartalAttHamta},
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

        List<FlSpot> tempList = [];
        for (int i = 0; i < values.length; i++) {
          final raw = values[i]["values"][0];
          final y = double.tryParse(raw) ?? 0.0;
          tempList.add(FlSpot(i.toDouble(), y));
        }
        double pristrend = ((tempList.last.y / tempList.first.y) - 1) * 100;
        return pristrend;
      }
    } catch (e) {
      debugPrint("Fel vid hämtning av grafdata: $e");
    }
    return -99.9;
  }
}
