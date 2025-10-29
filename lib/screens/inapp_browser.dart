import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppBrowserScreen extends StatefulWidget {
  final String url;
  final String title;

  const InAppBrowserScreen({super.key, required this.url, required this.title});

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (progress < 1.0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(value: progress),
                ),
              ),
            ),
        ],
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        onProgressChanged: (controller, value) {
          setState(() {
            progress = value / 100;
          });
        },
      ),
    );
  }
}
