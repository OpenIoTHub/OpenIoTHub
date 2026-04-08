import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用内嵌浏览器（InAppWebView），替代原 `webview_flutter` 场景。
class SimpleEmbeddedBrowserScaffold extends StatefulWidget {
  const SimpleEmbeddedBrowserScaffold({
    super.key,
    required this.initialUrl,
    required this.title,
    this.onOpenInSystemBrowser,
  });

  final String initialUrl;
  final String title;
  final VoidCallback? onOpenInSystemBrowser;

  @override
  State<SimpleEmbeddedBrowserScaffold> createState() =>
      _SimpleEmbeddedBrowserScaffoldState();
}

class _SimpleEmbeddedBrowserScaffoldState
    extends State<SimpleEmbeddedBrowserScaffold> {
  late final InAppWebViewSettings _settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    useShouldOverrideUrlLoading: true,
    allowsInlineMediaPlayback: true,
  );

  InAppWebViewController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.onOpenInSystemBrowser != null)
            IconButton(
              icon: const Icon(Icons.open_in_browser, color: Colors.teal),
              onPressed: widget.onOpenInSystemBrowser,
            ),
        ],
      ),
      body: InAppWebView(
        initialSettings: _settings,
        initialUrlRequest:
            URLRequest(url: WebUri(widget.initialUrl)),
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final u = navigationAction.request.url!;
          if (![
            'http',
            'https',
            'file',
            'chrome',
            'data',
            'javascript',
            'about',
          ].contains(u.scheme)) {
            if (await canLaunchUrl(u)) {
              await launchUrl(u, mode: LaunchMode.externalApplication);
            }
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
      ),
    );
  }
}
