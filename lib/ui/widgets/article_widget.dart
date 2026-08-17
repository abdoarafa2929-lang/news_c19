import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleDM articleDM;

  const ArticleWidget({super.key, required this.articleDM});

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.secondaryColor),
      ),
      child: Column(
        children: [
          //
          Image.network(articleDM.urlToImage ??
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUsGS3PpKkgaBSZflZbwFkH62EfDp6L-CyCaD1rrhDBQ&s=10"),
          Text(articleDM.title ?? ""),
          Row(children: [
            if (articleDM.author != null) Text("By: ${articleDM.author}"),
            if (articleDM.publishedAt != null)
              Text("By: ${articleDM.publishedAt}"),
          ])
        ],
      ),
    );
  }
}
