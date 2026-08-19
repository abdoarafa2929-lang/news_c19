import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/category_dm.dart';
import 'package:news_c19/model/sources_response.dart';
import 'package:news_c19/ui/screens/news/articles_list.dart';
import 'package:news_c19/ui/screens/news/news_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_drawer.dart';

class NewsScreen extends StatefulWidget {
  final CategoryDM categoryDM;

  const NewsScreen(this.categoryDM, {super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsViewModel viewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadSources(widget.categoryDM.name);
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.categoryDM.name),
          ),
          drawer: AppDrawer(showGoToHomeNavigation: true),
          body: Consumer<NewsViewModel>(
              builder: (context, vm, widget){
                if (viewModel.isLoading) {
                  body = Center(child: CircularProgressIndicator());
                } else if (viewModel.errorMessage.isNotEmpty) {
                  body = Text(
                    viewModel.errorMessage,
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  body = buildTabBar(viewModel.sources);
                }
                return body;
              },
          ),
        ),
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