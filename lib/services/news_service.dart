import 'dart:convert'; // digunakan untuk mengubah data JSON menjadi objek Dart
import 'package:http/http.dart' as http; // package http untuk melakukan request ke API
import '../models/article.dart'; // import model Article yang akan digunakan untuk parsing data

class NewsService {
  final String apiKey = '26fbc21db60e4fc1b3fbb64feaf7231b'; // API key saya dari NewsAPI

  // Method untuk mengambil berita terkini dari NewsAPI
  Future<List<Article>> fetchTopHeadlines() async {
    final String url =
        'https://newsapi.org/v2/everything?q=indonesia&sortBy=publishedAt&language=id&apiKey=$apiKey'; // URL endpoint API: mencari berita dengan kata kunci "indonesia", diurutkan berdasarkan tanggal terbaru, dan berbahasa Indonesia

    final response = await http.get(Uri.parse(url)); 

    if (response.statusCode == 200) {
      final data = json.decode(response.body); 
      final List articlesJson = data['articles']; 
      return articlesJson.map((json) => Article.fromJson(json)).toList(); 
    } else {
      throw Exception('Gagal memuat berita: ${response.body}');
    }
  }
}
