import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/widgets/article_widget.dart';

class ArticlesList extends StatelessWidget {
  final String sourceId;

  const ArticlesList({super.key, required this.sourceId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDM>>(
        future: ApiManager.loadArticles(sourceId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.white),
            );
          } else if (snapshot.hasData) {
            var articles = snapshot.data!;
            return buildArtilcesListView(articles);
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          }
        });
  }

  Widget buildArtilcesListView(List<ArticleDM> articles) {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) =>
            ArticleWidget(articleDM: articles[index]));
  }
}
