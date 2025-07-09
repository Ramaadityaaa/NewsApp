import 'package:hive/hive.dart'; // Import Hive untuk penyimpanan lokal

part 'article.g.dart'; // Menghubungkan file yang dihasilkan oleh build_runner

@HiveType(typeId: 0) // Menandai class sebagai tipe Hive dengan ID 0
class Article extends HiveObject {
  @HiveField(0) // Field disimpan di index 0 dalam Hive
  final String title;

  @HiveField(1) // Field disimpan di index 1
  final String description;

  @HiveField(2) // Field disimpan di index 2 (opsional)
  final String? imageUrl;

  @HiveField(3) // Field disimpan di index 3 (opsional)
  final String? url;

  // Konstruktor untuk membuat objek Article
  Article({
    required this.title,
    required this.description,
    this.imageUrl,
    this.url,
  });

  // Factory constructor untuk membuat Article dari data JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '', // Default ke string kosong jika null
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'],
      url: json['url'],
    );
  }
}
