import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/model/response/sources_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleList extends StatelessWidget {
  final SourceDM sourceDM;

  const ArticleList({super.key, required this.sourceDM});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleDM>>(
        future: ApiManager.loadArticles(sourceDM.id!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
              style: TextStyle(color: Colors.red),
            );
          } else if (snapshot.hasData) {
            return buildArticlesList(snapshot.data!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget buildArticlesList(List<ArticleDM> list) {
    if (list.isEmpty) {
      return Center(child: Text("No articles found in this source"));
    }
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) =>
            buildArticleItem(context, list[index]));
  }

  Widget buildArticleItem(BuildContext context, ArticleDM article) {
    var theme = context.theme;
    var dateTime = DateTime.parse(article.publishedAt!);
    
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.secondaryColor, width: 1),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? "",
            height: context.height * .25,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(article.title ?? "Unknown"),
          Row(
            children: [
              if (article.author != null) Expanded(child: Text("By: ${article.author}", style: theme.textTheme.displayMedium)),
              if (article.publishedAt != null) Text(timeago.format(dateTime), style: theme.textTheme.displayMedium,)
            ],
          )
        ],
      ),
    );
  }
}
