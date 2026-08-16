import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/model/response/sources_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

class ArticleList extends StatelessWidget {
  final SourceDM sourceDM;

  const ArticleList({super.key, required this.sourceDM});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDM>>(
        future: ApiManager.loadArticles(sourceDM.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString(), style: TextStyle(color: Colors.red),);
          } else if (snapshot.hasData) {
            return buildArticlesList(snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildArticlesList(List<ArticleDM> list) {
    print(list);
    return Container(
      color: Colors.red,
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) =>
              buildArticleItem(context, list[index])),
    );
  }

  Widget buildArticleItem(BuildContext context, ArticleDM article) {
    var theme = context.theme;

    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue,
        border: Border.all(color: theme.secondaryColor, width: 1),
      ),
      child: Column(
        children: [
          Image.network(article.urlToImage ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUsGS3PpKkgaBSZflZbwFkH62EfDp6L-CyCaD1rrhDBQ&s=10"),
          Text(article.title ?? "Unknown"),
          Row(
            children: [
              if (article.author != null) Text("By: ${article.author}"),
              if (article.publishedAt != null) Text(article.publishedAt!)
            ],
          )
        ],
      ),
    );
  }
}
