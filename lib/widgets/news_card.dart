import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/news_provider.dart';
import 'package:template/screens/inapp_browser.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();

    if (newsProvider.isLoading && newsProvider.articles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (newsProvider.articles.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Inga nyheter tillgängliga',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: newsProvider.articles.map((article) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: article.imageUrl != null
                  ? Image.network(
                      article.imageUrl!,
                      width: 60,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.article_outlined),
              title: Text(article.title),
              subtitle: Text(article.sourceName ?? ''),
              onTap: () {
                if (article.url != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InAppBrowserScreen(
                        url: article.url!,
                        title: article.sourceName ?? article.title,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
