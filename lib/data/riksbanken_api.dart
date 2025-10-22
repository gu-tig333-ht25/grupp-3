// lib/data/riksbanken_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'rate_point.dart';

class RiksbankenApi {
  static const _seriesId = 'SECBREPOEFF';
  static const String _subscriptionKey = String.fromEnvironment(
    'RIKSBANKEN_KEY',
    defaultValue: '',
  );

  Future<List<RatePoint>> fetchPolicyRate({required DateTime from}) async {
    final url =
        'https://api.riksbank.se/swea/v1/Observations/'
        '$_seriesId/${_d(from)}';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        if (_subscriptionKey.isNotEmpty)
          'Ocp-Apim-Subscription-Key': _subscriptionKey,
      },
    );

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final body = json.decode(res.body);
    final List list = body is List
        ? body
        : (body is Map && body.values.any((v) => v is List))
        ? body.values.firstWhere((v) => v is List) as List
        : <dynamic>[];

    final out = <RatePoint>[];
    for (final e in list) {
      if (e is! Map) continue;
      final ds = (e['date'] ?? e['time'] ?? e['Date'] ?? e['d'] ?? '')
          .toString();
      final rv = (e['value'] ?? e['Value'] ?? e['v']);
      if (ds.isEmpty || rv == null) continue;

      final dt = DateTime.tryParse(ds.length >= 10 ? ds.substring(0, 10) : ds);
      final val = rv is num
          ? rv.toDouble()
          : double.tryParse(rv.toString().replaceAll(',', '.'));
      if (dt != null && val != null) out.add(RatePoint(dt, val));
    }
    out.sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  static String _d(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
