import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/sources_response.dart';

class NewsViewModel extends ChangeNotifier {
  List<SourceDM> sources = [];
  bool isLoading = false;
  var errorMessage = '';

  loadSources(String category) async {
    try {
      isLoading = true;
      notifyListeners();
      print("loading articles = $category");
      sources = await ApiManager.loadSources(category);
      print("sources = $sources");
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("87- error = $e");
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
