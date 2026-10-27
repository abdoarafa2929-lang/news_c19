import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/ui/utils/app_colors.dart';
import 'package:news_c19/ui/widgets/article_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleItemWidget extends StatelessWidget {
  final ArticleDM article;
  final VoidCallback? onTap;

  const ArticleItemWidget({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime;
    if (article.publishedAt != null && article.publishedAt!.trim().isNotEmpty) {
      dateTime = DateTime.tryParse(article.publishedAt!);
    }
    final formattedTime =
        dateTime != null ? timeago.format(dateTime) : "Recently";

    final authorName = (article.author != null && article.author!.trim().isNotEmpty)
        ? article.author!.trim()
        : (article.source?.name ?? "Unknown Source");

    final imageUrl = article.urlToImage?.trim();
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

    return InkWell(
      onTap: onTap ?? () => ArticleBottomSheet.show(context, article),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.85),
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic image directly from the API response payload
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasValidImage
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 195,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 195,
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 195,
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.grey,
                            size: 44,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 195,
                      width: double.infinity,
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.grey,
                          size: 44,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 10),

            // Dynamic Headline from API
            Text(
              article.title ?? "No title provided",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            // Dynamic Source Metadata: Author & Published Time
            Row(
              children: [
                Expanded(
                  child: Text(
                    "By : $authorName",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
