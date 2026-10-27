import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/category_dm.dart';
import 'package:news_c19/model/response/sources_response.dart';
import 'package:news_c19/ui/screens/news/article_list.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/utils/app_routes.dart';
import 'package:news_c19/ui/widgets/app_drawer.dart';
import 'package:news_c19/ui/widgets/custom_error_widget.dart';

class NewsScreen extends StatefulWidget {
  final CategoryDM categoryDM;
  const NewsScreen(this.categoryDM, {super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<SourceDM>> _sourcesFuture;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  void _loadSources() {
    setState(() {
      _sourcesFuture = ApiManager.loadSources(widget.categoryDM.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      drawer: const AppDrawer(showGoToHomeNavigation: true),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          widget.categoryDM.name,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.white),
            onPressed: () {
              Navigator.push(context, AppRoutes.search());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SourceDM>>(
        future: _sourcesFuture,
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
              onRetry: _loadSources,
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return buildTabBar(snapshot.data!, context);
          } else {
            return CustomErrorWidget(
              errorMessage: "No sources found for ${widget.categoryDM.name}",
              onRetry: _loadSources,
            );
          }
        },
      ),
    );
  }

  Widget buildTabBar(List<SourceDM> sources, BuildContext context) {
    return DefaultTabController(
      length: sources.length,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: AppColors.white,
              indicatorWeight: 2.5,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.grey,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              tabs: sources.map((source) => Tab(text: source.name ?? "Source")).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TabBarView(
              children: sources
                  .map((source) => ArticleList(sourceDM: source))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
