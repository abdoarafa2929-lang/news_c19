import 'package:flutter/material.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/widgets/custom_error_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebViewScreen extends StatefulWidget {
  final String articleUrl;
  final String? articleTitle;

  const ArticleWebViewScreen({
    super.key,
    required this.articleUrl,
    this.articleTitle,
  });

  @override
  State<ArticleWebViewScreen> createState() => _ArticleWebViewScreenState();
}

class _ArticleWebViewScreenState extends State<ArticleWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final uri = Uri.tryParse(widget.articleUrl.trim());
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https'))) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid article URL: ${widget.articleUrl}';
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _hasError = false;
                _loadingProgress = 10;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 100;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            // Only flag as fatal if it's the main frame
            if (error.isForMainFrame ?? true) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description.isNotEmpty
                      ? error.description
                      : 'Failed to load article web page.';
                });
              }
            }
          },
        ),
      )
      ..loadRequest(uri);
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _loadingProgress = 0;
    });
    _initWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.articleTitle ?? "Full Article",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.white),
            tooltip: "Reload",
            onPressed: () {
              if (!_hasError) {
                _controller.reload();
              } else {
                _retry();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_hasError)
            CustomErrorWidget(
              errorMessage: _errorMessage.isNotEmpty
                  ? _errorMessage
                  : "Failed to load the article page.",
              onRetry: _retry,
            )
          else
            WebViewWidget(controller: _controller),
          if (_loadingProgress > 0 && _loadingProgress < 100 && !_hasError)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _loadingProgress / 100.0,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                minHeight: 3,
              ),
            ),
        ],
      ),
    );
  }
}
