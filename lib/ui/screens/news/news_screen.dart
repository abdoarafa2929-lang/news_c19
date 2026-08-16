import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/response/sources_response.dart';
import 'package:news_c19/ui/screens/news/article_list.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General"),
      ),
      body: FutureBuilder<List<SourceDM>>(
          future: ApiManager.loadSources(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return buildTabBar(snapshot.data!, context);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildTabBar(List<SourceDM> sources, BuildContext context) {
    var theme = context.theme;
    return DefaultTabController(
        length: sources.length,
        child: Column(
          children: [
            TabBar(
                isScrollable: true,
                labelColor: theme.secondaryColor,
                labelStyle: theme.textTheme.bodyMedium,
                unselectedLabelStyle: theme.textTheme.bodySmall,
                tabAlignment: TabAlignment.start,
                tabs: sources
                    .map((source) => buildTabItem(
                          source,
                          // sources.indexOf(source) == selectedIndex)
                        ))
                    .toList()),
            Expanded(
              child: TabBarView(
                  children: sources
                      .map((source) => ArticleList(sourceDM: source))
                      .toList()),
            )
          ],
        ));
  }

  Widget buildTabItem(SourceDM source) {
    return Text(source.name ?? "Unknown");
  }
}
