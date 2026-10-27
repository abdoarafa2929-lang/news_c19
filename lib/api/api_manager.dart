import 'package:dio/dio.dart';
import 'package:news_c19/model/response/article_dm.dart';
import 'package:news_c19/model/response/article_response.dart';
import 'package:news_c19/model/response/sources_response.dart';

abstract final class ApiManager {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://newsapi.org",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  static const String apiKey = "337dc2b5fe7c467aacde1b358cbe785b";
  static const String defaultErrorMessage = "Something went wrong! Please try again.";

  /// Loads available sources for a given category using the existing SourcesResponse DTO
  static Future<List<SourceDM>> loadSources(String category) async {
    try {
      final response = await dio.get(
        "/v2/top-headlines/sources",
        queryParameters: {
          "apiKey": apiKey,
          "category": category.toLowerCase(),
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final sourcesResponse = SourcesResponse.fromJson(response.data);
        if (sourcesResponse.status == "ok" && sourcesResponse.sources != null) {
          return sourcesResponse.sources!;
        }
      }
      throw defaultErrorMessage;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final message = e.response?.data["message"];
        if (message != null) {
          throw message.toString();
        }
      }
      throw e.message ?? defaultErrorMessage;
    } catch (e) {
      rethrow;
    }
  }

  /// Loads news articles for a selected source ID using the existing ArticleResponse DTO
  static Future<List<ArticleDM>> loadArticles(String sourceId) async {
    try {
      final response = await dio.get(
        "/v2/everything",
        queryParameters: {
          "apiKey": apiKey,
          "sources": sourceId,
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final articlesResponse = ArticleResponse.fromJson(response.data);
        if (articlesResponse.status == "ok" &&
            articlesResponse.articles != null) {
          return articlesResponse.articles!;
        }
      }
      throw defaultErrorMessage;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final message = e.response?.data["message"];
        if (message != null) {
          throw message.toString();
        }
      }
      throw e.message ?? defaultErrorMessage;
    } catch (e) {
      rethrow;
    }
  }

  /// Searches news articles dynamically with a query keyword using the existing ArticleResponse DTO
  static Future<List<ArticleDM>> searchArticles(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    try {
      final response = await dio.get(
        "/v2/everything",
        queryParameters: {
          "apiKey": apiKey,
          "q": trimmedQuery,
          "sortBy": "relevancy",
        },
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final articlesResponse = ArticleResponse.fromJson(response.data);
        if (articlesResponse.status == "ok" &&
            articlesResponse.articles != null) {
          return articlesResponse.articles!;
        }
      }
      throw defaultErrorMessage;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final message = e.response?.data["message"];
        if (message != null) {
          throw message.toString();
        }
      }
      throw e.message ?? defaultErrorMessage;
    } catch (e) {
      rethrow;
    }
  }
}
