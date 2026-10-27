import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/model/response/sources_response.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/widgets/article_bottom_sheet.dart';
import 'package:news_c19/ui/widgets/article_item_widget.dart';
import 'package:news_c19/ui/widgets/custom_error_widget.dart';

class ArticleList extends StatefulWidget {
  final SourceDM sourceDM;

  const ArticleList({super.key, required this.sourceDM});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList>
    with AutomaticKeepAliveClientMixin {
  late Future<List<ArticleDM>> _articlesFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    setState(() {
      _articlesFuture = ApiManager.loadArticles(widget.sourceDM.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<ArticleDM>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2.5,
            ),
          );
        } else if (snapshot.hasError) {
          return CustomErrorWidget(
            errorMessage: snapshot.error.toString(),
            onRetry: _loadArticles,
          );
        } else if (snapshot.hasData) {
          return buildArticlesList(snapshot.data!);
        } else {
          return CustomErrorWidget(
            errorMessage: "No articles found in this source.",
            onRetry: _loadArticles,
          );
        }
      },
    );
  }

  Widget buildArticlesList(List<ArticleDM> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.newspaper_outlined,
              color: AppColors.grey,
              size: 52,
            ),
            const SizedBox(height: 12),
            const Text(
              "No articles found in this source",
              style: TextStyle(color: AppColors.grey, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadArticles,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.black,
              ),
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.black,
      backgroundColor: AppColors.white,
      onRefresh: () async {
        _loadArticles();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final article = list[index];
          return ArticleItemWidget(
            article: article,
            onTap: () => ArticleBottomSheet.show(context, article),
          );
        },
      ),
    );
  }
}
