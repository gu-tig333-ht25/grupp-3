import 'package:flutter/foundation.dart';
import 'package:template/apis/news_api.dart';
import 'package:template/models/news_article.dart';

class NewsProvider with ChangeNotifier {
  final NewsApi _newsApi = NewsApi();
  List<NewsArticle> _articles = [];
  bool _isLoading = false;
  DateTime? _lastFetchTime;

  final Duration timeToLive = const Duration(minutes: 30);

  List<NewsArticle> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> loadNews({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final fresh = await _newsApi.fetchSwedishHousingNews();
      _articles = fresh;
      _lastFetchTime = DateTime.now();
    } catch (e) {
      debugPrint('ERROR fetching news: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get _isCacheValid {
    if (_articles.isEmpty || _lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < timeToLive;
  }

  Future<void> refresh() async {
    await loadNews(forceRefresh: true);
  }
}
