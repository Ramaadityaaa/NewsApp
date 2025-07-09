import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/article.dart';
import 'detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Box<Article> savedBox;

  @override
  void initState() {
    super.initState();
    savedBox = Hive.box<Article>('saved_news'); // Buka box Hive
  }

  // Hapus berita dari daftar simpan
  void _removeFromSaved(int index) {
    setState(() {
      savedBox.deleteAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berita dihapus dari daftar Baca Nanti')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedArticles =
        savedBox.values.toList(); // Ambil semua artikel tersimpan

    return Scaffold(
      appBar: AppBar(title: const Text('Baca Nanti')),
      body:
          savedArticles.isEmpty
              ? const Center(child: Text('Belum ada berita yang disimpan.'))
              : ListView.builder(
                itemCount: savedArticles.length,
                itemBuilder: (context, index) {
                  final article = savedArticles[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      isThreeLine: true,

                      // Tampilkan gambar jika ada
                      leading:
                          article.imageUrl != null
                              ? Image.network(
                                article.imageUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image_not_supported),

                      // Judul dan deskripsi berita
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Tombol hapus
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFromSaved(index),
                      ),

                      // Navigasi ke detail berita
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(article: article),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
