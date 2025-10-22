import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/rate_point.dart';
import '../data/riksbanken_api.dart';

class RantaState extends ChangeNotifier {
  // --- UI-state ---
  String range = "3 years"; // "6 months", "1 year", ...
  String agg = "Monthly average"; // "Monthly average" | "End of month"

  // --- Data ---
  List<RatePoint> _all = [];
  List<RatePoint> view = [];
  double? current;
  double? delta;
  DateTime? customFrom;
  DateTime? customTo;

  bool get hasCustomRange => customFrom != null && customTo != null;

  bool loading = true;
  String? error;

  // ---------- Public API ----------
  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final api = RiksbankenApi();
      _all = await api.fetchPolicyRate(from: DateTime(1994, 1, 1));
      _recomputeView();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setRange(String v) {
    range = v;
    // vid byte av dropdown-range: nollställ ev. custom
    customFrom = null;
    customTo = null;
    _recomputeView();
    notifyListeners();
  }

  void setAgg(String v) {
    agg = v;
    _recomputeView();
    notifyListeners();
  }

  void clearCustomRange() {
    customFrom = null;
    customTo = null;
    _recomputeView();
    notifyListeners();
  }

  Future<void> pickCustomRange(BuildContext context) async {
    if (_all.isEmpty) return;
    final first = _all.first.date;
    final last = _all.last.date;

    final initialEnd = last;
    final initialStart = DateTime(initialEnd.year, initialEnd.month - 5, 1);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: first,
      lastDate: last,
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
      helpText: 'Välj datumintervall',
      saveText: 'Använd',
    );

    if (picked != null) {
      customFrom = DateTime(picked.start.year, picked.start.month, 1);
      customTo = DateTime(
        picked.end.year,
        picked.end.month,
        picked.end.day,
        23,
        59,
        59,
      );
      _recomputeView();
      notifyListeners();
    }
  }

  // ---------- Intern logik ----------
  void _recomputeView() {
    if (_all.isEmpty) return;

    final latest = _all.last.date;
    late DateTime fromDate;
    late DateTime toDate;

    if (hasCustomRange) {
      fromDate = customFrom!;
      toDate = customTo!;
    } else {
      final backMonths = _rangeToMonths(range);
      final latestYm = latest.year * 12 + (latest.month - 1);
      final fromYm = latestYm - backMonths;
      final fromYear = fromYm ~/ 12;
      final fromMonth = (fromYm % 12) + 1;
      fromDate = DateTime(fromYear, fromMonth, 1);
      toDate = latest;
    }

    final window = _all
        .where((p) => !p.date.isBefore(fromDate) && !p.date.isAfter(toDate))
        .toList();

    final aggPoints = (agg == "End of month")
        ? _aggregateEndOfMonth(window)
        : _aggregateMonthlyMean(window);

    if (aggPoints.isEmpty) {
      view = [];
      current = null;
      delta = null;
      return;
    }

    view = aggPoints;
    current = view.last.value;
    delta = view.last.value - view.first.value;
  }

  // ---- Aggregatfunktioner ----
  List<RatePoint> _aggregateMonthlyMean(List<RatePoint> points) {
    final buckets = <String, List<double>>{};
    for (final p in points) {
      final key = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}';
      buckets.putIfAbsent(key, () => <double>[]).add(p.value);
    }
    final out = <RatePoint>[];
    buckets.forEach((key, vals) {
      final parts = key.split('-');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final mean = vals.reduce((a, b) => a + b) / vals.length;
      out.add(RatePoint(DateTime(y, m, 1), mean));
    });
    out.sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  List<RatePoint> _aggregateEndOfMonth(List<RatePoint> points) {
    final map = <String, RatePoint>{};
    for (final p in points) {
      final key = '${p.date.year}-${p.date.month.toString().padLeft(2, '0')}';
      final prev = map[key];
      if (prev == null || p.date.isAfter(prev.date)) {
        map[key] = p;
      }
    }
    final out = map.values.toList()..sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  // ---- Helpers ----
  int _rangeToMonths(String r) {
    // "6 months" -> 6, "1 year" -> 12, ...
    final s = r.toLowerCase();
    if (s.contains('month')) {
      final n = int.tryParse(s.split(' ').first) ?? 6;
      return n;
    }
    final n = int.tryParse(s.split(' ').first) ?? 3;
    return n * 12;
  }

  String fmtPct(double v) => '${v.toStringAsFixed(2).replaceAll('.', ',')} %';
  String fmtDelta(double v) {
    final s = (v >= 0 ? '+' : '') + v.toStringAsFixed(2).replaceAll('.', ',');
    return '$s %-enheter';
  }

  String rangeLabel() {
    if (!hasCustomRange) return '';
    final f = DateFormat('yyyy-MM-dd');
    return '${f.format(customFrom!)} – ${f.format(customTo!)}';
  }
}
