class NewsArticle {
  final String title;
  final String? summary;
  final String? url;
  final String? imageUrl;
  final DateTime? publishDate;
  final String? sourceName;

  NewsArticle({
    required this.title,
    this.summary,
    this.url,
    this.imageUrl,
    this.publishDate,
    this.sourceName,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      summary: json['summary'],
      url: json['url'],
      imageUrl: json['image'],
      publishDate: json['publish_date'] != null
          ? DateTime.tryParse(json['publish_date'])
          : null,
      sourceName: json['source_name'],
    );
  }
}
