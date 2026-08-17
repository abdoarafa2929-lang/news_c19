import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/sources_response.dart';
import 'package:news_c19/ui/screens/news/articles_list.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("General"),
        ),
        body: FutureBuilder<List<SourceDM>>(
            future: ApiManager.loadSources(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.white),
                );
              } else if (snapshot.hasData) {
                var sources = snapshot.data!;
                return buildTabBar(sources);
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.white,
                ));
              }
            }),
      ),
    );
  }

  Widget buildTabBar(List<SourceDM> sources) {
    // var nums = [1, 2 ,3];
    // nums.map((num) => num.toString()).toList()


    var tabs = sources.map((source) => Text(source.name ?? "Unknown")).toList();
    var articlesList =
        sources.map((source) => ArticlesList(sourceId: source.id!)).toList();

    return DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            TabBar(
              tabs: tabs,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
            ),
            Expanded(child: TabBarView(children: articlesList))
          ],
        ));
  }
}
