import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:khabar/model/news_model.dart';

class NewsRepository {
  final String apiUrl = "https://newsapi.org/v2/top-headlines?sources=bbc-news";

  Future<NewsModel> fetchNews() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'X-Api-Key':
            '3dd257b2f4344bea8d2f8668dee415f7', // Replace with your actual API key
      },
    );

    if (response.statusCode == 200) {
      return NewsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
