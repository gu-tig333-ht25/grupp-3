import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:template/models/news_article.dart';

class NewsApi {
  static const String _baseUrl = 'https://api.worldnewsapi.com/search-news';
  final String apiKey = dotenv.env['WORLD_NEWS_API_KEY'] ?? '';

  Future<List<NewsArticle>> fetchSwedishHousingNews() async {
    final queryParams = {
      'api-key': apiKey,
      'source-country': 'se',
      'language': 'sv',
      'text': 'bostadsmarknad OR fastigheter OR hyra',
      'sort-direction': 'DESC',
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['news'] == null) {
      return [];
    }

    final List articlesJson = jsonResponse['news'];
    return articlesJson
        .map((article) => NewsArticle.fromJson(article))
        .toList();
  }
}
