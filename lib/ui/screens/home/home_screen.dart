import 'package:flutter/material.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:news_c19/ui/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [Icon(Icons.search, color: theme.secondaryColor)],
      ),
      drawer: AppDrawer(showGoToHomeNavigation: false),
    );
  }
}
