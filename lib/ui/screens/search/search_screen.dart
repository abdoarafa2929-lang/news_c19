import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/widgets/article_bottom_sheet.dart';
import 'package:news_c19/ui/widgets/article_item_widget.dart';
import 'package:news_c19/ui/widgets/custom_error_widget.dart';

class SearchScreen extends StatefulWidget {
  final List<ArticleDM>? initialArticles;

  const SearchScreen({super.key, this.initialArticles});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  List<ArticleDM> _articles = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialArticles != null) {
      _articles = widget.initialArticles!;
      _hasSearched = _articles.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _hasSearched = false;
        _isLoading = false;
        _errorMessage = null;
        _articles = [];
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchSearchResults(query);
    });
  }

  Future<void> _fetchSearchResults(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final results = await ApiManager.searchArticles(trimmedQuery);
      if (mounted) {
        setState(() {
          _articles = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _isLoading = false;
      _errorMessage = null;
      _articles = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Top Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.search,
                      color: AppColors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _onSearchChanged,
                        onSubmitted: _fetchSearchResults,
                        cursorColor: AppColors.white,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 20,
                      ),
                      splashRadius: 18,
                      onPressed: () {
                        if (_searchController.text.isNotEmpty) {
                          _clearSearch();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Dynamic Results View
            Expanded(
              child: _buildResultsView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.white,
          strokeWidth: 2.5,
        ),
      );
    }

    if (_errorMessage != null) {
      return CustomErrorWidget(
        errorMessage: _errorMessage!,
        onRetry: () => _fetchSearchResults(_searchController.text),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              color: AppColors.grey.withValues(alpha: 0.7),
              size: 64,
            ),
            const SizedBox(height: 14),
            const Text(
              "Type to search news articles and topics",
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppColors.grey,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              "No articles found for \"${_searchController.text.trim()}\"",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 20),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return ArticleItemWidget(
          article: article,
          onTap: () => ArticleBottomSheet.show(context, article),
        );
      },
    );
  }
}
