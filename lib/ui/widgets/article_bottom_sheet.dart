import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/utils/app_routes.dart';

class ArticleBottomSheet extends StatelessWidget {
  final ArticleDM article;

  const ArticleBottomSheet({super.key, required this.article});

  static void show(BuildContext context, ArticleDM article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ArticleBottomSheet(article: article),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage?.trim();
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    final snippet = (article.content != null && article.content!.trim().isNotEmpty)
        ? article.content!
        : (article.description != null && article.description!.trim().isNotEmpty
            ? article.description!
            : "No further article content available.");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.white, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dynamic image thumbnail directly from API response payload
          if (hasValidImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 190,
                  color: Colors.grey[900],
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 190,
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.grey,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),

          // Dynamic snippet text from the API model
          Text(
            snippet,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13.5,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),

          // "View Full Article" button that dynamically navigates using article.url
          InkWell(
            onTap: () {
              Navigator.pop(context);
              final articleUrl = article.url?.trim();
              if (articleUrl != null && articleUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  AppRoutes.articleWebView(
                    articleUrl,
                    title: article.source?.name ?? article.title,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Article URL not available from the source"),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              alignment: Alignment.center,
              child: const Text(
                "View Full Article",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
